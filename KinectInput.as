package {
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	
	public class KinectInput {
		private var kinect:Kinect;
		private var kinectSettings:KinectSettings;
		private var kinectSkeleton:KinectSkeleton;
		
		public function KinectInput() {
			if(Kinect.isSupported()) {
				this.kinect = Kinect.getDevice();
				this.kinectSettings = new KinectSettings();
				this.kinectSettings.skeletonEnabled = true;
				this.kinectSkeleton = new KinectSkeleton();
				this.kinect.start(this.kinectSettings);
			} else {
				trace("Kinect not supported.");
			}
		}
		
		private function on_enter_frame() {
			for each(var user:User in this.kinect.usersWithSkeleton) {
				
			}
		}
		
		public function getKinectSkeleton():KinectSkeleton {return this.kinectSkeleton;}
	}
}