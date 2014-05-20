package deco3850.scenery {
	import flash.debug.Debug;
	import flash.utils.getDefinitionByName;
	
	public class Grass extends Scenery {
		public function Grass() {
			this.setName("Grass");
			this.setAnimalSpawnType(getDefinitionByName('deco3850.animals.Owl') as Class);
		}
		
		override public function sceneryInteraction() {
			//var animal:Animal = new Owl();
			//spawnAnimal(animal, this.x, GameController.GROUND_HEIGHT);
			//object.setIsActive(false);
			//Debug.debugMessage("Spawning " + animal.getName() + " at [" + this.x  + ", " + this.y + "]");
		}
	}
}