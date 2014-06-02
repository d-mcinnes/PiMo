package deco3850.animals {
	import flash.debug.Debug;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	public class Sheep extends Animal {
		public function Sheep() {
			this.setName("Sheep");
			this.createTimer(7000);
			this.setTags([]);
			this.setScore(10);
		}
		
		override public function interactionAttach():Boolean {
			return true;
		}
		
		public static function getClass():Class {return getDefinitionByName("deco3850.animals.Sheep") as Class;}
	}
}