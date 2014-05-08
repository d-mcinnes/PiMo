package  {
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.display.MovieClip;
	import flash.display.Stage;
	
	public class Player extends MovieClip {
		private var kinectSkeleton:KinectSkeleton;
		private var player:Sprite;
		private var document:Stage;
		
		private var leftPoint:Point;
		private var rightPoint:Point;
		private var outOfBounds:OutOfBoundsBackground;

		public function Player(kinectSkeleton:KinectSkeleton, document:Stage) {
			this.kinectSkeleton = kinectSkeleton;
			this.player = new Sprite();
			this.document = document;
			
			this.outOfBounds = new OutOfBoundsBackground();
			this.outOfBounds.x = 0;
			this.outOfBounds.y = 0;
			this.outOfBounds.visible = false;
			this.document.addChild(this.outOfBounds);
			
			this.player.graphics.lineStyle(3,0x00ff00);
			this.player.graphics.beginFill(0x000000);
			this.player.graphics.drawRect(0,0,100,100);
			this.player.graphics.endFill();
		}
		
		public function getPlayerAvatar():Sprite {return this.player;}
		
		public function renderPlayer() {
			//var leftArmUpperAngle:Number = this.kinectSkeleton.getLeftShoulder() * this.kinectSkeleton.getLeftElbow();
			//var leftArmLowerAngle:Number = this.kinectSkeleton.getLeftElbow() * this.kinectSkeleton.getLeftHand();
			//var rightArmUpperAngle:Number = this.kinectSkeleton.getRightShoulder() * this.kinectSkeleton.getRightElbow();
			//var rightArmLowerAngle:Number = this.kinectSkeleton.getRightElbow() * this.kinectSkeleton.getRightHand();
			
			var leftArmUpperAngle:Number = getAngle(this.kinectSkeleton.getLeftShoulder().x, 
													this.kinectSkeleton.getLeftShoulder().y, 
													this.kinectSkeleton.getLeftElbow().x, 
													this.kinectSkeleton.getLeftElbow().y);
			var leftArmLowerAngle:Number = getAngle(this.kinectSkeleton.getLeftElbow().x, 
													this.kinectSkeleton.getLeftElbow().y, 
													this.kinectSkeleton.getLeftHand().x, 
													this.kinectSkeleton.getLeftHand().y);
			var rightArmUpperAngle:Number = getAngle(this.kinectSkeleton.getRightShoulder().x, 
													 this.kinectSkeleton.getRightShoulder().y, 
													 this.kinectSkeleton.getRightElbow().x, 
													 this.kinectSkeleton.getRightElbow().y);
			var rightArmLowerAngle:Number = getAngle(this.kinectSkeleton.getRightElbow().x, 
													 this.kinectSkeleton.getRightElbow().y, 
													 this.kinectSkeleton.getRightHand().x,
													 this.kinectSkeleton.getRightHand().y);
			
			var xPosition = 1024 * this.kinectSkeleton.getPositionRelative().x;
			if(xPosition <= 140) {
				this.outOfBounds.visible = true;
				return;
			} else if(xPosition >= 900) {
				this.outOfBounds.visible = true;
				return;
			} else {
				this.outOfBounds.visible = false;
				this.x = xPosition;
			}
			
			if(this.kinectSkeleton.getDistance().z < 1.0) {
				this.outOfBounds.visible = true;
				return;
			} else {
				this.outOfBounds.visible = false;
			}
			
			this.clearPlayer();
			var neckPoint:Point = getPolarPoint(new Point(0, 0), 
												 getAngle(this.kinectSkeleton.getTorso().x, 
														  this.kinectSkeleton.getTorso().y, 
														  this.kinectSkeleton.getNeck().x, 
														  this.kinectSkeleton.getNeck().y), 
												 10);
			this.createLine(new Point(0, 0), neckPoint);
			var playerHead:Head = new Head();
			var playerHeadPoint:Point = getPolarPoint(neckPoint, getAngle(0, 0, neckPoint.x, neckPoint.y), 70);
			playerHead.x = playerHeadPoint.x;
			playerHead.y = playerHeadPoint.y;
			playerHead.rotation = getAngle(0, 0, neckPoint.x, neckPoint.y);
			this.addChild(playerHead);
			
			var leftArmElbow = getPolarPoint(neckPoint, leftArmUpperAngle, 5);
			this.createLine(neckPoint, leftArmElbow);
			this.createLine(leftArmElbow, getPolarPoint(leftArmElbow, leftArmLowerAngle, 5));
			
			this.leftPoint = getPolarPoint(leftArmElbow, leftArmLowerAngle, 5);
			
			var rightArmElbow = getPolarPoint(neckPoint, rightArmUpperAngle, 5);
			this.createLine(neckPoint, rightArmElbow);
			this.createLine(rightArmElbow, getPolarPoint(rightArmElbow, rightArmLowerAngle, 5));
			
			this.rightPoint = getPolarPoint(leftArmElbow, leftArmLowerAngle, 5);
			
			/** 
			 ** Render Left Leg 
			 **/
			var leftKnee:Point = getPolarPoint(new Point(0, 0), 
											   getAngle(this.kinectSkeleton.getTorso().x, 
														this.kinectSkeleton.getTorso().y, 
														this.kinectSkeleton.getLeftKnee().x, 
														this.kinectSkeleton.getLeftKnee().y), 
											   5);
			this.createLine(new Point(0, 0), leftKnee);
			this.createLine(leftKnee, getPolarPoint(leftKnee, 
													getAngle(this.kinectSkeleton.getLeftKnee().x, 
															 this.kinectSkeleton.getLeftKnee().y, 
															 this.kinectSkeleton.getLeftFoot().x, 
															 this.kinectSkeleton.getLeftFoot().y), 
													5));
			
			/** 
			 ** Render Right Leg 
			 **/
			var rightKnee:Point = getPolarPoint(new Point(0, 0),
												getAngle(this.kinectSkeleton.getTorso().x, 
														 this.kinectSkeleton.getTorso().y, 
														 this.kinectSkeleton.getRightKnee().x, 
														 this.kinectSkeleton.getRightKnee().y), 
												5);
			this.createLine(new Point(0, 0), rightKnee);
			this.createLine(rightKnee, getPolarPoint(rightKnee,
													 getAngle(this.kinectSkeleton.getRightKnee().x, 
															  this.kinectSkeleton.getRightKnee().y, 
															  this.kinectSkeleton.getRightFoot().x,
															  this.kinectSkeleton.getRightFoot().y), 
													 5));
			
			
			
			//trace("Create");
			
			/*this.createLine(this.kinectSkeleton.getNeck(), 
							getPolarPoint(this.kinectSkeleton.getNeck(), 
										  getAngle(this.kinectSkeleton.getNeck().x, 
												   this.kinectSkeleton.getNeck().y, 
												   this.kinectSkeleton.getTorso().x, 
												   this.kinectSkeleton.getTorso().y), 
										  10));*/
			
			
			//trace("Angles: " + leftArmUpperAngle + " " + leftArmLowerAngle + " " + rightArmUpperAngle + " " + rightArmLowerAngle);
			
			/*clearPlayer();
			
			this.createLine(this.kinectSkeleton.getLeftElbow(), this.kinectSkeleton.getLeftHand());
			this.createLine(this.kinectSkeleton.getLeftShoulder(), this.kinectSkeleton.getLeftElbow());
			this.createLine(this.kinectSkeleton.getTorso(), this.kinectSkeleton.getLeftKnee());
			this.createLine(this.kinectSkeleton.getLeftKnee(), this.kinectSkeleton.getLeftFoot());
			this.createLine(this.kinectSkeleton.getLeftShoulder(), this.kinectSkeleton.getNeck());
			this.createLine(this.kinectSkeleton.getNeck(), this.kinectSkeleton.getTorso());
			this.createLine(this.kinectSkeleton.getNeck(), this.kinectSkeleton.getHead());
			this.createLine(this.kinectSkeleton.getRightShoulder(), this.kinectSkeleton.getNeck());
			this.createLine(this.kinectSkeleton.getRightElbow(), this.kinectSkeleton.getRightHand());
			this.createLine(this.kinectSkeleton.getRightShoulder(), this.kinectSkeleton.getRightElbow());
			this.createLine(this.kinectSkeleton.getTorso(), this.kinectSkeleton.getRightKnee());
			this.createLine(this.kinectSkeleton.getRightKnee(), this.kinectSkeleton.getRightFoot());
			
			var headFill:Sprite = new Sprite();
			headFill.graphics.beginFill(0x000000);
			headFill.graphics.drawCircle(this.kinectSkeleton.getHead().x, this.kinectSkeleton.getHead().y, 20);
			headFill.graphics.endFill();
			this.player.addChild(headFill);*/
		}
		
		private function clearPlayer() {
			this.graphics.clear();
			while(this.numChildren > 0) {
				this.removeChildAt(0);
			}
		}
		
		private function createLine(point1:Point, point2:Point):void {
			this.graphics.lineStyle(5, 0, 1);
			this.graphics.moveTo(point1.x * 10, point1.y * 10);
			this.graphics.lineTo(point2.x * 10, point2.y * 10);
		}
		
		private function getAngle(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			/*var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return Math.atan2(dy,dx);*/
			return Math.atan2(y2 - y1, x2 - x1);
		}
		
		private function getPolarPoint(startPoint:Point, degrees:Number, distance:Number):Point {
			return new Point(startPoint.x + Math.round(distance * Math.cos( degrees /* * Math.PI / 180 */)), 
							 startPoint.y + Math.round(distance * Math.sin( degrees /* * Math.PI / 180 */)));
			/*var destinationPoint:Point = new Point();
			destinationPoint.x = startPoint.x + Math.round(distance * Math.cos( degrees * Math.PI / 180 ));
			destinationPoint.y = startPoint.y + Math.round(distance * Math.sin( degrees * Math.PI / 180 ));
			return destinationPoint;*/
		}
	}
}