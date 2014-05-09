package  {
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	
	public class Main extends MovieClip {
		private var environment:Environment;
		private var demo:Demo;
		private var gameController:GameController;
		
		public function Main() {
			stage.displayState = StageDisplayState.FULL_SCREEN;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, detectKeyPress);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, restartGame);
			Mouse.hide();
			//createEnvironment();
			//this.demo = new Demo(this.stage);
			//var skeletonBonesDemo:SkeletonBonesDemo = new SkeletonBonesDemo();
			//new RFIDHandler();
		}
		
		private function detectKeyPress(e:KeyboardEvent) {
			trace("The keypress code is: " + e.keyCode);
			if(e.keyCode == Keyboard.SPACE) {
				trace("Space");
			}
			this.screenStartScreen.visible = false;
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, detectKeyPress);
			startGame();
		}
		
		private function restartGame(e:KeyboardEvent) {
			if(e.keyCode == Keyboard.F5) {
				trace("Restarting Game...");
				this.gameController.gameCleanup();
				this.gameController = null;
				startGame();
			}
		}
		
		private function startGame() {
			this.gameController = new GameController(stage);
		}
		
		private function createEnvironment() {
			this.environment = new Environment();
		}
	}
}