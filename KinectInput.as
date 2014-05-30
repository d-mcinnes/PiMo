package {
	import flash.debug.Debug;
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.sampler.StackFrame;
	
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.constants.CameraResolution;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceEvent;
	
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceErrorEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceInfoEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.PointCloudEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.UserEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.UserFrameEvent;
	
	public class KinectInput {
		private var kinect:Kinect;
		private var kinectSettings:KinectSettings;
		private var kinectSkeleton:KinectSkeleton;
		private var depthBitmap:Bitmap;
		//private var gameController:GameController;
		
		public function KinectInput() {
			if(Kinect.isSupported()) {
				this.kinect = Kinect.getDevice();
				
				this.kinectSettings = new KinectSettings();
				this.kinectSettings.depthEnabled = true;
				this.kinectSettings.depthShowUserColors = true;
				this.kinectSettings.rgbEnabled = true;
				this.kinectSettings.rgbResolution = CameraResolution.RESOLUTION_1280_960;
				this.kinectSettings.skeletonEnabled = true;
				this.kinectSkeleton = new KinectSkeleton();
				this.kinectSkeleton.getSkeleton().x = 20;
				this.kinectSkeleton.getSkeleton().y = 400;
				
				// Listen to when the kinect is ready
				this.kinect.addEventListener(DeviceEvent.STARTED, kinectStarted);
				
				// Depth Update
				this.kinect.addEventListener(CameraImageEvent.DEPTH_IMAGE_UPDATE, depthImageUpdateHandlerInitial);
				this.kinect.addEventListener(UserEvent.USERS_ADDED, kinectUserAdded);
				this.kinect.addEventListener(UserEvent.USERS_REMOVED, kinectUserRemoved);
				this.kinect.addEventListener(UserEvent.USERS_WITH_SKELETON_ADDED, kinectSkeletonAdded);
				
				// Start Kinect
				this.kinect.start(this.kinectSettings);
			} else {
				Debug.debugMessage("Kinect not supported");
			}
		}
		
		private function kinectUserAdded(e:UserEvent) {
			Debug.debugMessage("Resuming game");
			GameController.getInstance().resumeGame();
		}
		
		private function kinectUserRemoved(e:UserEvent) {
			Debug.debugMessage("Pausing game");
			GameController.getInstance().pauseGame("Enter the playing area to resume the game.");
		}
		
		protected function kinectSkeletonAdded(e:UserEvent) {
			Debug.debugMessage("User Skeleton Added");
		}
		
		/** Runs when the Kinect has been successfuly started. **/
		private function kinectStarted(e:DeviceEvent):void {
			Debug.debugMessage("Kinect has Started");
		}
		
		/** Runs when the RGB Image is updated. **/
		protected function rgbImageUpdateHandler(event:CameraImageEvent):void {
			depthBitmap.bitmapData = event.imageData;
		}
		
		/** Runs the first time the Depth Image is updated, then destroys
		 ** the events hanlder. **/
		protected function depthImageUpdateHandlerInitial(e:CameraImageEvent):void {
			for each(var user:User in this.kinect.usersWithSkeleton) {
				this.setKinectSkeletonPoints(user);
			}
			GameController.getInstance().initialisePlayerSkeleton();
			this.kinect.removeEventListener(CameraImageEvent.DEPTH_IMAGE_UPDATE, depthImageUpdateHandlerInitial);
			this.kinect.addEventListener(CameraImageEvent.DEPTH_IMAGE_UPDATE, depthImageUpdateHandler);
		}
		
		/** Runs when the Depth Image is updated. **/
		protected function depthImageUpdateHandler(event:CameraImageEvent):void {
			for each(var user:User in this.kinect.usersWithSkeleton) {
				this.setKinectSkeletonPoints(user);
				GameController.getInstance().renderPlayer();
				GameController.getInstance().checkForSceneryInteraction(user.leftHand.position.depthRelative, 
															   user.rightHand.position.depthRelative);
			}
		}
		
		private function setKinectSkeletonPoints(user:User) {
			this.kinectSkeleton.setHead(user.head.position.depth);
			this.kinectSkeleton.setLeftElbow(user.leftElbow.position.depth);
			this.kinectSkeleton.setLeftHand(user.leftHand.position.depth);
			this.kinectSkeleton.setLeftHip(user.leftHip.position.depth);
			this.kinectSkeleton.setLeftKnee(user.leftKnee.position.depth);
			this.kinectSkeleton.setLeftShoulder(user.leftShoulder.position.depth);
			this.kinectSkeleton.setLeftFoot(user.leftFoot.position.depth);
			this.kinectSkeleton.setNeck(user.neck.position.depth);
			this.kinectSkeleton.setRightElbow(user.rightElbow.position.depth);
			this.kinectSkeleton.setRightHand(user.rightHand.position.depth);
			this.kinectSkeleton.setRightHip(user.rightHip.position.depth);
			this.kinectSkeleton.setRightKnee(user.rightKnee.position.depth);
			this.kinectSkeleton.setRightShoulder(user.rightShoulder.position.depth);
			this.kinectSkeleton.setRightFoot(user.rightFoot.position.depth);
			this.kinectSkeleton.setTorso(user.torso.position.depth);
			this.kinectSkeleton.setPositionRelative(user.position.depthRelative);
			this.kinectSkeleton.setDistance(user.position.worldRelative);
		}
		
		public function getKinectSkeleton():KinectSkeleton {return this.kinectSkeleton;}
		public function getNumberOfUsers():Number {return this.kinect.users.length;}
		
		/** Cleanup function, cleans up and removes all the event listenrs
		 ** for the Kinect. **/
		public function kinectInputCleanup() {
			try {
				this.kinect.removeEventListener(DeviceEvent.STARTED, kinectStarted);
				this.kinect.removeEventListener(CameraImageEvent.DEPTH_IMAGE_UPDATE, depthImageUpdateHandler);
				this.kinect = null;
				Debug.debugMessage("Cleaning up Kinect");
			} catch(e:Error) {
				Debug.debugMessage("Error cleaning up Kinect [" + e + "]");
			}
		}
	}
}