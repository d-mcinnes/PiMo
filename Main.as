package  {
	import flash.debug.Debug;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.text.TextField;
	
	public class Main extends MovieClip {
		private var gameController:GameController;
		
		public static var STAGE:TextField;
		
		public function Main() {
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, detectKeyPress);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, restartGame);
			//debugText.text = "TEXT";
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
		
		/** Starts a new game. **/
		private function startGame() {
			this.gameController = new GameController(stage);
		}
		
		/** Shortcuts 
		 ** 	F5 - Restart Game
		 **		F6 - Toggle Debug Mode
		 **/
		
		/** Restarts the game when the user presses the F5 key. **/
		private function restartGame(e:KeyboardEvent) {
			if(e.keyCode == Keyboard.F5) {
				trace("================================================================================");
				this.gameController.gameCleanup();
				this.gameController = null;
				Debug.debugMessage("Restarting game");
				startGame();
			}
			if(e.keyCode == Keyboard.F6) {
				GameController.DEBUG_MODE_ON = !GameController.DEBUG_MODE_ON;
				if(GameController.DEBUG_MODE_ON == true) {
					trace("Debugging On...");
				} else {
					trace("Debugging Off...");
				}
			}
		}
	}
}