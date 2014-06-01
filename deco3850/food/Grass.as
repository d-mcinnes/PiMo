package deco3850.food {
	import flash.display.MovieClip;
	import deco3850.animals.Cow;
	import deco3850.animals.Sheep;
	import deco3850.animals.Alphca
	
	public class Grass extends Food {
		public function Grass(name:String = "", tags:Array = null, icon:MovieClip = null, active:Boolean = false) {
			super(name, tags, icon, active);
		}
		
		override public function checkAnimal(type:Class):Boolean {
			if(type == Cow.getClass() || type == Sheep.getClass()) {
				return true;
			} else {
				return false;
			}
		}
	}
}