package  {
	import flash.geom.Point;

	public class KinectSkeleton {
		private var head:Point;
		private var leftElbow:Point;
		private var leftHand:Point;
		private var leftHip:Point;
		private var leftKnee:Point;
		private var leftShoulder:Point;
		private var neck:Point;
		private var rightElbow:Point;
		private var rightHand:Point;
		private var rightHip:Point;
		private var rightKnee:Point;
		private var rightShoulder:Point;
		private var torso:Point;
		
		public function KinectSkeleton() {
			
		}
		
		public function getHead():Point {return this.head;}
		public function getLeftElbow():Point {return this.leftElbow;}
		public function getLeftHand():Point {return this.leftHand;}
		public function getLeftHip():Point {return this.leftHip;}
		public function getLeftKnee():Point {return this.leftKnee;}
		public function getLeftShoulder():Point {return this.leftShoulder;}
		public function getNeck():Point {return this.neck;}
		public function getRightElbow():Point {return this.rightElbow;}
		public function getRightHand():Point {return this.rightHand;}
		public function getRightHip():Point {return this.rightHip;}
		public function getRightKnee():Point {return this.rightKnee;}
		public function getRightShoulder():Point {return this.rightShoulder;}
		public function getTorso():Point {return this.torso;}
		
		public function setHead(point:Point) {this.head = point;}
		public function setLeftElbow(point:Point) {this.leftElbow = point;}
		public function setLeftHand(point:Point) {this.leftHand = point;}
		public function setLeftHip(point:Point) {this.leftHip = point;}
		public function setLeftKnee(point:Point) {this.leftKnee = point;}
		public function setLeftShoulder(point:Point) {this.leftShoulder = point;}
		public function setNeck(point:Point) {this.neck = point;}
		public function setRightElbow(point:Point) {this.rightElbow = point;}
		public function setRightHand(point:Point) {this.rightHand = point;}
		public function setRightHip(point:Point) {this.rightHip = point;}
		public function setRightKnee(point:Point) {this.rightKnee = point;}
		public function setRightShoulder(point:Point) {this.rightShoulder = point;}
		public function setTorso(point:Point) {this.torso = point;}
	}
}