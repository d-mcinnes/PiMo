package  {
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	public class SceneryObject implements ISceneryObject {
		
		private var image:Bitmap;
		private var position:Point;
		private var animals:Array;

		public function SceneryObject() {
			
		}
		
		public function getPosition():Point {
			return this.position;
		}
		
		public function getImage():Bitmap {
			return this.image;
		}
		
		public function getAnimal():Animal {
			return null;
		}
		
	}
}