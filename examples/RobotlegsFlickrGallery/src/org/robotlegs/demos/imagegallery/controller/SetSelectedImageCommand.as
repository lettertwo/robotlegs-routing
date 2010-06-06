package org.robotlegs.demos.imagegallery.controller
{
	import org.robotlegs.demos.imagegallery.events.GalleryImageEvent;
	import org.robotlegs.demos.imagegallery.models.GalleryModel;
	import org.robotlegs.mvcs.Command;
	import inky.routing.RoutingParams;

	public class SetSelectedImageCommand extends Command
	{
		[Inject]
		public var event:GalleryImageEvent;
//		public var params:RoutingParams;
		
		[Inject]
		public var proxy:GalleryModel;
		
		override public function execute():void
		{
			if(event.image)
				proxy.setSelectedImage(event.image);
		}
	}
}