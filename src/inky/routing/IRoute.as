package inky.routing 
{
	import flash.events.Event;

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
	public interface IRoute
	{
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------

		/**
		 * 
		 */
		function get commandClass():Class;

		/**
		 *
		 */
		function get defaults():Object;

		/**
		 *
		 */
		function get requirements():Object;

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Generates a url for this route using the provided options Object.
		 * Returns the url associated with this Route, with the dynamic parts
		 * replaced with the values in the options object.	
		 */
		function generateAddress(request:Object = null):String;

		/**
		 *	Matches the route against the URL. If the provided URL doesn't match
		 *  the route, this function returns null. Otherwise, a key-value map
		 *  of params is returned.
		 */
		function match(url:String):Object;
	}
	
}