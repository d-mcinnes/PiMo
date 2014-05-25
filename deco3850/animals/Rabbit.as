package deco3850.animals {
	import flash.debug.Debug;
	import flash.display.MovieClip;
	
	public class Rabbit extends Animal {
		
		public function Rabbit() {
			this.setName("Rabbit");
			this.createTimer(4000);
			this.setTags(['010232cd72', '010238914a', '0102387557']);
			this.setScore(10);
			this.setFacingAngleLeft();
		}
		
		override public function interactionAttach():Boolean {
			Debug.debugMessage("Aniaml " + this.getName() + " attached");
			return true;
		}
	}
}