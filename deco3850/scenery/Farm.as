package deco3850.scenery {
	import flash.debug.Debug;
	import flash.utils.getDefinitionByName;
	
	public class Farm extends Scenery {
		public function Farm(x:Number = 0, y:Number = 0) {
			this.setName("Farm");
			this.x = x;
			this.y = y;
			this.setCooldownPeriod(20000);
			this.setAnimalSpawnType(getDefinitionByName('deco3850.animals.Dog') as Class);
		}
		
		override public function sceneryInteraction() {
			
		}
	}
}