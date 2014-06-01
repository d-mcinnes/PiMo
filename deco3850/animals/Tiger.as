package deco3850.animals {
	import flash.debug.Debug;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	public class Tiger extends Animal {
		public function Tiger() {
			this.setName("Tiger");
			this.createTimer(4000);
			this.setTags(['all', 'triger', '2B005BB79651', '2B005B767670', '2B005BC811A9', '2B005BA95089', 
						  '2B005BB84B83', '2B005BDD0DA0', '2B005B8DCD30', '2B005B809C6C']);
			this.setScore(10);
		}
		
		override public function interactionAttach():Boolean {
			for each(var object in GameController.getInstance().getParty()) {
				if(object.getType() == Rat.getClass() || object.getType() == Cat.getClass() || 
				   object.getType() == Dog.getClass() || object.getType() == Rabbit.getClass()) {
					object.remove();
				}
			}
			return true;
		}
		
		public static function getClass():Class {return getDefinitionByName("deco3850.animals.Tiger") as Class;}
	}
}