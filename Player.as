package  {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.Font;
	
	public class Player extends MovieClip {
		private var gameController:GameController;
		private var kinectSkeleton:KinectSkeleton;
		private var player:Sprite;
		private var document:Stage;
		
		private var leftPoint:Point;
		private var rightPoint:Point;
		private var outOfBounds:OutOfBoundsBackground;
		
		private var SIZE_LIMB:Number = 3;
		private var SIZE_CHEST:Number = 6;

		//public function Player(kinectSkeleton:KinectSkeleton, document:Stage) {
		public function Player(gameController:GameController) {
			this.gameController = gameController;
			this.player = new Sprite();
			
			this.outOfBounds = new OutOfBoundsBackground();
			this.outOfBounds.x = 0;
			this.outOfBounds.y = 0;
			this.outOfBounds.visible = false;
			this.gameController.getStageOverlay().addChild(this.outOfBounds);
			
			this.player.graphics.lineStyle(3,0x00ff00);
			this.player.graphics.beginFill(0x000000);
			this.player.graphics.drawRect(0,0,100,100);
			this.player.graphics.endFill();
		}
		
		public function getPlayerAvatar():Sprite {return this.player;}
		
		/** Renders the player on the screen. **/
		public function renderPlayer() {
			/* Calculate Angles. */
			var leftArmUpperAngle:Number = getAngle(this.gameController.getKinectSkeleton().getLeftShoulder().x, 
													this.gameController.getKinectSkeleton().getLeftShoulder().y, 
													this.gameController.getKinectSkeleton().getLeftElbow().x, 
													this.gameController.getKinectSkeleton().getLeftElbow().y);
			var leftArmLowerAngle:Number = getAngle(this.gameController.getKinectSkeleton().getLeftElbow().x, 
													this.gameController.getKinectSkeleton().getLeftElbow().y, 
													this.gameController.getKinectSkeleton().getLeftHand().x, 
													this.gameController.getKinectSkeleton().getLeftHand().y);
			var rightArmUpperAngle:Number = getAngle(this.gameController.getKinectSkeleton().getRightShoulder().x, 
													 this.gameController.getKinectSkeleton().getRightShoulder().y, 
													 this.gameController.getKinectSkeleton().getRightElbow().x, 
													 this.gameController.getKinectSkeleton().getRightElbow().y);
			var rightArmLowerAngle:Number = getAngle(this.gameController.getKinectSkeleton().getRightElbow().x, 
													 this.gameController.getKinectSkeleton().getRightElbow().y, 
													 this.gameController.getKinectSkeleton().getRightHand().x,
													 this.gameController.getKinectSkeleton().getRightHand().y);
			
			/* Check distance from the Kinect. */
			if(this.gameController.getKinectSkeleton().getDistance().z < 1.0) {
				this.outOfBounds.messageBox.text = "Too close to the Kinect.";
				this.outOfBounds.visible = true;
				return;
			} else {
				this.outOfBounds.visible = false;
			}
			
			/* Check whether the user is out of the bounds of the screen. */
			var xPosition = 1024 * this.gameController.getKinectSkeleton().getPositionRelative().x;
			if(xPosition <= 140) {
				this.outOfBounds.messageBox.text = "Out of Bounds - Left.";
				this.outOfBounds.visible = true;
				return;
			} else if(xPosition >= 900) {
				this.outOfBounds.messageBox.text = "Out of Bounds - Right.";
				this.outOfBounds.visible = true;
				return;
			} else {
				this.outOfBounds.visible = false;
				this.x = xPosition;
			}
			
			/* Clear current Player and create Neck and Head. */
			this.clearPlayer();
			var neckPoint:Point = getPolarPoint(new Point(0, 0), 
												 getAngle(this.gameController.getKinectSkeleton().getTorso().x, 
														  this.gameController.getKinectSkeleton().getTorso().y, 
														  this.gameController.getKinectSkeleton().getNeck().x, 
														  this.gameController.getKinectSkeleton().getNeck().y), 
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
											   getAngle(this.gameController.getKinectSkeleton().getTorso().x, 
														this.gameController.getKinectSkeleton().getTorso().y, 
														this.gameController.getKinectSkeleton().getLeftKnee().x, 
														this.gameController.getKinectSkeleton().getLeftKnee().y), 
											   SIZE_LIMB);
			this.createLine(new Point(0, 0), leftKnee);
			this.createLine(leftKnee, getPolarPoint(leftKnee, 
													getAngle(this.gameController.getKinectSkeleton().getLeftKnee().x, 
															 this.gameController.getKinectSkeleton().getLeftKnee().y, 
															 this.gameController.getKinectSkeleton().getLeftFoot().x, 
															 this.gameController.getKinectSkeleton().getLeftFoot().y), 
													SIZE_LIMB));
			
			/* Render Right Leg */
			var rightKnee:Point = getPolarPoint(new Point(0, 0),
												getAngle(this.gameController.getKinectSkeleton().getTorso().x, 
														 this.gameController.getKinectSkeleton().getTorso().y, 
														 this.gameController.getKinectSkeleton().getRightKnee().x, 
														 this.gameController.getKinectSkeleton().getRightKnee().y), 
												SIZE_LIMB);
			this.createLine(new Point(0, 0), rightKnee);
			this.createLine(rightKnee, getPolarPoint(rightKnee,
													 getAngle(this.gameController.getKinectSkeleton().getRightKnee().x, 
															  this.gameController.getKinectSkeleton().getRightKnee().y, 
															  this.gameController.getKinectSkeleton().getRightFoot().x,
															  this.gameController.getKinectSkeleton().getRightFoot().y), 
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
		
		private function getAngle(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			return Math.atan2(y2 - y1, x2 - x1);
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