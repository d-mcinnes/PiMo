﻿package  {
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.display.MovieClip;
	
	public class Player extends MovieClip {
		private var kinectSkeleton:KinectSkeleton;
		private var player:Sprite;

		public function Player(kinectSkeleton:KinectSkeleton) {
			this.kinectSkeleton = kinectSkeleton;
			this.player = new Sprite();
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
			
			this.clearPlayer();
			this.x = 1024 * this.kinectSkeleton.getPositionRelative().x;
			//trace(this.x + ", " + this.y);
			
			var neckPoint:Point = getPolarPoint(new Point(0, 0), 
												 getAngle(this.kinectSkeleton.getNeck().x, 
														  this.kinectSkeleton.getNeck().y, 
														  0, 0), 
												 10);
			this.createLine(new Point(0, 0), neckPoint);
			
			var leftArmElbow = getPolarPoint(neckPoint, leftArmUpperAngle, 5);
			this.createLine(neckPoint, leftArmElbow);
			this.createLine(leftArmElbow, getPolarPoint(leftArmElbow, leftArmLowerAngle, 5));
			
			var rightArmElbow = getPolarPoint(neckPoint, rightArmUpperAngle, 5);
			this.createLine(neckPoint, rightArmElbow);
			this.createLine(rightArmElbow, getPolarPoint(rightArmElbow, rightArmLowerAngle, 5));
			
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
			this.graphics.lineStyle(1, 0, 1);
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