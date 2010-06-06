package org.robotlegs.demos.imagegallery.controller
{
	import org.robotlegs.demos.imagegallery.remote.services.IGalleryImageService;
	import org.robotlegs.demos.imagegallery.events.GallerySearchEvent;
	import org.robotlegs.mvcs.Command;
	import inky.routing.RoutingParams;

	public class LoadSearchGalleryCommand extends Command
	{
		[Inject]
		public var params:RoutingParams;
		
		[Inject]
		public var service:IGalleryImageService;
		
		override public function execute():void
		{
			service.search(params.searchTerm);
		}
	}
}