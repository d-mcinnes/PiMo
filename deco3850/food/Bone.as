package deco3850.food {
	import flash.display.MovieClip;
	import deco3850.animals.Dog;
	
	public class Bone extends Food {
		public function Bone(name:String = "", tags:Array = null, icon:MovieClip = null, active:Boolean = false) {
			super(name, tags, icon, active);
		}
		
		override public function checkAnimal(type:Class):Boolean {
			if(type == Dog.getClass()) {
				return true;
			} else {
				return false;
			}
		}
	}
}