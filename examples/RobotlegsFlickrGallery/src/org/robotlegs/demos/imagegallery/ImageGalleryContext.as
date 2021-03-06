/*
   Inversion of Control/Dependency Injection Using Robotlegs
   Image Gallery

   Any portion of this demonstration may be reused for any purpose where not
   licensed by another party restricting such use. Please leave the credits intact.

   Joel Hooks
   http://joelhooks.com
   joelhooks@gmail.com
 */
package org.robotlegs.demos.imagegallery
{
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.demos.imagegallery.controller.*;
	import org.robotlegs.demos.imagegallery.events.*;
	import org.robotlegs.demos.imagegallery.models.GalleryModel;
	import org.robotlegs.demos.imagegallery.remote.services.*;
	import org.robotlegs.demos.imagegallery.views.components.*;
	import org.robotlegs.demos.imagegallery.views.mediators.*;
	import inky.mvcs.RoutingContext;

	public class ImageGalleryContext extends RoutingContext
	{
		public function ImageGalleryContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup():void
		{
router.mapRoute("#/:searchTerm", LoadSearchGalleryCommand);
//router.mapRoute("#/:searchTerm", LoadSearchGalleryCommand);
//router.mapRoute("#/:searchTerm/:index", SetSelectedImageComand);
/*router.mapRoute("#/:gallery", LoadSearchGalleryCommand);
router.mapRoute("#/:image", SetSelectedImageCommand);*/


//map controller
/*router.mapEventWithParams(GalleryEvent.GALLERY_LOADED, UpdateGalleryCommand, GalleryEvent);
router.mapEventWithParams(GalleryImageEvent.SELECT_GALLERY_IMAGE, SetSelectedImageCommand, GalleryImageEvent);
router.mapEventWithParams(GalleryEvent.LOAD_GALLERY, LoadGalleryCommand, GalleryEvent);
router.mapEventWithParams(GallerySearchEvent.SEARCH, LoadSearchGalleryCommand, GallerySearchEvent);*/


			//map controller
			commandMap.mapEvent(GalleryEvent.GALLERY_LOADED, UpdateGalleryCommand, GalleryEvent);
			commandMap.mapEvent(GalleryImageEvent.SELECT_GALLERY_IMAGE, SetSelectedImageCommand, GalleryImageEvent);
			commandMap.mapEvent(GalleryEvent.LOAD_GALLERY, LoadGalleryCommand, GalleryEvent);
router.mapEventWithParams(GallerySearchEvent.SEARCH, LoadSearchGalleryCommand, GallerySearchEvent);
			
			//map model
			injector.mapSingleton( GalleryModel );
			
			//map service
			injector.mapSingletonOf( IGalleryImageService, FlickrImageService );
			//injector.mapSingletonOf( IGalleryImageService, XMLImageService );
			
			//map view
			mediatorMap.mapView(GalleryView, GalleryViewMediator);
			mediatorMap.mapView(GallerySearch, GallerySearchMediator);
			mediatorMap.mapView(GalleryLabel, GalleryLabelMediator);
		}
	}
}