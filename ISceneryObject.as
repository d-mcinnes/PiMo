package  {
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	public interface ISceneryObject {
		
		function getPosition():Point;
		
		function getImage():Bitmap;
		
		function getAnimal():Animal;
		
	}
	
}
