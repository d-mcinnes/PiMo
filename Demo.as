package  {
	import flash.display.Bitmap;
	import flash.display.Stage;
	
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	
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
				
				skeletonContainer = new Sprite();
				stag.addChild(skeletonContainer);
				
				device.addEventListener(CameraImageEvent.DEPTH_IMAGE_UPDATE, depthImageUpdateHandler);
				var settings:KinectSettings = new KinectSettings();
				settings.depthEnabled = true;				
				settings.skeletonEnabled = true;
				
				device.start(settings);
				
				device.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		protected function enterFrameHandler(event:Event) {
			trace("					enterFrameHandler");
			skeletonContainer.graphics.clear();
			for each(var user:User in device.usersWithSkeleton) {
				trace("Position: " + user.position);
			}
		}
		
		protected function depthImageUpdateHandler(event:CameraImageEvent):void {
			depthBitmap.bitmapData = event.imageData;
			skeletonContainer.graphics.clear();
			for each(var user:User in device.usersWithSkeleton) {
				trace("Position: " + user.position.depth);
			}
		}

	}
}
