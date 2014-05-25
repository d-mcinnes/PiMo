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
		//private var gameController:GameController;
		
		//public static var STAGE:TextField;
		
		public function Main() {
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, detectKeyPress);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, restartGame);
			Mouse.hide();
		}
		
		/** Runs when the user presses any key. **/
		private function detectKeyPress(e:KeyboardEvent) {
			this.screenStartScreen.visible = false;
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, detectKeyPress);
			startGame();
		}
		
		/** Starts a new game. **/
		private function startGame() {
			GameController.createInstance(stage);
		}
		
		/** Shortcuts 
		 ** 	F5 - Restart Game
		 **		F6 - Toggle Debug Mode
		 **		F7 - Load Next Scene
		 **/
		
		/** Restarts the game when the user presses the F5 key. **/
		private function restartGame(e:KeyboardEvent) {
			if(e.keyCode == Keyboard.F5) {
				trace("================================================================================");
				GameController.getInstance().gameCleanup();
				GameController.getInstance().startGame();
				Debug.debugMessage("Restarting game");
			}
			if(e.keyCode == Keyboard.F6) {
				GameController.DEBUG_MODE_ON = !GameController.DEBUG_MODE_ON;
				if(GameController.DEBUG_MODE_ON == true) {
					trace("Debugging On...");
				} else {
					trace("Debugging Off...");
				}
			}
			if(e.keyCode == Keyboard.F7) {
				Debug.debugMessage("Loading next scene");
				GameController.getInstance().loadScene();
			}
		}
	}
}