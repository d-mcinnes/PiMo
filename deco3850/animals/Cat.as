package deco3850.animals {
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	public class Cat extends Animal {
		public function Cat() {
			this.setName("Cat");
			this.createTimer(7000);
			this.setTags(['all', 'cat', '2B005BCA58E2', '2B005B7E6967', '2B005BAC8955', '2B005B95BE5B', 
						  '2B005BBE4789', '2B005B83C231', '2B005BA5D104', '2B005B8C23DF']);
			this.setScore(20);
		}
		
		override public function interactionAttach():Boolean {
			/*if(GameController.getInstance().getNumberAnimalInParty(getDefinitionByName("deco3850.animals.Rat") as Class) >= 1) {
				GameController.getInstance().removeAnimalType(getDefinitionByName("deco3850.animals.Rat") as Class);
			}*/
			if(GameController.getInstance().getNumberAnimalInParty(Rat.getClass()) >= 1) {
				GameController.getInstance().removeAnimalType(Rat.getClass());
			}
			return true;
		}
		
		public static function getClass():Class {return getDefinitionByName("deco3850.animals.Cat") as Class;}
	}
}