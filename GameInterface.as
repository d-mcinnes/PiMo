package  {
	import flash.debug.Debug;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import com.greensock.TweenLite;
	
	import deco3850.scenery.Farm;
	import deco3850.scenery.Tree;
	
	public class GameInterface {
		/* Text */
		private var scoreTextField:TextField;
		private var textFormat:TextFormat;
		private var timerTextField:TextField;
		private var objectiveTextField:TextField;
		private var objectiveTextFormat:TextFormat;
		private var gameMessageField:TextField;
		private var gameMessageFormat:TextFormat;
		private var scoreUpdateField:TextField;
		private var scoreUpdateFormat:TextFormat;
		
		/* Food Items */
		private var foodItems:GameInterfaceFood;
		private var foodItemsObjects:MovieClip;
		
		/* Backgrounds */
		private var gamePausedBackground:GamePausedBackground;
		private var gameTransitionBackground:GameTransitionBackground;
		
		public function GameInterface() {
			/* Text */
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
			this.gameMessageFormat.align = TextFormatAlign.LEFT;
			this.gameMessageFormat.bold = true;
			this.gameMessageFormat.font = new ScoreFont().fontName;
			
			this.gameMessageField = new TextField();
			this.gameMessageField.x = 60;
			this.gameMessageField.y = GameController.SCREEN_SIZE_Y / 3;
			this.gameMessageField.width = GameController.SCREEN_SIZE_X / 2;
			this.gameMessageField.textColor = 0x000000;
			this.gameMessageField.selectable = false;
			this.gameMessageField.defaultTextFormat = this.gameMessageFormat;
			this.gameMessageField.text = "";
			TweenLite.to(this.gameMessageField, 0, {alpha:0});
			GameController.getInstance().getStageOverlay().addChild(this.gameMessageField);
			
			this.scoreUpdateFormat = new TextFormat();
			this.scoreUpdateFormat.size = 40;
			this.scoreUpdateFormat.align = TextFormatAlign.CENTER;
			this.scoreUpdateFormat.bold = true;
			this.scoreUpdateFormat.font = new ScoreFont().fontName;
			
			this.scoreUpdateField = new TextField();
			this.scoreUpdateField.x = 0;
			this.scoreUpdateField.y = GameController.SCREEN_SIZE_Y / 3;
			this.scoreUpdateField.width = 100;
			this.scoreUpdateField.textColor = 0x000000;
			this.scoreUpdateField.selectable = false;
			this.scoreUpdateField.defaultTextFormat = this.scoreUpdateFormat;
			this.scoreUpdateField.text = "";
			TweenLite.to(this.gameMessageField, 0, {alpha:0});
			GameController.getInstance().getStageOverlay().addChild(this.scoreUpdateField);
			
			/* Food Items */
			//this.foodItems = new Sprite();
			//this.foodItems.width = 400;
			//this.foodItems.height = 500;
			//this.foodItems.x = GameController.SCREEN_SIZE_X - this.foodItems.width - 10;
			//this.foodItems.y = 30;
			//this.foodItems.x = 50;
			
			//this.foodItems.addChild(new Icon_Bone());
			//var i:Icon_Bone = new Icon_Bone();
			//i.x = 0;
			//i.y = 0;
			//this.foodItems.addChild(i);
			//GameController.getInstance().getStageOverlay().addChild(i);
			//GameController.getInstance().getStageOverlay().addChild(this.foodItems);
			this.foodItems = new GameInterfaceFood();
			GameController.getInstance().getStageOverlay().addChild(this.foodItems);
			
			
			Debug.debugMessage("Added Stuff");
			
			/* Backgrounds */
			this.gamePausedBackground = new GamePausedBackground();
			this.gamePausedBackground.x = 0;
			this.gamePausedBackground.y = 0;
			this.gamePausedBackground.visible = false;
			GameController.getInstance().getStageOverlay().addChild(this.gamePausedBackground);
			
			this.gameTransitionBackground = new GameTransitionBackground();
			this.gameTransitionBackground.x = 0;
			this.gameTransitionBackground.y = 0;
			TweenLite.to(this.gameTransitionBackground, 0, {alpha:0});
			GameController.getInstance().getStageOverlay().addChild(this.gameTransitionBackground);
			
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
			TweenLite.to(this.gameMessageField, 4, {delay:1.5, alpha:0});
		}
		
		public function displayScoreUpdate(score:Number) {
			this.scoreUpdateField.x = GameController.getInstance().getPlayerX();
			this.scoreUpdateField.text = "+ " + score;
			TweenLite.to(this.scoreUpdateField, 0, {alpha:1});
			TweenLite.to(this.scoreUpdateField, 4, {y:(GameController.SCREEN_SIZE_Y / 3 - 20), alpha:0});
		}
		
		public function renderFoodIcons() {
			this.foodItems.renderIcons();
		}
		
		public function displayTransitionBackground(time:Number) {
			TweenLite.to(this.gameTransitionBackground, time, {alpha:1});
		}
		
		public function hideTransitionBackground(time:Number) {
			TweenLite.to(this.gameTransitionBackground, time, {alpha:0});
		}
		
		public function generateFinalScreen():Sprite {
			var screen:Sprite = new Sprite();
			screen.addChild(new Background_Dynamic());
			
			/* Create Scenery Objects */
			var farm:Farm = new Farm();
			farm.x = 400;
			farm.y = 500;
			screen.addChild(farm);
			
			var tree:Tree = new Tree();
			tree.x = 200;
			tree.y = 450;
			screen.addChild(tree);
			
			/* Render Animals */
			var x:Number = 600;
			var y:Number = 450;
			for each(var i in GameController.getInstance().getAnimalHistory()) {
				var animal:Animal = new i();
				animal.x = x;
				animal.y = Debug.randomNumber(y - 20, y + 20);
				animal.playIdleAnimation();
				screen.addChild(animal);
				x -= 65;
			}
			
			/* Add to Screen (For Testing) */
			//GameController.getInstance().getStageOverlay().addChild(screen);
			return screen;
		}
	}
}