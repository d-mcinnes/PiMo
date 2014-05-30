package deco3850.animals {
	import flash.debug.Debug;
	import flash.utils.getDefinitionByName;
	
	public class Owl extends Animal {
		public function Owl() {
			this.setName("Owl");
			this.createTimer(4000);
			this.setTags(['all', 'owl', '010232cd72', '010238914a', '0102387557']);
			this.setScore(10);
		}
		
		override public function interactionAttach():Boolean {
			if(GameController.getInstance().getNumberAnimalInParty(getDefinitionByName("deco3850.animals.Rat") as Class) >= 1) {
				GameController.getInstance().removeAnimalType(getDefinitionByName("deco3850.animals.Rat") as Class);
			}
			return true;
		}
	}
}