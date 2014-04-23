package  {
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	public class SceneryFarm extends SceneryObject implements ISceneryObject {

		public function SceneryFarm() {
			// constructor code
		}
		
		override public function getPosition():Point {
			return null;
		}
		
		override public function getImage():Bitmap {
			return null;
		}
		
		override public function getAnimal():Animal {
			return null;
		}

	}
	
}
