package deco3850.food {
	import flash.display.MovieClip;
	import deco3850.animals.Tiger;
	
	public class Meat extends Food {
		public function Meat(name:String = "", tags:Array = null, icon:MovieClip = null, active:Boolean = false) {
			super(name, tags, icon, active);
		}
		
		override public function checkAnimal(type:Class):Boolean {
			if(type == Tiger.getClass()) {
				return true;
			} else {
				return false;
			}
		}
	}
}