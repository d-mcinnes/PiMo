package deco3850.scenery {
	import flash.debug.Debug;
	import flash.utils.getDefinitionByName;
	
	public class Fence extends Scenery {
		public function Fence(x:Number = 0, y:Number = 0, scale:Number = 1) {
			this.setName("Fence");
			this.x = x;
			this.y = y;
			this.scaleX = scale;
			this.scaleY = scale;
			this.setCooldownPeriod(10000);
		}
		
		override public function sceneryInteraction() {
			if(Debug.randomNumber(0, 1) == 0) {
				GameController.getInstance().createAnimal(getDefinitionByName("deco3850.animals.Cow") as Class, this.x);
			} else {
				GameController.getInstance().createAnimal(getDefinitionByName("deco3850.animals.Alphca") as Class, this.x);
			}
			return true;
		}
	}
}