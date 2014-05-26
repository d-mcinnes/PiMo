package deco3850.objectives {
	import flash.debug.Debug;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class L1_ThreeRabbits extends Objective {
		
		public function L1_ThreeRabbits() {
			this.setName("Three Rabbits");
			this.setDescription("Get three rabbits to follow you (0/3).");
		}
		
		override public function isComplete():Boolean {
			this.setDescription("Get three rabbits to follow you (" + 
								GameController.getInstance().getNumberAnimalInParty(Class(getDefinitionByName("deco3850.animals.Rabbit"))) + 
								"/3).");
			if(GameController.getInstance().getNumberAnimalInParty(Class(getDefinitionByName(getQualifiedClassName("Rabbit")))) >= 3) {
				Debug.debugMessage("Objective is complete");
				return true;
			} else {
				Debug.debugMessage("Objective is not complete");
				return false;
			}
		}
	}
}