package deco3850.scenery {
	import flash.debug.Debug;
	import flash.utils.getDefinitionByName;
	
	public class Grass extends Scenery {
		public function Grass(x:Number = 0, y:Number = 0, scale:Number = 1) {
			this.setName("Grass");
			this.x = x;
			this.y = y;
			this.scaleX = scale;
			this.scaleY = scale;
			this.setCooldownPeriod(5000);
			this.setAnimalSpawnType(getDefinitionByName('deco3850.animals.Rabbit') as Class);
		}
		
		override public function sceneryInteraction() {
			//var type:Class = this.getAnimalSpawnType().getType();
			//if(GameController.getInstance().getNumberOfAnimals(type) >= 2) {
			//	Debug.debugMessage("Hello");
			//	GameController.getInstance().removeAnimalType(type);
			//}
			GameController.getInstance().createAnimal(this.getAnimalSpawnType(), this.x);
			return true;
		}
	}
}