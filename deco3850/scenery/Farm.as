package deco3850.scenery {
	import flash.debug.Debug;
	import flash.utils.getDefinitionByName;
	
	public class Farm extends Scenery {
		public function Farm(x:Number = 0, y:Number = 0, scale:Number = 1) {
			this.setName("Farm");
			this.x = x;
			this.y = y;
			this.scaleX = scale;
			this.scaleY = scale;
			this.setCooldownPeriod(20000);
			this.setAnimalSpawnType(getDefinitionByName('deco3850.animals.Dog') as Class);
		}
		
		override public function sceneryInteraction() {
			if(GameController.getInstance().getNumberAnimalInParty(getDefinitionByName("deco3850.animals.Cat") as Class) >= 1) {
				GameController.getInstance().createAnimal(getDefinitionByName('deco3850.animals.Dog') as Class, this.x);
			} else {
				GameController.getInstance().createAnimal(getDefinitionByName('deco3850.animals.Cat') as Class, this.x);
			}
			return true;
		}
	}
}