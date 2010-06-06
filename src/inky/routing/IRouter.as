package inky.routing 
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.10.22
	 *
	 */
	public interface IRouter
	{
		
		
		/**
		 *	Map a Class to a url route.
		 * 
		 *  <p>The <code>commandClass</p> must implement an execute() method</p>
		 * 
		 * @param pattern A rails-style url patterm that begins with the hash symbol. (i.e. #/a/b/:myVar)
		 * @param commandClass The Class to instantiate - must have an execute() method
		 */
		function mapRoute(pattern:String, commandClass:Class, defaults:Object = null, requirements:Object = null):void;
	
		
		/**
		 * Map a command class to an event, and provide parameters for routing.
		 * 
		 * @param eventType The Event type to listen for
		 * @param commandClass The Class to instantiate - must have an execute() method
		 * @param eventClass Optional Event class for a stronger mapping. Defaults to <code>flash.events.Event</code>. Your commandClass can optionally [Inject] a variable of this type to access the event that triggered the command.
		 * @param defaults Optional default values for the routing parameters.
		 * @param paramMap Optional mapping for generating routing parameters. If a function is passed, the function must take an event as its argument, and it should return a map of parameter values. If a map object is provided, properties on the event will be mapped to the routing parameters according to the map (ex: {propNameOnRoutingParms: "propNameOnEvent"}).
		 * @param oneshot Unmap the Class after execution?
		 */
		function mapEventWithParams(eventType:String, commandClass:Class, eventClass:Class = null, defaults:Object = null, paramMap:Object = null, oneshot:Boolean = false):void;
		

		/**
		 * 
		 */
//		function unmapRoute(route:String, commandClass:Class):void;


		/**
		 *	
		 */
//		function route(request:Object):Object;
		
	}
	
}