package deco3850.animals {
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	public class Dog extends Animal {
		
		public function Dog() {
			this.setName("Dog");
			this.createTimer(4000);
			this.setTags(['all', 'dog', '2B005B8401F5', '2B005B7FFCF3', '2B005B763731', '2B005BDCFD51', 
						  '2B005BB1D617', '2B005BA5895C', '2B005BCD4DF0', '2B005B783830']);
			this.setScore(40);
		}
		
		override public function interactionAttach():Boolean {
			if(GameController.getInstance().getNumberAnimalInParty(Cat.getClass()) >= 1) {
				GameController.getInstance().removeAnimalType(Cat.getClass());
			}
			return true;
		}
		
		public static function getClass():Class {return getDefinitionByName("deco3850.animals.Dog") as Class;}
	}
}