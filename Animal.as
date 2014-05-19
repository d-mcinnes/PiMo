package {
	import flash.debug.Debug;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Animal extends MovieClip {
		private var animalName:String = "";
		private var score:Number = 0;
		private var tags:Array = [];
		private var timer:Timer;
		
		public function Animal() {
			this.timer = new Timer(8000);
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
		
		private function timerEvent(e:TimerEvent) {
			Debug.debugMessage("Removing Animal");
			this.timer.reset();
		}
		
		public function setScore(score:Number) {this.score = score;}
		public function getScore():Number {return this.score;}
		
		public function setTags(tags:Array) {this.tags = tags;}
		public function getTags():Array {return this.tags;}
		
		public function setName(animalName:String) {this.animalName = animalName;}
		public function getName():String {return this.animalName;}
		
		/** Checks to see if the tag is associated with the animal. **/
		public function checkTag(tag:String):Boolean {
			for each(var object in this.tags) {
				if(object == tag) {
					return true;
				}
			}
			return false;
		}
	}
}