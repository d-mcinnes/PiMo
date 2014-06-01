package deco3850.food {
	import flash.display.MovieClip;
	import deco3850.animals.Cat;
	
	public class Fish extends Food {
		public function Fish(name:String = "", tags:Array = null, icon:MovieClip = null, active:Boolean = false) {
			super(name, tags, icon, active);
		}
		
		override public function checkAnimal(type:Class):Boolean {
			if(type == Cat.getClass()) {
				return true;
			} else {
				return false;
			}
		}
	}
}