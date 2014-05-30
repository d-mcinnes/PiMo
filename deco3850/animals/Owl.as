package deco3850.animals {
	import flash.debug.Debug;
	import flash.utils.getDefinitionByName;
	
	public class Owl extends Animal {
		public function Owl() {
			this.setName("Owl");
			this.createTimer(4000);
			this.setTags(['all', 'owl', '2B005BC78037', '2B005B77ECEB', '2B005BD01FBF', '2B005B76B7B1', 
						  '2B005BB69650', '2B005BC51FAA', '2B005BAD29F4', '2B005BBC0AC6']);
			this.setScore(20);
		}
		
		override public function interactionAttach():Boolean {
			if(GameController.getInstance().getNumberAnimalInParty(Rat.getClass()) >= 1) {
				GameController.getInstance().removeAnimalType(Rat.getClass());
			}
			return true;
		}
		
		public static function getClass():Class {return getDefinitionByName("deco3850.animals.Owl") as Class;}
	}
}