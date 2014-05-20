package  {
	import flash.debug.Debug;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Timer;
	
	public class Scenery extends MovieClip {
		private var active:Boolean = false;
		private var timer:Timer;
		private var sceneryName:String;
		private var gameController:GameController;
		private var animalSpawnType:Class;
		private var cooldownPeriod:Number = 0;

		public function Scenery() {
			this.active = false;
			this.timer = new Timer(10000);
			this.timer.addEventListener(TimerEvent.TIMER, timerEvent);
		}
		
		/** Resets the scenery object. **/
		private function timerEvent(e:TimerEvent) {
			Debug.debugMessage("Setting scenery object " + this.getName() + " to active");
			this.timer.reset();
			this.setIsActive(true);
		}
		
		/** Runs when the user interacts with the scenery object. **/
		public function sceneryInteraction() {
			
		}
		
		/** Takes a Boolean and sets whether or not the object is active. **/
		public function setIsActive(active:Boolean) {
			this.active = active;
			if(!active) {
				this.filters = [ new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0]) ];
				this.timer.start();
			} else {
				this.filters = [];
			}
		}
		
		/** Returns whether or not the scenery object is active. **/
		public function isActive():Boolean {return this.active;}
		
		public function getName():String {return this.sceneryName;}
		public function setName(name:String) {this.sceneryName = name;}
		
		public function getAnimalSpawnType():Class {return this.animalSpawnType;}
		public function setAnimalSpawnType(type:Class) {this.animalSpawnType = type;}
		
		public function getCooldownPeriod():Number {return this.cooldownPeriod;}
		public function setCooldownPeriod(time:Number) {
			this.cooldownPeriod = time;
			this.timer.delay = time;
		}
	}
}