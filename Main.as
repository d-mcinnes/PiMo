package  {
	import flash.display.MovieClip;
	
	public class Main extends MovieClip {
		private var environment:Environment;
		
		public static var SIZE_X:Number = 1024;
		public static var SIZE_Y:Number = 768;
		
		public function Main() {
			createEnvironment();
		}
		
		private function createEnvironment() {
			this.environment = new Environment();
		}
	}
}