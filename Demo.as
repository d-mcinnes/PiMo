package  {
	import flash.display.Bitmap;
	import flash.display.Stage;
	
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	
	public class Demo {
		private var depthBitmap:Bitmap;
		private var device:Kinect;
		private var stag:Stage;
		
		public function Demo(stag:Stage) {
			this.stag = stag;
			if(Kinect.isSupported()) {
				device = Kinect.getDevice();
				depthBitmap = new Bitmap();
				stag.addChild(depthBitmap);
				device.addEventListener(CameraImageEvent.DEPTH_IMAGE_UPDATE, depthImageUpdateHandler);
				var settings:KinectSettings = new KinectSettings();
				settings.depthEnabled = true;            
				device.start(settings);
			}
		}
		
		protected function depthImageUpdateHandler(event:CameraImageEvent):void {
			depthBitmap.bitmapData = event.imageData;
		}

	}
}
