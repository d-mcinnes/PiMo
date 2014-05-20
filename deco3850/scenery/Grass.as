package deco3850.scenery {
	import flash.debug.Debug;
	import flash.utils.getDefinitionByName;
	
	public class Grass extends Scenery {
		public function Grass(x:Number = 0, y:Number = 0) {
			this.setName("Grass");
			this.x = x;
			this.y = y;
			this.setCooldownPeriod(1000);
			this.setAnimalSpawnType(getDefinitionByName('deco3850.animals.Rabbit') as Class);
		}
		
		override public function sceneryInteraction() {
			//var animal:Animal = new Owl();
			//spawnAnimal(animal, this.x, GameController.GROUND_HEIGHT);
			//object.setIsActive(false);
			//Debug.debugMessage("Spawning " + animal.getName() + " at [" + this.x  + ", " + this.y + "]");
		}
	}
}