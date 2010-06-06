package inky.mvcs 
{
	import flash.display.DisplayObjectContainer;
	import inky.routing.IRouter;
	import inky.routing.RobotLegsRouter;
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.mvcs.Context;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.06.03
	 *
	 */
	public class RoutingContext extends Context
	{
		/**
		 * @private
		 */
		protected var _router:IRouter;
		
		/**
		 * @private
		 */
		protected var __commandMap:ICommandMap;

		/**
		 *
		 */
		public function RoutingContext(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true)
		{
			super(contextView, autoStartup);
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * The <code>ICommandMap</code> for this <code>IContext</code>
		 */
		override protected function get commandMap():ICommandMap
		{
			return this.__commandMap || (this.__commandMap = super.commandMap = ICommandMap(this.router));
		}
		/**
		 * @private
		 */
		override protected function set commandMap(value:ICommandMap):void
		{
			this.__commandMap = super.commandMap = value;
		}
		
		/**
		 * The <code>IRouter</code> for this <code>IContext</code>
		 */
		protected function get router():IRouter
		{
			return this._router || (this._router = new RobotLegsRouter(this.eventDispatcher, this.injector, this.reflector));
		}
		/**
		 * @private
		 */
		protected function set router(value:IRouter):void
		{
			this._router = value;
		}

	}
	
}