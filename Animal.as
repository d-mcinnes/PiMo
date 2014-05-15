package  {
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Animal extends MovieClip {
		private var tags:Array = [];
		private var timer:Timer;
		
		public function Animal() {
			this.timer = new Timer(8000);
			this.timer.addEventListener(TimerEvent.TIMER, timerEvent);
		}
		
		public function startTimer() {
			this.timer.start();
		}
		
		private function timerEvent(e:TimerEvent) {
			trace("Removing Animal...");
			this.timer.reset();
			trace("Parent: " + this.parent.toString());
			//this.parent[this.name].despawnAnimal(this);
		}
		
		public function getScore():Number {
			return 0;
		}
		
		public function setTags(tags:Array) {this.tags = tags;}
		public function getTags():Array {return this.tags;}
		
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