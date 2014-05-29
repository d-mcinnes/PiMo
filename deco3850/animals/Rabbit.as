package deco3850.animals {
	import flash.debug.Debug;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	public class Rabbit extends Animal {
		
		public function Rabbit() {
			this.setName("Rabbit");
			this.createTimer(4000);
			this.setTags(['all', 'rabbit', '010232cd72', '010238914a', '0102387557']);
			this.setScore(10);
		}
		
		override public function interactionAttach():Boolean {
			Debug.debugMessage("Aniaml " + this.getName() + " attached");
			if(GameController.getInstance().getNumberAnimalInParty(getDefinitionByName("deco3850.animals.Rabbit") as Class) == 2) {
				GameController.getInstance().attachAnimal(new Rabbit());
			}
			return true;
		}
	}
}