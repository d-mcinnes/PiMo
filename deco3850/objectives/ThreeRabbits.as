package deco3850.objectives {
	import flash.debug.Debug;
	import flash.utils.getDefinitionByName;
	
	public class ThreeRabbits extends Objective {
		public function ThreeRabbits() {
			this.setName("Three Rabbits");
			this.setDescription("Get three rabbits to follow you (0/3).");
			this.setScore(40);
		}
		
		override public function isComplete():Boolean {
			this.setDescription("Get three rabbits to follow you (" + 
								GameController.getInstance().getNumberAnimalInParty(getDefinitionByName("deco3850.animals.Rabbit") as Class) + 
								"/3).");
			if(GameController.getInstance().getNumberAnimalInParty(Class(getDefinitionByName("deco3850.animals.Rabbit"))) >= 3) {
				Debug.debugMessage("Objective is complete");
				return true;
			} else {
				Debug.debugMessage("Objective is not complete");
				return false;
			}
		}
	}
}