package deco3850.scenery {
	import flash.debug.Debug;
	import flash.utils.getDefinitionByName;
	
	public class Burrow extends Scenery {
		public function Burrow(x:Number = 0, y:Number = 0, scale:Number = 1) {
			this.setName("Burrow");
			this.x = x;
			this.y = y;
			this.scaleX = scale;
			this.scaleY = scale;
			this.setCooldownPeriod(10000);
		}
		
		override public function sceneryInteraction() {
			GameController.getInstance().createAnimal(getDefinitionByName("deco3850.animals.Rabbit") as Class, this.x);
			return true;
		}
	}
}