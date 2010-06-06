package org.robotlegs.demos.imagegallery.controller
{
	import org.robotlegs.demos.imagegallery.remote.services.IGalleryImageService;
	import org.robotlegs.mvcs.Command;

	public class LoadGalleryCommand extends Command
	{
		[Inject]
		public var service:IGalleryImageService;
				
		override public function execute():void
		{
			service.loadGallery();
		}
	}
}