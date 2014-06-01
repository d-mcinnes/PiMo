package deco3850.food {
	import flash.display.MovieClip;
	import deco3850.animals.Owl;
	
	public class BirdSeed extends Food {
		public function BirdSeed(name:String = "", tags:Array = null, icon:MovieClip = null, active:Boolean = false) {
			super(name, tags, icon, active);
		}
		
		override public function checkAnimal(type:Class):Boolean {
			if(type == Owl.getClass()) {
				return true;
			} else {
				return false;
			}
		}
	}
}