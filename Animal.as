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
			
		}
		
		public function createTimer(time:Number) {
			this.timer = new Timer(time);
			this.timer.addEventListener(TimerEvent.TIMER, timerEvent);
		}
		
		/** Runs when the game attempts to attach an animal to the player. **/
		public function interactionAttach():Boolean {
			return false;
		}
		
		/** Runs everytime the game attempts to attach an animal to the player. **/
		public function interactionAttachGlobal():Boolean {
			GameController.getInstance().displayGameMessage(this.getName() + " has joined your party.");
			if(GameController.getInstance().getNumberOfAnimalsInParty() >= GameController.MAX_ANIMALS) {
				// TODO: MAX ANIMALS
			}
			return true;
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
		public function getType():Class {return getDefinitionByName(getQualifiedClassName(this)) as Class;}
		
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
			this.stop();
			this.gotoAndStop(40);
		}
		
		/** Plays the animals walk animation. **/
		public function playWalkAnimation() {
			if(this.isPlaying == false) {
				this.gotoAndPlay(1);
			}
		}
		
		/** Sets the facing angle of the animal to face left. **/
		public function setFacingAngleLeft() {
			if(this.scaleX > 0) {
				this.scaleX *= -1;
			} else {
				this.scaleX *= 1;
			}
		}
		
		/** Sets the facing angle of the animal to face right. **/
		public function setFacingAngleRight() {
			if(this.scaleX < 0) {
				this.scaleX *= -1;
			} else {
				this.scaleX *= 1;
			}
		}
	}
}