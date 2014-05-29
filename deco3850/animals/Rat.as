package deco3850.animals {
	import flash.debug.Debug;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	public class Rat extends Animal {
		
		public function Rat() {
			this.setName("Rat");
			this.createTimer(4000);
			this.setTags(['all', 'rat', '010232cd72', '010238914a', '0102387557']);
			this.setScore(10);
		}
		
		override public function interactionAttach():Boolean {
			Debug.debugMessage("Aniaml " + this.getName() + " attached");
			if(GameController.getInstance().getIsAnimalInParty(getDefinitionByName("deco3850.animals.Owl") as Class) == false &&
			   GameController.getInstance().getIsAnimalInWild(getDefinitionByName("deco3850.animals.Owl") as Class) == false) {
				Debug.debugMessage("Spawning Owl");
				GameController.getInstance().spawnAnimal(new Owl(), Debug.randomNumber(200, GameController.SCREEN_SIZE_X - 200), GameController.GROUND_HEIGHT);
			}
			return true;
		}
	}
}