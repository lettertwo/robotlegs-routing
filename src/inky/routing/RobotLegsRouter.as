package inky.routing 
{
	import flash.events.Event;
	import inky.routing.IRoute;
	import inky.routing.IRouter;
	import flash.events.IEventDispatcher;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.base.CommandMap;
	import org.robotlegs.core.ICommandMap;
	import inky.routing.IRouter;
	import inky.routing.Route;
	import flash.events.Event;
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import inky.routing.RouteInfo;
	import inky.routing.RoutingParams;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.09.24
	 *
	 */
	public class RobotLegsRouter extends CommandMap implements ICommandMap, IRouter
	{
		private var currentURL:String;
		private var commandClassesToRoutes:Dictionary = new Dictionary();
		private var eventsToCommands:Object = {};
		private var numRoutes:int = 0;
		
		private static var DEFAULT_PARAM_MAP:Function = function (inObj:Object):Object 
		{
			var outObj:Object = {};
			var propName:String;

// FIXME: Yikes, this is some costly stuff. How to improve?
			var typeDescription:XML = describeType(inObj);
			var properties:XMLList = typeDescription.variable + typeDescription.accessor;
			for each (var prop:XML in properties.(@type == "String" || @type == "Number" || @type == "Boolean" || @type == "uint" || @type == "int"))
			{
				propName = prop.@name;
				switch (propName)
				{
					case "eventPhase":
					case "bubbles":
					case "cancelable":
					case "type":
					{
						// ignore event properties.
						if (inObj is Event)
							break;
					}
					default:
					{
						outObj[propName] = inObj[propName];
						break;
					}
				}
			}

			// Also map the enumerable properties.
			for (propName in inObj)
				outObj[propName] = inObj[propName];
			
			return outObj; 
		};
		
		/**
		 *
		 */
		public function RobotLegsRouter(eventDispatcher:IEventDispatcher, injector:IInjector, reflector:IReflector)
		{
			super(eventDispatcher, injector, reflector);
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		override public function mapEvent(eventType:String, commandClass:Class, eventClass:Class = null, oneshot:Boolean = false):void
		{
			this.mapEventWithParams(eventType, commandClass, eventClass, null, null, oneshot);
		}
		
		/**
		 * 
		 */
		public function mapEventWithParams(eventType:String, commandClass:Class, eventClass:Class = null, defaults:Object = null, paramMap:Object = null, oneshot:Boolean = false):void
		{
			eventClass = eventClass || Event;
			var hash:String = this.getHash(eventType, eventClass);
			this.eventsToCommands[hash] = {
				commandClass: commandClass,
				defaults: defaults,
				paramMap: arguments.length > 4 ? paramMap : DEFAULT_PARAM_MAP
			};
			super.mapEvent(eventType, commandClass, eventClass, oneshot);
		}

		/**
		 * @inheritDoc
		 */
		public function mapRoute(pattern:String, commandClass:Class, defaults:Object = null, requirements:Object = null):void
		{
			var route:Route = new Route(pattern, commandClass, defaults, requirements);
			this.commandClassesToRoutes[commandClass] = route;
			this.numRoutes++;
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, this.swfAddress_changeHandler);
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function getHash(eventType:String, eventClass:Class):String
		{
			return describeType(eventClass).@name + "$$$$$$$$$$$" + eventType;
		}

		/**
		 * 
		 */
		private function swfAddress_changeHandler(event:SWFAddressEvent):void
		{
// trace("value:\t" + event.value);
			this.routeURLToCommand("#" + event.value);
		}

		//---------------------------------------
		// Internal
		//---------------------------------------
		
		/**
		 * 
		 */
		protected function routeURLToCommand(url:String):void
		{
			if (url == this.currentURL)
				return;

			this.currentURL = url;
// trace("routing " + url);
			if (this.numRoutes == 0)
				throw new Error("Could not route url \"" + url + "\". No routes have been added.");

			var params:Object;
			for each (var route:IRoute in this.commandClassesToRoutes)
			{
				if ((params = route.match(url)))
				{
					var commandClass:Class = route.commandClass;
					var routingParams:RoutingParams = new RoutingParams(params);
					var routeInfo:RouteInfo = new RouteInfo(route, routingParams);
					this.injector.mapValue(RouteInfo, routeInfo);
					this.injector.mapValue(RoutingParams, routingParams);
					var command:Object = this.injector.instantiate(commandClass);
					this.injector.unmap(RouteInfo);
					this.injector.unmap(RoutingParams);
					command.execute();
					break;
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function routeEventToCommand(event:Event, unused:Class, oneshot:Boolean, originalEventClass:Class):void
		{
			var eventClass:Class = Object(event).constructor;
			if (eventClass != originalEventClass)
				return;

			var hash:String = this.getHash(event.type, eventClass);
// trace(hash);
			var commandInfo:Object = this.eventsToCommands[hash];
			var route:IRoute;

			if (commandInfo && (route = this.commandClassesToRoutes[commandInfo.commandClass]))
			{
				var commandClass:Class = commandInfo.commandClass;

// Map params.
var params:Object = this.clone(commandInfo.defaults) || {};
var prop:String
var mappedParams:Object;
if (commandInfo.paramMap != null)
{
	if (commandInfo.paramMap is Function)
	{
		mappedParams = commandInfo.paramMap(event);
	}
	else
	{
		mappedParams = {};
		for (prop in commandInfo.paramMap)
		{
			mappedParams[prop] = event[commandInfo.paramMap[prop]];
		}
	}
}
for (prop in mappedParams)
{
	params[prop] = mappedParams[prop];
}

				var routingParams:RoutingParams = new RoutingParams(params);
				var routeInfo:RouteInfo = new RouteInfo(route, routingParams);

				// Set up the injection for, create, and execute, the command.
				this.injector.mapValue(RouteInfo, routeInfo);
				this.injector.mapValue(RoutingParams, routingParams);
				this.injector.mapValue(eventClass, event);
				var command:Object = this.injector.instantiate(commandClass);
				this.injector.unmap(RouteInfo);
				this.injector.unmap(RoutingParams);
				this.injector.unmap(eventClass);
				command.execute();
				if (oneshot)
					this.unmapEvent(event.type, commandClass, originalEventClass);

				var url:String = routeInfo.url;
// trace("generated: " + url);
				this.currentURL = url;
				SWFAddress.setValue(url.replace(/^#/, ""));
			}
			else
			{
				super.routeEventToCommand(event, unused, oneshot, originalEventClass);
			}
		}
		
		private function clone(obj:Object):Object
		{
			var clone:Object;

			if (obj === null)
			{
				clone = null;
			}
			else if ((obj is String) || (obj is Number) || (obj is int) || (obj is uint))
			{
				clone = obj;
			}
			else if (obj.constructor == Object)
			{
				clone = {};
				for (var i:String in obj)
				{
					clone[i] = this.clone(obj[i]);
				}
			}
			else
			{
				throw new ArgumentError('Object ' + obj + ' cannot be cloned.');
			}
			
			return clone;
		}
		

	}
	
}