package  {
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Timer;
	
	public class Scenery extends MovieClip {
		private var active:Boolean = false;
		private var timer:Timer;

		public function Scenery() {
			this.active = false;
			this.timer = new Timer(10000);
			this.timer.addEventListener(TimerEvent.TIMER, timerEvent);
		}
		
		private function timerEvent(e:TimerEvent) {
			trace("Removing Scenery...");
			this.timer.reset();
			this.setIsActive(true);
		}
		
		public function setIsActive(active:Boolean) {
			this.active = active;
			if(!active) {
				this.filters = [ new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0]) ];
				this.timer.start();
			} else {
				this.filters = [];
			}
		}
		
		public function isActive():Boolean {return this.active;}
	}
}