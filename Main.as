package  {
	import flash.display.MovieClip;
	
	public class Main extends MovieClip {
		private var environment:Environment;
		private var demo:Demo;
		
		public static var SIZE_X:Number = 1024;
		public static var SIZE_Y:Number = 768;
		
		public function Main() {
			//createEnvironment();
			this.demo = new Demo(this.stage);
			//new RFIDHandler();
		}
		
		private function createEnvironment() {
			this.environment = new Environment();
		}
	}
}