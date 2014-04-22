package  {
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import com.as3nui.nativeExtensions.air.kinect.data.User;

	public class KinectSkeleton {
		private var head:Point;
		private var leftElbow:Point;
		private var leftHand:Point;
		private var leftHip:Point;
		private var leftKnee:Point;
		private var leftShoulder:Point;
		private var leftFoot:Point;
		private var neck:Point;
		private var rightElbow:Point;
		private var rightHand:Point;
		private var rightHip:Point;
		private var rightKnee:Point;
		private var rightShoulder:Point;
		private var rightFoot:Point;
		private var torso:Point;
		
		private var skeleton:Sprite;
		
		public function KinectSkeleton() {
			this.skeleton = new Sprite();
		}
		
		private function createLine(point1:Point, point2:Point):void {
			this.skeleton.graphics.lineStyle(1, 0, 1);
			this.skeleton.graphics.moveTo(point1.x, point1.y);
			this.skeleton.graphics.lineTo(point2.x, point2.y);
		}
		
		public function setPoints(user:User):void {
			/*this.setHead(user.head.position.depth);
			this.setLeftElbow(user.leftElbow.position.depth);
			this.setLeftHand(user.leftHand.position.depth);
			this.setLeftHip(user.leftHip.position.depth);
			this.setLeftKnee(user.leftKnee.position.depth);
			this.setLeftShoulder(user.leftShoulder.position.depth);
			this.setNeck(user.neck.position.depth);
			this.setRightElbow(user.rightElbow.position.depth);
			this.setRightHand(user.rightHand.position.depth);
			this.setRightHip(user.rightHip.position.depth);
			this.setRightKnee(user.rightKnee.position.depth);
			this.setRightHip(user.rightHip.position.depth);
			this.setRightShoulder(user.rightShoulder.position.depth);
			this.setTorso(user.torso.position.depth);*/
			
			this.skeleton.graphics.clear();
			while(this.skeleton.numChildren > 0) {
				this.skeleton.removeChildAt(0);
			}
			try {
				/*this.createLine(user.leftElbow.position.depth, user.leftHand.position.depth);
				this.createLine(user.leftShoulder.position.depth, user.leftElbow.position.depth);
				this.createLine(user.torso.position.depth, user.leftKnee.position.depth);
				this.createLine(user.leftKnee.position.depth, user.leftFoot.position.depth);
				this.createLine(user.leftShoulder.position.depth, user.neck.position.depth);
				this.createLine(user.neck.position.depth, user.torso.position.depth);
				this.createLine(user.neck.position.depth, user.head.position.depth);
				this.createLine(user.rightShoulder.position.depth, user.neck.position.depth);
				this.createLine(user.rightElbow.position.depth, user.rightHand.position.depth);
				this.createLine(user.rightShoulder.position.depth, user.rightElbow.position.depth);
				this.createLine(user.torso.position.depth, user.rightKnee.position.depth);
				this.createLine(user.rightKnee.position.depth, user.rightFoot.position.depth);
				trace("Distance W:" + user.position.worldRelative.w + " X:" +
					  user.position.worldRelative.x*1000 + " Y:" +
					  user.position.worldRelative.y + " Z:" +
					  user.position.worldRelative.z);*/
				//trace("HellO");
				this.createLine(this.getLeftElbow(), this.getLeftHand());
				this.createLine(this.getLeftShoulder(), this.getLeftElbow());
				this.createLine(this.getTorso(), this.getLeftKnee());
				this.createLine(this.getLeftKnee(), this.getLeftFoot());
				this.createLine(this.getLeftShoulder(), this.getNeck());
				this.createLine(this.getNeck(), this.getTorso());
				this.createLine(this.getNeck(), this.getHead());
				this.createLine(this.getRightShoulder(), this.getNeck());
				this.createLine(this.getRightElbow(), this.getRightHand());
				this.createLine(this.getRightShoulder(), this.getRightElbow());
				this.createLine(this.getTorso(), this.getRightKnee());
				this.createLine(this.getRightKnee(), this.getRightFoot());
				var headFill:Sprite = new Sprite();
				headFill.graphics.beginFill(0x000000);
				headFill.graphics.drawCircle(this.getHead().x, this.getHead().y, 20);
				headFill.graphics.endFill();
				this.skeleton.addChild(headFill);
			} catch(e:Error) {
				trace("Exception: " + e);
			}
			
			/*this.skeleton.graphics.lineStyle(1, 0, 1);
			this.skeleton.graphics.moveTo(20, 20);
			this.skeleton.graphics.lineTo(60, 60);*/
		}
		
		public function getHead():Point {return this.head;}
		public function getLeftElbow():Point {return this.leftElbow;}
		public function getLeftHand():Point {return this.leftHand;}
		public function getLeftHip():Point {return this.leftHip;}
		public function getLeftKnee():Point {return this.leftKnee;}
		public function getLeftShoulder():Point {return this.leftShoulder;}
		public function getLeftFoot():Point {return this.leftFoot;}
		public function getNeck():Point {return this.neck;}
		public function getRightElbow():Point {return this.rightElbow;}
		public function getRightHand():Point {return this.rightHand;}
		public function getRightHip():Point {return this.rightHip;}
		public function getRightKnee():Point {return this.rightKnee;}
		public function getRightShoulder():Point {return this.rightShoulder;}
		public function getRightFoot():Point {return this.rightFoot;}
		public function getTorso():Point {return this.torso;}
		
		public function setHead(point:Point) {this.head = point;}
		public function setLeftElbow(point:Point) {this.leftElbow = point;}
		public function setLeftHand(point:Point) {this.leftHand = point;}
		public function setLeftHip(point:Point) {this.leftHip = point;}
		public function setLeftKnee(point:Point) {this.leftKnee = point;}
		public function setLeftShoulder(point:Point) {this.leftShoulder = point;}
		public function setLeftFoot(point:Point) {this.leftFoot = point;}
		public function setNeck(point:Point) {this.neck = point;}
		public function setRightElbow(point:Point) {this.rightElbow = point;}
		public function setRightHand(point:Point) {this.rightHand = point;}
		public function setRightHip(point:Point) {this.rightHip = point;}
		public function setRightKnee(point:Point) {this.rightKnee = point;}
		public function setRightShoulder(point:Point) {this.rightShoulder = point;}
		public function setRightFoot(point:Point) {this.rightFoot = point;}
		public function setTorso(point:Point) {this.torso = point;}
		
		public function getSkeleton():Sprite {return this.skeleton;}
	}
}