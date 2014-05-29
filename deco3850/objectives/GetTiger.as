package deco3850.objectives {
	import flash.debug.Debug;
	import flash.utils.getDefinitionByName;
	
	public class GetTiger extends Objective {
		public function GetTiger() {
			this.setName("Get Tiger");
			this.setDescription("Get a Tiger (0/1).");
			this.setScore(100);
		}
		
		override public function isComplete():Boolean {
			this.setDescription("Get a Tiger (" + 
								GameController.getInstance().getNumberAnimalInParty(getDefinitionByName("deco3850.animals.Tiger") as Class) + 
								"/1).");
			if(GameController.getInstance().getNumberAnimalInParty(Class(getDefinitionByName("deco3850.animals.Tiger"))) >= 1) {
				Debug.debugMessage("Objective [" + this.getName() + "] is complete");
				return true;
			} else {
				return false;
			}
		}
	}
}