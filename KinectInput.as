package {
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	
	public class KinectInput// {
		private var kinect:Kinect;
		private var kinectSettings:KinectSettings;
		
		public function KinectInput() {
			if(Kinect.isSupported()) {
				this.kinect = Kinect.getDevice();
				this.kinectSettings = new KinectSettings();
				this.kinectSettings.skeletonEnabled = true;
				this.kinect.start(this.kinectSettings);
			} else {
				trace("Kinect not supported.");
			}
		}
		
		private function on_enter_frame() {
			for each(var user:User in this.kinect.usersWithSkeleton) {
				
			}
		}
	}
}