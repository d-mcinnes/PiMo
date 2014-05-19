package  {
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Animal extends MovieClip {
		private var tags:Array = [];
		private var timer:Timer;
		private var animalName:String = "";
		
		public function Animal() {
			this.timer = new Timer(8000);
			this.timer.addEventListener(TimerEvent.TIMER, timerEvent);
		}
		
		public function interactionAttach():Boolean {
			return false;
		}
		
		public function startTimer() {
			this.timer.start();
		}
		
		public function setTimerEvent(func:Function) {
			//this.timer.addEventListener(TimerEvent.TIMER, func);
			this.timer.addEventListener(TimerEvent.TIMER, func);
		}
		
		private function timerEvent(e:TimerEvent) {
			GameController.debugMessage("Removing Animal");
			this.timer.reset();
			//trace("Parent: " + this.parent.toString());
			//this.parent[this.name].despawnAnimal(this);
		}
		
		public function getScore():Number {
			return 0;
		}
		
		public function setTags(tags:Array) {this.tags = tags;}
		public function getTags():Array {return this.tags;}
		
		public function setName(animalName:String) {this.animalName = animalName;}
		public function getName():String {return this.animalName;}
		
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