package inky.routing 
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.05.28
	 *
	 */
	dynamic public class RoutingParams
	{
		/**
		 *
		 */
		public function RoutingParams(params:Object = null)
		{
			if (params)
			{
				for (var prop:String in params)
				{
					this[prop] = params[prop];
				}
			}
		}

	}
	
}
