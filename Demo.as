package  {
	import flash.display.Bitmap;
	import flash.display.Stage;
	
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.constants.CameraResolution;
	
	public class Demo {
		private var depthBitmap:Bitmap;
		private var device:Kinect;
		private var stag:Stage;
		private var skeletonContainer:Sprite;
		
		public function Demo(stag:Stage) {
			this.stag = stag;
			if(Kinect.isSupported()) {
				device = Kinect.getDevice();
				depthBitmap = new Bitmap();
				stag.addChild(depthBitmap);
				
				//skeletonContainer = new Sprite();
				//stag.addChild(skeletonContainer);
				
				//device.addEventListener(CameraImageEvent.DEPTH_IMAGE_UPDATE, depthImageUpdateHandler);
				var settings:KinectSettings = new KinectSettings();
				settings.depthEnabled = true;
				
				settings.rgbEnabled = true;
				settings.rgbResolution = CameraResolution.RESOLUTION_1280_960;
				
				//settings.skeletonEnabled = true;
				
				device.start(settings);
				
				//device.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				device.addEventListener(CameraImageEvent.RGB_IMAGE_UPDATE, rgbImageUpdateHandler, false, 0, true);
			}
		}
		
		/*protected function enterFrameHandler(event:Event) {
			trace("					enterFrameHandler");
			skeletonContainer.graphics.clear();
			for each(var user:User in device.usersWithSkeleton) {
				trace("Position: " + user.position);
			}
		}*/
		
		protected function rgbImageUpdateHandler(event:CameraImageEvent):void {
			depthBitmap.bitmapData = event.imageData;
			layout();
		}
		
		/*protected function depthImageUpdateHandler(event:CameraImageEvent):void {
			depthBitmap.bitmapData = event.imageData;
			//skeletonContainer.graphics.clear();
			for each(var user:User in device.usersWithSkeleton) {
				trace("Position: " + user.position.depth);
			}
		}*/
		
		protected function layout():void {
			depthBitmap.x = (800 - depthBitmap.width) * .5;
			depthBitmap.y = (600 - depthBitmap.height) * .5;
		}

	}
}
