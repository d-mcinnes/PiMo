package deco3850.animals {
	import flash.debug.Debug;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	public class Alphca extends Animal {
		public function Alphca() {
			this.setName("Alphca");
			this.createTimer(4000);
			this.setTags([]);
			this.setScore(10);
		}
		
		override public function interactionAttach():Boolean {
			
		}
		
		public static function getClass():Class {return getDefinitionByName("deco3850.animals.Alphca") as Class;}
	}
}