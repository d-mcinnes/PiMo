package deco3850.animals {
	import flash.debug.Debug;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	public class Rabbit extends Animal {
		
		public function Rabbit() {
			this.setName("Rabbit");
			this.createTimer(7000);
			this.setTags(['all', 'rabbit', '0103C80917D4', '01023880D46F', '010238776E22', '0B00E74BF354', 
						  '0102389F15B1', '0103F49EB8D0', '190065293B6E', '0103D778973A', '01056DF553CF', 
						  '0103D7E13703', '2B005BADC71A', '010445B541B4', '2B005BA24E9C', '0102BC08FF48', 
						  '2B005B937B98', '2B005BA6A573']);
			this.setScore(10);
		}
		
		override public function interactionAttach():Boolean {
			if(GameController.getInstance().getNumberAnimalInParty(Rabbit.getClass()) == 2) {
				GameController.getInstance().attachAnimal(new Rabbit());
				GameController.getInstance().displayGameMessage("Three Rabbits Thing.");
			}
			return true;
		}
		
		public static function getClass():Class {return getDefinitionByName("deco3850.animals.Rabbit") as Class;}
	}
}