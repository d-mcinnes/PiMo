package deco3850.food {
	import flash.display.MovieClip;
	import deco3850.animals.Rabbit;
	
	public class Carrot extends Food {
		public function Carrot(name:String = "", tags:Array = null, icon:MovieClip = null, active:Boolean = false) {
			super(name, tags, icon, active);
		}
		
		override public function checkAnimal(type:Class):Boolean {
			if(type == Rabbit.getClass()) {
				return true;
			} else {
				return false;
			}
		}
	}
}