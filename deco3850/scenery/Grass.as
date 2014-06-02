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
			this.setCooldownPeriod(10000);
			this.setAnimalSpawnType(getDefinitionByName('deco3850.animals.Rabbit') as Class);
		}
		
		override public function sceneryInteraction() {
			if(Debug.randomNumber(0, 1) == 0) {
				GameController.getInstance().createAnimal(getDefinitionByName("deco3850.animals.Rat") as Class, this.x);
			} else {
				GameController.getInstance().createAnimal(getDefinitionByName("deco3850.animals.Rat") as Class, this.x);
			}
			return true;
		}
	}
}