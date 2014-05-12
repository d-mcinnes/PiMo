package  {
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
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
		
		private var positionRelative:Point;
		private var distance:Vector3D;
		private var skeleton:Sprite;
		
		public function KinectSkeleton() {
			this.skeleton = new Sprite();
		}
		
		private function createLine(point1:Point, point2:Point):void {
			this.skeleton.graphics.lineStyle(1, 0, 1);
			this.skeleton.graphics.moveTo(point1.x, point1.y);
			this.skeleton.graphics.lineTo(point2.x, point2.y);
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
		public function getPositionRelative():Point {return this.positionRelative;}
		public function getDistance():Vector3D {return this.distance;}
		
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
		public function setPositionRelative(point:Point) {this.positionRelative = point;}
		public function setDistance(vector:Vector3D) {this.distance = vector;}
		
		public function getSkeleton():Sprite {return this.skeleton;}
	}
}