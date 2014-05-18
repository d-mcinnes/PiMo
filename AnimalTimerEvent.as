package {
	import flash.events.TimerEvent;
	
	public class AnimalTimerEvent extends TimerEvent {
		private var animal:Animal;
		
		public static var TIMER:String = "timer";
		
		public function AnimalTimerEvent(animal:Animal) {
			super(TimerEvent.TIMER);
			this.animal = animal;
		}
		
		public function getAnimal():Animal {
			return this.animal;
		}
		
		public function setAnimal(animal:Animal) {
			this.animal = animal;
		}
	}
}