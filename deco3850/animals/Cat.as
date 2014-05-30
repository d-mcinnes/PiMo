package deco3850.animals {
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	public class Cat extends Animal {
		public function Cat() {
			this.setName("Cat");
			this.createTimer(4000);
			this.setTags(['all', 'cat', '010232cd72', '010238914a', '0102387557']);
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