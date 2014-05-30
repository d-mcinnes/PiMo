package {
	import flash.debug.Debug;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.Font;
	
	public class Player extends MovieClip {
		private var skeleton:KinectSkeleton;
		
		private var leftPoint:Point;
		private var rightPoint:Point;
		
		private var head:Point;
		private var neck:Point;
		private var torso:Point;
		private var leftElbow:Point;
		private var leftHand:Point;
		private var rightElbow:Point;
		private var rightHand:Point;
		private var leftKnee:Point;
		private var leftFoot:Point;
		private var rightKnee:Point;
		private var rightFoot:Point;
		
		private var SIZE_LIMB:Number = 3;
		private var SIZE_CHEST:Number = 6;
		private var SIZE_INCREMENT:Number = 1;
		
		public function Player() {
			
		}
		
		public function initialisePlayer() {
			Debug.debugMessage("NECK POSITION: " + GameController.getInstance().getKinectSkeleton().getNeck());
			/* Set Points */
			this.torso = new Point(0, 0);
			this.neck = this.interpolatePoint(this.torso, 
										   getAnglePoint(this.torso, 
														 GameController.getInstance().getKinectSkeleton().getNeck()), 
										   SIZE_CHEST);
			this.head = this.interpolatePoint(this.neck, 
										   getAnglePoint(this.neck, 
														 GameController.getInstance().getKinectSkeleton().getHead()), 
										   SIZE_LIMB);
			this.leftElbow = this.interpolatePoint(this.neck,
												getAnglePoint(this.neck, 
															  GameController.getInstance().getKinectSkeleton().getLeftElbow()), 
												SIZE_LIMB);
			this.leftHand = this.interpolatePoint(this.leftElbow, 
											   getAnglePoint(this.leftElbow, 
															 GameController.getInstance().getKinectSkeleton().getLeftHand()), 
											   SIZE_LIMB);
			this.rightElbow = this.interpolatePoint(this.neck, 
												 getAnglePoint(this.neck, 
															   GameController.getInstance().getKinectSkeleton().getRightElbow()), 
												 SIZE_LIMB);
			this.rightHand = this.interpolatePoint(this.rightElbow, 
												getAnglePoint(this.rightElbow, 
															  GameController.getInstance().getKinectSkeleton().getRightHand()), 
												SIZE_LIMB);
			this.leftKnee = this.interpolatePoint(this.torso, 
											   getAnglePoint(this.torso, 
															 GameController.getInstance().getKinectSkeleton().getLeftKnee()),
											   SIZE_LIMB);
			this.leftFoot = this.interpolatePoint(this.leftKnee, 
											   getAnglePoint(this.leftKnee, 
															 GameController.getInstance().getKinectSkeleton().getLeftFoot()), 
											   SIZE_LIMB);
			this.rightKnee = this.interpolatePoint(this.torso, 
												getAnglePoint(this.torso, 
															  GameController.getInstance().getKinectSkeleton().getRightKnee()), 
												SIZE_LIMB);
			this.rightFoot = this.interpolatePoint(this.rightKnee, 
												getAnglePoint(this.rightKnee, 
															  GameController.getInstance().getKinectSkeleton().getRightFoot()), 
												SIZE_LIMB);
			
			/* Create Lines */
			this.createLine(this.torso, this.neck);
			this.createLine(this.neck, this.head);
			this.createLine(this.neck, this.leftElbow);
			this.createLine(this.leftElbow, this.leftHand);
			this.createLine(this.neck, this.rightElbow);
			this.createLine(this.rightElbow, this.rightHand);
			this.createLine(this.torso, this.leftKnee);
			this.createLine(this.leftKnee, this.leftFoot);
			this.createLine(this.torso, this.rightKnee);
			this.createLine(this.rightKnee, this.rightFoot);
			
			/* Create Head */
			var playerHead:Head = new Head();
			playerHead.x = this.head.x;
			playerHead.y = this.head.y;
			playerHead.rotation = getAngle(0, 0, this.head.x, this.head.y);
			this.addChild(playerHead);
		}
		
		public function renderPlayer() {
			/* Clear Player */
			this.clearPlayer();
			
			/* Set Player Position */
			if(GameController.getInstance().isGamePaused() == false) {
				var xPos:Number = GameController.SCREEN_SIZE_X * GameController.getInstance().getKinectSkeleton().getPositionRelative().x;
				if(xPos < this.x) {
					//GameController.getInstance().setPartyFacingLeft();
				} else if(xPos > this.x) {
					//GameController.getInstance().setPartyFacingRight();
				}
				this.x = xPos;
			}
			
			/* Calculate Points */
			this.neck = this.interpolatePoint(this.neck, 
										   getAnglePoint(this.neck, 
														 GameController.getInstance().getKinectSkeleton().getNeck()), 
										   SIZE_INCREMENT);
			this.head = this.interpolatePoint(this.head, 
										   getAnglePoint(this.head, 
														 GameController.getInstance().getKinectSkeleton().getHead()), 
										   SIZE_INCREMENT);
			this.leftElbow = this.interpolatePoint(this.leftElbow, 
												getAnglePoint(this.leftElbow, 
															  GameController.getInstance().getKinectSkeleton().getLeftElbow()), 
												SIZE_INCREMENT);
			this.leftHand = this.interpolatePoint(this.leftHand, 
											   getAnglePoint(this.leftHand, 
															 GameController.getInstance().getKinectSkeleton().getLeftHand()), 
											   SIZE_INCREMENT);
			this.rightElbow = this.interpolatePoint(this.rightElbow, 
												 getAnglePoint(this.rightElbow, 
															   GameController.getInstance().getKinectSkeleton().getRightElbow()), 
												 SIZE_INCREMENT);
			this.rightHand = this.interpolatePoint(this.rightHand, 
												getAnglePoint(this.rightHand, 
															  GameController.getInstance().getKinectSkeleton().getRightHand()), 
												SIZE_INCREMENT);
			/*this.leftKnee = this.interpolatePoint(this.leftKnee, 
											   getAnglePoint(this.leftKnee, 
															 GameController.getInstance().getKinectSkeleton().getLeftKnee()), 
											   SIZE_INCREMENT);
			this.leftFoot = this.interpolatePoint(this.leftFoot, 
											   getAnglePoint(this.leftFoot, 
															 GameController.getInstance().getKinectSkeleton().getLeftFoot()), 
											   SIZE_INCREMENT);
			this.rightKnee = this.interpolatePoint(this.rightKnee, 
												getAnglePoint(this.rightKnee, 
															  GameController.getInstance().getKinectSkeleton().getRightKnee()), 
												SIZE_INCREMENT);
			this.rightFoot = this.interpolatePoint(this.rightFoot, 
												getAnglePoint(this.rightFoot, 
															  GameController.getInstance().getKinectSkeleton().getRightFoot()), 
												SIZE_INCREMENT);*/
			
			/* Create Lines */
			this.createLine(new Point(0, 0), this.neck);
			this.createLine(this.neck, this.head);
			this.createLine(this.neck, this.leftElbow);
			this.createLine(this.leftElbow, this.leftHand);
			this.createLine(this.neck, this.rightElbow);
			this.createLine(this.rightElbow, this.rightHand);
			
			/* Create Head */
			var playerHead:Head = new Head();
			playerHead.x = this.head.x;
			playerHead.y = this.head.y;
			playerHead.rotation = getAngle(0, 0, this.head.x, this.head.y);
			this.addChild(playerHead);
		}
		
		private renderBodyPart(limbCurrent:Point, limbNew:Point) {
			limbCurrent = this.interpolatePoint(limbCurrent, 
										   getAnglePoint(this.neck, 
														 limbNew), 
										   SIZE_INCREMENT);
		}
		
		/** Renders the player on the screen. **/
		public function renderPlayer2() {
			/* Calculate Angles. */
			var leftArmUpperAngle:Number = getAngle(GameController.getInstance().getKinectSkeleton().getLeftShoulder().x, 
													GameController.getInstance().getKinectSkeleton().getLeftShoulder().y, 
													GameController.getInstance().getKinectSkeleton().getLeftElbow().x, 
													GameController.getInstance().getKinectSkeleton().getLeftElbow().y);
			var leftArmLowerAngle:Number = getAngle(GameController.getInstance().getKinectSkeleton().getLeftElbow().x, 
													GameController.getInstance().getKinectSkeleton().getLeftElbow().y, 
													GameController.getInstance().getKinectSkeleton().getLeftHand().x, 
													GameController.getInstance().getKinectSkeleton().getLeftHand().y);
			var rightArmUpperAngle:Number = getAngle(GameController.getInstance().getKinectSkeleton().getRightShoulder().x, 
													 GameController.getInstance().getKinectSkeleton().getRightShoulder().y, 
													 GameController.getInstance().getKinectSkeleton().getRightElbow().x, 
													 GameController.getInstance().getKinectSkeleton().getRightElbow().y);
			var rightArmLowerAngle:Number = getAngle(GameController.getInstance().getKinectSkeleton().getRightElbow().x, 
													 GameController.getInstance().getKinectSkeleton().getRightElbow().y, 
													 GameController.getInstance().getKinectSkeleton().getRightHand().x,
													 GameController.getInstance().getKinectSkeleton().getRightHand().y);
			
			if(GameController.getInstance().isGamePaused() == false) {
				var xPos:Number = GameController.SCREEN_SIZE_X * GameController.getInstance().getKinectSkeleton().getPositionRelative().x;
				if(xPos < this.x) {
					GameController.getInstance().setPartyFacingLeft();
				} else if(xPos > this.x) {
					GameController.getInstance().setPartyFacingRight();
				}
				this.x = xPos;
			}
			
			/* Clear current Player and create Neck and Head. */
			this.clearPlayer();
			var neckPoint:Point = interpolatePoint(new Point(0, 0), 
												 getAngle(GameController.getInstance().getKinectSkeleton().getTorso().x, 
														  GameController.getInstance().getKinectSkeleton().getTorso().y, 
														  GameController.getInstance().getKinectSkeleton().getNeck().x, 
														  GameController.getInstance().getKinectSkeleton().getNeck().y), 
												 SIZE_CHEST);
			this.createLine(new Point(0, 0), neckPoint);
			var playerHead:Head = new Head();
			var playerHeadPoint:Point = interpolatePoint(neckPoint, getAngle(0, 0, neckPoint.x, neckPoint.y), 50);
			playerHead.x = playerHeadPoint.x;
			playerHead.y = playerHeadPoint.y;
			playerHead.rotation = getAngle(0, 0, neckPoint.x, neckPoint.y);
			this.addChild(playerHead);
			
			/* Render Left Arm */
			var leftArmElbow = interpolatePoint(neckPoint, leftArmUpperAngle, SIZE_LIMB);
			this.createCircle(playerHeadPoint, 5);
			this.createLine(neckPoint, leftArmElbow);
			this.createLine(leftArmElbow, interpolatePoint(leftArmElbow, leftArmLowerAngle, SIZE_LIMB));
			this.leftPoint = interpolatePoint(leftArmElbow, leftArmLowerAngle, SIZE_LIMB);
			
			/* Render Right Arm */
			var rightArmElbow = interpolatePoint(neckPoint, rightArmUpperAngle, SIZE_LIMB);
			this.createLine(neckPoint, rightArmElbow);
			this.createLine(rightArmElbow, interpolatePoint(rightArmElbow, rightArmLowerAngle, SIZE_LIMB));
			this.rightPoint = interpolatePoint(rightArmElbow, rightArmLowerAngle, SIZE_LIMB);
						
			/* Render Left Leg */
			var leftKnee:Point = interpolatePoint(new Point(0, 0), 
											   getAngle(GameController.getInstance().getKinectSkeleton().getTorso().x, 
														GameController.getInstance().getKinectSkeleton().getTorso().y, 
														GameController.getInstance().getKinectSkeleton().getLeftKnee().x, 
														GameController.getInstance().getKinectSkeleton().getLeftKnee().y), 
											   SIZE_LIMB);
			this.createLine(new Point(0, 0), leftKnee);
			this.createLine(leftKnee, interpolatePoint(leftKnee, 
													getAngle(GameController.getInstance().getKinectSkeleton().getLeftKnee().x, 
															 GameController.getInstance().getKinectSkeleton().getLeftKnee().y, 
															 GameController.getInstance().getKinectSkeleton().getLeftFoot().x, 
															 GameController.getInstance().getKinectSkeleton().getLeftFoot().y), 
													SIZE_LIMB));
			
			/* Render Right Leg */
			var rightKnee:Point = interpolatePoint(new Point(0, 0),
												getAngle(GameController.getInstance().getKinectSkeleton().getTorso().x, 
														 GameController.getInstance().getKinectSkeleton().getTorso().y, 
														 GameController.getInstance().getKinectSkeleton().getRightKnee().x, 
														 GameController.getInstance().getKinectSkeleton().getRightKnee().y), 
												SIZE_LIMB);
			this.createLine(new Point(0, 0), rightKnee);
			this.createLine(rightKnee, interpolatePoint(rightKnee,
													 getAngle(GameController.getInstance().getKinectSkeleton().getRightKnee().x, 
															  GameController.getInstance().getKinectSkeleton().getRightKnee().y, 
															  GameController.getInstance().getKinectSkeleton().getRightFoot().x,
															  GameController.getInstance().getKinectSkeleton().getRightFoot().y), 
													 SIZE_LIMB));
		}
		
		/** Clears the player currently rendered on the screen. **/
		private function clearPlayer() {
			this.graphics.clear();
			while(this.numChildren > 0) {
				this.removeChildAt(0);
			}
		}
		
		/** Creates a line between two points. **/
		private function createLine(point1:Point, point2:Point):void {
			this.graphics.lineStyle(5, 0, 1);
			this.graphics.moveTo(point1.x * 10, point1.y * 10);
			this.graphics.lineTo(point2.x * 10, point2.y * 10);
		}
		
		/** **/
		private function createCircle(p1:Point, radius:Number):void {
			this.graphics.drawCircle(p1.x, p1.y, radius);
		}
		
		private function getAngle(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			return Math.atan2(y2 - y1, x2 - x1);
		}
		
		private function getAnglePoint(p1:Point, p2:Point) {
			return Math.atan2(p2.y - p1.y, p2.x - p1.x);
		}
		
		private function interpolatePoint(startPoint:Point, degrees:Number, distance:Number):Point {
			return new Point(startPoint.x + Math.round(distance * Math.cos( degrees /* * Math.PI / 180 */)), 
							 startPoint.y + Math.round(distance * Math.sin( degrees /* * Math.PI / 180 */)));
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private functio ntest() {
			Point.interpolate();
		}
		
		
		
		
		/** Cleanup function, removes all objects added to the stage in
		 ** this class. **/
		public function playerCleanup() {
			while(this.numChildren > 0) {
				this.removeChildAt(0);
			}
		}
		
		public function getLeftPoint():Point {return this.leftPoint;}
		public function getRightPoint():Point {return this.rightPoint;}
	}
}