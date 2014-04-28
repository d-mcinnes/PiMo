package  {
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.ui.Mouse;
	
	public class Main extends MovieClip {
		private var environment:Environment;
		private var demo:Demo;
		private var gameController:GameController;
		
		public function Main() {
			this.gameController = new GameController(stage);
			stage.displayState = StageDisplayState.FULL_SCREEN;
			Mouse.hide();
			//createEnvironment();
			//this.demo = new Demo(this.stage);
			//var skeletonBonesDemo:SkeletonBonesDemo = new SkeletonBonesDemo();
			//new RFIDHandler();
		}
		
		private function createEnvironment() {
			this.environment = new Environment();
		}
	}
}