package  {
	import flash.debug.Debug;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	public class Main extends MovieClip {
		public function Main() {
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, detectKeyPress);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, restartGame);
			Mouse.hide();
			this.screenStartScreen.visible = false;
			startGame();
		}
		
		/** Runs when the user presses any key. **/
		private function detectKeyPress(e:KeyboardEvent) {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, detectKeyPress);
			//startGame();
		}
		
		/** Starts a new game. **/
		private function startGame() {
			GameController.createInstance(stage);
			GameController.getInstance().startGame();
			GameController.getInstance().pauseGame("Enter the playing area to begin the game.");
			GameController.getInstance().getNumberAnimalInParty(getDefinitionByName("deco3850.animals.Rabbit") as Class)
		}
		
		/** Shortcuts 
		 ** 	F5 - Restart Game
		 **		F6 - Toggle Debug Mode
		 **		F7 - Load Next Scene
		 **		F8 - Pause/Resume Game
		 **		F9 - Generate New Objective
		 **/
		
		/** Restarts the game when the user presses the F5 key. **/
		private function restartGame(e:KeyboardEvent) {
			if(e.keyCode == Keyboard.F5) {
				GameController.getInstance().endGame();
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
			if(e.keyCode == Keyboard.F8) {
				if(GameController.getInstance().isGamePaused() == true) {
					GameController.getInstance().resumeGame();
				} else {
					GameController.getInstance().pauseGame();
				}
			}
			if(e.keyCode == Keyboard.F9) {
				GameController.getInstance().generateObjective();
			}
		}
	}
}