package  {
	import flash.debug.Debug;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import com.greensock.TweenLite;
	
	public class GameInterface {
		private var scoreTextField:TextField;
		private var textFormat:TextFormat;
		private var timerTextField:TextField;
		private var objectiveTextField:TextField;
		private var objectiveTextFormat:TextFormat;
		private var gameMessageField:TextField;
		private var gameMessageFormat:TextFormat;
		private var gamePausedBackground:GamePausedBackground;
		
		public function GameInterface() {
			this.scoreTextField = new TextField();
			this.scoreTextField.y = 0;
			this.scoreTextField.x = 10;
			this.scoreTextField.width = 185;
			this.scoreTextField.textColor = 0x000000;
			this.scoreTextField.selectable = false;
			
			this.textFormat = new TextFormat();
			this.textFormat.size = 25;
			this.textFormat.align = TextFormatAlign.LEFT;
			this.textFormat.bold = true;
			this.textFormat.font = new ScoreFont().fontName;
			
			this.scoreTextField.defaultTextFormat = this.textFormat;
			this.scoreTextField.text = "Score: " + GameController.getInstance().getScore();
			GameController.getInstance().getStageOverlay().addChild(this.scoreTextField);
			
			this.timerTextField = new TextField();
			this.timerTextField.x = 10;
			this.timerTextField.y = 30;
			this.timerTextField.width = 185;
			this.timerTextField.textColor = 0x000000;
			this.timerTextField.selectable = false;
			this.timerTextField.defaultTextFormat = this.textFormat;
			this.timerTextField.text = "Time: ";
			GameController.getInstance().getStageOverlay().addChild(this.timerTextField);
			
			this.objectiveTextFormat = new TextFormat();
			this.objectiveTextFormat.size = 20;
			this.objectiveTextFormat.align = TextFormatAlign.RIGHT;
			this.objectiveTextFormat.bold = true;
			this.objectiveTextFormat.font = new ScoreFont().fontName;
			
			this.objectiveTextField = new TextField();
			this.objectiveTextField.x = GameController.SCREEN_SIZE_X - 410;
			this.objectiveTextField.y = 5;
			this.objectiveTextField.width = 400;
			this.objectiveTextField.textColor = 0x000000;
			this.objectiveTextField.selectable = false;
			this.objectiveTextField.defaultTextFormat = this.objectiveTextFormat;
			this.objectiveTextField.text = "";
			GameController.getInstance().getStageOverlay().addChild(this.objectiveTextField);
			
			this.gameMessageFormat = new TextFormat();
			this.gameMessageFormat.size = 25;
			this.gameMessageFormat.align = TextFormatAlign.CENTER;
			this.gameMessageFormat.bold = true;
			this.gameMessageFormat.font = new ScoreFont().fontName;
			
			this.gameMessageField = new TextField();
			this.gameMessageField.x = GameController.SCREEN_SIZE_X / 4;
			this.gameMessageField.y = 5;
			this.gameMessageField.width = GameController.SCREEN_SIZE_X / 2;
			this.gameMessageField.textColor = 0x000000;
			this.gameMessageField.selectable = false;
			this.gameMessageField.defaultTextFormat = this.gameMessageFormat;
			this.gameMessageField.text = "";
			TweenLite.to(this.gameMessageField, 0, {alpha:0});
			GameController.getInstance().getStageOverlay().addChild(this.gameMessageField);
			
			this.gamePausedBackground = new GamePausedBackground();
			this.gamePausedBackground.x = 0;
			this.gamePausedBackground.y = 0;
			this.gamePausedBackground.visible = false;
			GameController.getInstance().getStageOverlay().addChild(this.gamePausedBackground);
			
			var overlay:BlackOverlay = new BlackOverlay();
			overlay.x = -300;
			overlay.y = -110;
			GameController.getInstance().getStageOverlay().addChild(overlay);
		}
		
		public function setScoreText(score:Number) {
			this.scoreTextField.text = "Score: " + score;
		}
		
		public function setTimerText(gameIncrement:Number, timerCurrent:Number) {
			this.timerTextField.text = "Time: " + Debug.padChar(String(Math.floor(((gameIncrement - timerCurrent) / 60) % 60)), 2, '0', true) + 
				":" + Debug.padChar(String((gameIncrement - timerCurrent) % 60), 2, '0', true);
		}
		
		public function setObjectiveText(objective:Objective) {
			this.objectiveTextField.text = objective.getDescription();
		}
		
		public function setPausedVisible(visible:Boolean) {this.gamePausedBackground.visible = visible;}
		public function setPausedText(text:String) {this.gamePausedBackground.messageBox.text = text;}
		
		public function displayGameMessage(text:String) {
			TweenLite.to(this.gameMessageField, 0, {alpha:1});
			this.gameMessageField.text = text;
			this.gameMessageField.y = 150;
			TweenLite.to(this.gameMessageField, 4, {y:120, delay:1.5, alpha:0});
		}
	}
}