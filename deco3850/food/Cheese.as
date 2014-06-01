package deco3850.food {
	import flash.display.MovieClip;
	import deco3850.animals.Rat;
	
	public class Cheese extends Food {
		public function Cheese(name:String = "", tags:Array = null, icon:MovieClip = null, active:Boolean = false) {
			super(name, tags, icon, active);
		}
		
		override public function checkAnimal(type:Class):Boolean {
			if(type == Rat.getClass()) {
				return true;
			} else {
				return false;
			}
		}
	}
}