package  {
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	
	public class Main extends MovieClip {
		private var gameController:GameController;
		
		public function Main() {
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, detectKeyPress);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, restartGame);
			Mouse.hide();
			//var skeletonBonesDemo:SkeletonBonesDemo = new SkeletonBonesDemo();
			//new RFIDHandler();
		}
		
		/** Runs when the user presses any key. **/
		private function detectKeyPress(e:KeyboardEvent) {
			this.screenStartScreen.visible = false;
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, detectKeyPress);
			startGame();
		}
		
		/** Restarts the game when the user presses the F5 key. **/
		private function restartGame(e:KeyboardEvent) {
			if(e.keyCode == Keyboard.F5) {
				trace("Restarting Game...");
				this.gameController.gameCleanup();
				this.gameController = null;
				startGame();
			}
		}
		
		/** Starts a new game. **/
		private function startGame() {
			this.gameController = new GameController(stage);
		}
	}
}