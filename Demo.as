/**package  {
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.constants.CameraResolution;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.frameworks.mssdk.data.MSSkeletonJoint;
	
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
				settings.depthShowUserColors = true;
				settings.rgbEnabled = true;
				settings.rgbResolution = CameraResolution.RESOLUTION_1280_960;
				settings.skeletonEnabled = true;
				
				//settings.skeletonEnabled = true;
				
				device.start(settings);
				
				device.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				//device.addEventListener(CameraImageEvent.RGB_IMAGE_UPDATE, rgbImageUpdateHandler, false, 0, true);
			}
		}
		
		protected function enterFrameHandler(event:Event) {
			trace("					enterFrameHandler");
			skeletonContainer.graphics.clear();
			for each(var user:User in device.usersWithSkeleton) {
				trace("Position: " + user.position);
				skeletonContainer.graphics.beginFill(0x00ccff);
				for each(var joint:MSSkeletonJoint in user.skeletonJoints) {
					trace("joints :" + joint.name)
					//Draw a circle on all the joints
					skeletonContainer.graphics.drawCircle(joint.position.depth.x, joint.position.depth.y, 15);
				}
			}
		}
		
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
		
		/*protected function layout():void {
			depthBitmap.x = (800 - depthBitmap.width) * .5;
			depthBitmap.y = (600 - depthBitmap.height) * .5;
		}

	}
}**/



package {
	import com.as3nui.nativeExtensions.air.kinect.constants.CameraResolution;
	import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceErrorEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceInfoEvent;
	import com.as3nui.nativeExtensions.air.kinect.frameworks.mssdk.data.MSSkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import com.as3nui.nativeExtensions.air.kinect.data.Position;
	import flash.geom.Point;
	 
	/**
	* ...
	* @author John Stejskal
	*  Johnstejskal@gmail.com
	*  www.johnstejskal.com
	*/
	public class Demo extends Sprite {
		private var kinect:Kinect;
		private var cameraBitmap:Bitmap;
		private var skeletonHolder:Sprite;
		private var stag:Stage;
		
		private var leftHand:SkeletonPoint;
		private var rightHand:SkeletonPoint;
	 
		public function Demo(stag:Stage):void {
			this.stag = stag;
			stag.displayState = StageDisplayState.FULL_SCREEN
			
			//check if the kinect is supported
			if (Kinect.isSupported()) {
				//establish the kinect device
				kinect = Kinect.getDevice();
			 	
				//declare bitmap that will hold the camera data
				cameraBitmap = new Bitmap();
				stag.addChild(cameraBitmap);
				 
				//Create an empty spite which will hold out joins/bones
				skeletonHolder = new Sprite();
				stag.addChild(skeletonHolder);
				 
				//add a kinect rbg update listener (this fires every time the camera frame updates)
				kinect.addEventListener(CameraImageEvent.RGB_IMAGE_UPDATE, rbg_update, false, 0, true);
				
				//listen to when the kinect is ready
				kinect.addEventListener(DeviceEvent.STARTED, kinectStarted);
				
				//Core settings, these will determin how the device behaves, what it see's and what it ignores.
				var settings:KinectSettings = new KinectSettings();
				settings.rgbEnabled = true;
				settings.rgbResolution = CameraResolution.RESOLUTION_1280_960;
				settings.depthEnabled = true;
				settings.depthResolution = CameraResolution.RESOLUTION_1280_960;
				settings.depthShowUserColors = true;
				settings.skeletonEnabled = true;
				kinect.start(settings);
				
				this.stag.addChild(this.leftHand = new SkeletonPoint());
				this.stag.addChild(this.rightHand = new SkeletonPoint());
												
				//add the main loop in which the skeleton updates
				addEventListener(Event.ENTER_FRAME, on_enterFrame, false, 0, true);
			} else {
				trace("device is not supported");
			}
		}
		
		/*private function create_joint(point:Point) {
			var point:SkeletonPoint = new SkeletonPoint();
			point.x = point.x;
			point.y = point.y;
			this.stag.addChild(point);
		}*/
		
		private function move_joint(joint:SkeletonPoint, point:Point) {
			joint.x = point.x;
			joint.y = point.y;
		}
		
		/*private function clear_stage() {
			while(this.stag.numChildren > 0) {
				this.stag.removeChildAt(0);
			}
		}*/
		 
		private function on_enterFrame(e:Event):void {
			//clear all dots to make way for new ones
			//trace("On Enter Frame"	);
			skeletonHolder.graphics.clear();
			/*var circleColor:uint = 0xCCCCCC;
			var radius:uint = 24;
			var circle:Shape = new Shape();*/
			
			/*while(this.stag.numChildren > 0)
    			this.stag.removeChildAt(0);
			}*/
			 
			//loop through all skeletons in frame, up to 2 with as3Nui.
			//trace("Hello");
			for each(var user:User in kinect.usersWithSkeleton) {
				/*var point:SkeletonPoint = new SkeletonPoint();
				point.x = user.leftHand.position.depth.x;
				point.y = user.leftHand.position.depth.y;
				this.stag.addChild(point);*/
				trace("Left Hand: " + user.leftHand.position.depth + " Right Hand: " + user.rightHand.position.depth +
					  " Head: " + user.head.position.depth + " Chest: " + user.position.depth);
				move_joint(this.leftHand, user.leftHand.position.depth);
				move_joint(this.rightHand, user.rightHand.position.depth);
				//create_joint(user.leftHand.position.depth);
				//create_joint(user.rightHand.position.depth);
				/*circle.graphics.beginFill(circleColor);
				circle.graphics.drawCircle(radius, radius, radius);
				circle.graphics.endFill();
				this.stag.addChild(circle);*/
				/*skeletonHolder.graphics.beginFill(0x00ccff);
				for each(var joint:MSSkeletonJoint in user.skeletonJoints) {
			 		trace("joints :"+joint.name)
			 		//Draw a circle on all the joints
					skeletonHolder.graphics.drawCircle(joint.position.depth.x, joint.position.depth.y, 15 );
				}*/
			 
				//-------------------o
				//Points for tracking
				
				/*
				user.leftHand.position.depth;
				user.rightHand.position.depth;
				
				user.head.position.depth;
				
				user.rightHip.position.depth;
				user.leftHip.position.depth;
				
				user.rightShoulder.position.depth;
				user.leftShoulder.position.depth;
				
				user.leftElbow.position.depth;
				user.rightElbow.position.depth;
				
				user.neck.position.depth;
				*/
				
				//-------------------o
				//Some other useful info
				
				//trace(user.hasSkeleton);
				//trace(user.position.world);
			
			}
		}
		
		//udates the camera feed
		private function rbg_update(event:CameraImageEvent):void {
			cameraBitmap.bitmapData = event.imageData;
		}
		 
		private function kinectStarted(e:DeviceEvent):void {
			trace("kinect has started");
		}
	}
}