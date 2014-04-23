package  {
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	public class SceneryTree extends SceneryObject implements ISceneryObject {

		public function SceneryTree() {
			
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
