package {
	import flash.debug.Debug;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class Animal extends MovieClip {
		private var animalName:String = "";
		private var score:Number = 0;
		private var tags:Array = [];
		private var timer:Timer;
		
		public function Animal() {
			//this.timer = new Timer(8000);
			//this.timer.addEventListener(TimerEvent.TIMER, timerEvent);
		}
		
		public function createTimer(time:Number) {
			this.timer = new Timer(time);
			this.timer.addEventListener(TimerEvent.TIMER, timerEvent);
		}
		
		/** Runs when the game attempts to attach an animal to the player. **/
		public function interactionAttach():Boolean {
			return false;
		}
		
		public function startTimer() {
			this.timer.start();
		}
		
		public function setTimerEvent(func:Function) {
			this.timer.addEventListener(TimerEvent.TIMER, func);
		}
		
		/** Runs when _____ **/
		private function timerEvent(e:TimerEvent) {
			Debug.debugMessage("Removing Animal " + this);
			this.timer.reset();
		}
		
		public function setScore(score:Number) {this.score = score;}
		public function getScore():Number {return this.score;}
		
		public function setTags(tags:Array) {this.tags = tags;}
		public function getTags():Array {return this.tags;}
		
		public function setName(animalName:String) {this.animalName = animalName;}
		public function getName():String {return this.animalName;}
		public function getType():Class {return Class(getDefinitionByName(getQualifiedClassName(this)));}
		
		public function remove():Boolean {return GameController.getInstance().removeAnimal(this);}
		public function isInParty():Boolean {return GameController.getInstance().animalIsInParty(this);}
		
		/** Checks to see if the tag is associated with the animal. **/
		public function checkTag(tag:String):Boolean {
			for each(var object in this.tags) {
				if(object == tag) {
					return true;
				}
			}
			return false;
		}
		
		public function setTimer(time:Number) {this.timer.delay = time;}
		
		/** Animations **/
		
		/** Plays the animals idle animation. **/
		public function playIdleAnimation() {
			Debug.debugMessage("Playing idle animation for " + this.getName());
			this.stop();
		}
		
		/** Plays the animals walk animation. **/
		public function playWalkAnimation() {
			Debug.debugMessage("Playing walk animation for " + this.getName());
			this.play();
		}
		
		/** Sets the facing angle of the animal to face left. **/
		public function setFacingAngleLeft() {
			Debug.debugMessage("Set facing angle to left for " + this.getName());
			this.scaleX *= -1;
		}
		
		/** Sets the facing angle of the animal to face right. **/
		public function setFacingAngleRight() {
			Debug.debugMessage("Set facing angle to right for " + this.getName());
			this.scaleX *= 1;
		}
	}
}