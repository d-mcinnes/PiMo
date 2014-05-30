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
		//private var player:Sprite;
		//private var document:Stage;
		
		private var leftPoint:Point;
		private var rightPoint:Point;
		private var outOfBounds:OutOfBoundsBackground;
		
		private var head:Point;
		private var neck:Point;
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
		
		public function Player() {
			
		}
		
		public function initialisePlayer() {
			/* Set Points */
			/*this.neck = this.getPolarPoint(new Point(0, 0), 
										   getAnglePoint(new Point(0, 0), 
														 GameController.getInstance().getKinectSkeleton().getNeck()), 
										   SIZE_CHEST);
			this.createLine(new Point(0, 0), this.neck);*/
		}
		
		public function renderPlayer() {
			
		}
		
		//public function getPlayerAvatar():Sprite {return this.player;}
		
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
			var neckPoint:Point = getPolarPoint(new Point(0, 0), 
												 getAngle(GameController.getInstance().getKinectSkeleton().getTorso().x, 
														  GameController.getInstance().getKinectSkeleton().getTorso().y, 
														  GameController.getInstance().getKinectSkeleton().getNeck().x, 
														  GameController.getInstance().getKinectSkeleton().getNeck().y), 
												 SIZE_CHEST);
			this.createLine(new Point(0, 0), neckPoint);
			var playerHead:Head = new Head();
			var playerHeadPoint:Point = getPolarPoint(neckPoint, getAngle(0, 0, neckPoint.x, neckPoint.y), 50);
			playerHead.x = playerHeadPoint.x;
			playerHead.y = playerHeadPoint.y;
			playerHead.rotation = getAngle(0, 0, neckPoint.x, neckPoint.y);
			this.addChild(playerHead);
			
			/* Render Left Arm */
			var leftArmElbow = getPolarPoint(neckPoint, leftArmUpperAngle, SIZE_LIMB);
			this.createCircle(playerHeadPoint, 5);
			this.createLine(neckPoint, leftArmElbow);
			this.createLine(leftArmElbow, getPolarPoint(leftArmElbow, leftArmLowerAngle, SIZE_LIMB));
			this.leftPoint = getPolarPoint(leftArmElbow, leftArmLowerAngle, SIZE_LIMB);
			
			/* Render Right Arm */
			var rightArmElbow = getPolarPoint(neckPoint, rightArmUpperAngle, SIZE_LIMB);
			this.createLine(neckPoint, rightArmElbow);
			this.createLine(rightArmElbow, getPolarPoint(rightArmElbow, rightArmLowerAngle, SIZE_LIMB));
			this.rightPoint = getPolarPoint(rightArmElbow, rightArmLowerAngle, SIZE_LIMB);
						
			/* Render Left Leg */
			var leftKnee:Point = getPolarPoint(new Point(0, 0), 
											   getAngle(GameController.getInstance().getKinectSkeleton().getTorso().x, 
														GameController.getInstance().getKinectSkeleton().getTorso().y, 
														GameController.getInstance().getKinectSkeleton().getLeftKnee().x, 
														GameController.getInstance().getKinectSkeleton().getLeftKnee().y), 
											   SIZE_LIMB);
			this.createLine(new Point(0, 0), leftKnee);
			this.createLine(leftKnee, getPolarPoint(leftKnee, 
													getAngle(GameController.getInstance().getKinectSkeleton().getLeftKnee().x, 
															 GameController.getInstance().getKinectSkeleton().getLeftKnee().y, 
															 GameController.getInstance().getKinectSkeleton().getLeftFoot().x, 
															 GameController.getInstance().getKinectSkeleton().getLeftFoot().y), 
													SIZE_LIMB));
			
			/* Render Right Leg */
			var rightKnee:Point = getPolarPoint(new Point(0, 0),
												getAngle(GameController.getInstance().getKinectSkeleton().getTorso().x, 
														 GameController.getInstance().getKinectSkeleton().getTorso().y, 
														 GameController.getInstance().getKinectSkeleton().getRightKnee().x, 
														 GameController.getInstance().getKinectSkeleton().getRightKnee().y), 
												SIZE_LIMB);
			this.createLine(new Point(0, 0), rightKnee);
			this.createLine(rightKnee, getPolarPoint(rightKnee,
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
		
		private function getPolarPoint(startPoint:Point, degrees:Number, distance:Number):Point {
			return new Point(startPoint.x + Math.round(distance * Math.cos( degrees /* * Math.PI / 180 */)), 
							 startPoint.y + Math.round(distance * Math.sin( degrees /* * Math.PI / 180 */)));
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