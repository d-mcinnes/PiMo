package  {
	import flash.debug.Debug;
	import flash.display.Stage;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.Font;
	
	import deco3850.animals.*;
	import deco3850.objectives.*;
	import deco3850.scenery.*;

	public class GameController {
		private static var gameController:GameController = null;
		
		//private var obj1:ThreeRabbits = null;
		
		/* General Variables */
		private var document:Stage;
		private var kinectInput:KinectInput;
		private var rfidReader:RFIDReaderSingle;
		
		/* Stage Objects */
		private var stageOverlay:Sprite;
		private var stageMain:Sprite;
		private var stageBackground:Sprite;
		private var stageAnimals:Sprite;
		private var stagePlayer:Sprite;
		private var stageForeground:Sprite;
		
		/* Scene Variables */
		private var score:int; //cumulative score for this game, nonnegative
		private var currentObjective:Objective = null;
		
		/* Game Duration Variables */
		private var gameTimer:Timer;
		private var gameIncrement:Number = 2 * 60;
		
		/* Gameplay Objects */
		private var scenery:Array; //interactable objects in the background
		private var sceneryPosition:Array;
		private var wild:Array; //animals in the scene, not following the player
		private var party:Array; //animals currently following the player
		private var player:Player;
		private var paused:Boolean = false;
		
		/* Interface Elements */
		private var scoreTextField:TextField;
		private var textFormat:TextFormat;
		private var timerTextField:TextField;
		private var objectiveTextField:TextField;
		private var objectiveTextFormat:TextFormat;
		private var gamePausedBackground:GamePausedBackground;
		
		/* Static Variables */
		public static var SCREEN_SIZE_X:Number = 1024;
		public static var SCREEN_SIZE_Y:Number = 600;
		public static var GROUND_HEIGHT:Number = 440;
		public static var DEBUG_MODE_ON:Boolean = true;
		public static var DEBUG_DISPLAY_MODE_ON:Boolean = false;

		/**
		 * Controls the proceedings for one round of the game.
		 */
		public function GameController(document:Stage) {
			this.document = document;
			this.kinectInput = new KinectInput(this);
			this.rfidReader = new RFIDReaderSingle(this);
			Debug.debugMessage("Game Controller Started");
		}
		
		/** Takes a Stage and creates an instance of the GameController class. **/
		public static function createInstance(document:Stage):GameController {
			gameController = new GameController(document);
			return gameController;
		}
		
		/** If one exists, returns the current instance of the GameController class. **/
		public static function getInstance():GameController {
			if(gameController == null) {
				Debug.debugMessage("No Game Controller");
				return null;
			}
			return gameController;
		}
		
		/** Starts the current game. **/
		public function startGame() {
			this.stageMain = new Sprite();
			this.stageBackground = new Sprite();
			this.stageAnimals = new Sprite();
			this.stagePlayer = new Sprite();
			this.stageForeground = new Sprite();
			this.stageOverlay = new Sprite();
			
			this.score = 0;
			this.party = new Array();
			this.wild = new Array();
			
			this.player = new Player();
			this.player.x = 50;
			this.player.y = 400;
			this.stagePlayer.addChild(this.player);
			
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
			this.scoreTextField.text = "Score: " + this.score;
			this.stageOverlay.addChild(this.scoreTextField);
			
			this.timerTextField = new TextField();
			this.timerTextField.x = 10;
			this.timerTextField.y = 30;
			this.timerTextField.width = 185;
			this.timerTextField.textColor = 0x000000;
			this.timerTextField.selectable = false;
			this.timerTextField.defaultTextFormat = this.textFormat;
			this.timerTextField.text = "Time: ";
			this.stageOverlay.addChild(this.timerTextField);
			
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
			this.stageOverlay.addChild(this.objectiveTextField);
			
			this.gamePausedBackground = new GamePausedBackground();
			this.gamePausedBackground.x = 0;
			this.gamePausedBackground.y = 0;
			this.gamePausedBackground.visible = false;
			this.stageOverlay.addChild(this.gamePausedBackground);
			
			var overlay:BlackOverlay = new BlackOverlay();
			overlay.x = -300;
			overlay.y = -110;
			this.stageOverlay.addChild(overlay);
			
			this.document.addEventListener(KeyboardEvent.KEY_DOWN, keySpacePress);
			
			loadScene();
			
			this.document.addChild(this.stageMain);
			this.document.addChild(this.stageBackground);
			this.document.addChild(this.stageAnimals);
			this.document.addChild(this.stagePlayer);
			this.document.addChild(this.stageForeground);
			this.document.addChild(this.stageOverlay);
			
			this.gameTimer = new Timer(1000, this.gameIncrement);
			this.gameTimer.addEventListener(TimerEvent.TIMER, gameTimerEvent);
			this.gameTimer.start();
			
			this.timerTextField.text = "Time: " + Debug.padChar(String(Math.floor(((this.gameIncrement - this.gameTimer.currentCount) / 60) % 60)), 2, '0', true) + 
				":" + Debug.padChar(String((this.gameIncrement - this.gameTimer.currentCount) % 60), 2, '0', true);
			
			Debug.debugMessage("Game Started");
		}
		
		/** *************************************** **/
		/**   G E N E R A L   F U N C I T I O N S   **/
		/** *************************************** **/
		
		public function getStage():Stage {return this.document;}
		public function getStageMain():Sprite {return this.stageMain;}
		public function getStageOverlay():Sprite {return this.stageOverlay;}
		public function getKinectSkeleton():KinectSkeleton {return this.kinectInput.getKinectSkeleton();}
		public function getNumberOfUsers():Number {return this.kinectInput.getNumberOfUsers();}
		public function getScenery():Array {return this.scenery;}
		public function getParty():Array {return this.party;}
		public function getWildAnimals():Array {return this.wild;}
		
		public function getScore():Number {return this.score;}
		public function incrementScore(increment:Number) {this.score += increment;}
		
		/** Takes a class type and returns the number of many instances of that 
		 ** animal which are currently in the party. **/
		public function getNumberOfAnimals(animal:Class):Number {
			var count:Number = 0;
			for each(var object in this.getParty()) {
				if(Class(getDefinitionByName(getQualifiedClassName(object))) == animal) {
					count++;
				}
			}
			return count;
		}
		
		/** Renders the player, as well as any animals which are currently following
		 ** the player. **/
		public function renderPlayer() {
			var index:Number = 0;
			this.player.renderPlayer();
			for each (var animal in party) {
				index++;
				animal.x = GameController.SCREEN_SIZE_X * this.kinectInput.getKinectSkeleton().getPositionRelative().x - 200 - (index * 30);
			}
		}
		
		/** Loads a scene. **/
		public function loadScene():void {
			this.sceneCleanup();
			this.wild = new Array();
			this.party = new Array();
			this.loadScenery();
			this.generateObjective();
		}
		
		/** ***************** **/
		/**   S C E N E R Y   **/
		/** ***************** **/
		
		/** Takes a x position and checks whether or not it collides with any other
		 ** objects. **/
		private function sceneryCheckPosition(x:Number):Boolean {
			for each(var object in this.getScenery()) {
				if(x > object.x && x < object.x + object.width) {
					return false;
				}
			}
			return true;
		}
		
		/** Takes a x position and checks whether or not it collides with any other
		 ** objects. **/
		private function sceneryCheckPositio2n(x:Number, width:Number):Boolean {
			for each(var object in this.getScenery()) {
				if((x > object.x && x < object.x + object.width) || 
				   (width > object.x && width < object.x + object.width)) {
					//Debug.debugMessage("Bad position: " + x);
					return false;
				}
			}
			return true;
		}
		
		/** Takes a scenery object and a sprite, and adds the scenery object to the
		 ** game. Returns the scenery object when completed. **/
		private function sceneryCreateObject2(object:Scenery, sprite:Sprite):Scenery {
			this.scenery.push(object);
			return object;
		}
		
		/** Loads the scenery for the current scene. **/
		private function loadScenery():void {
			this.scenery = new Array();
			this.sceneryPosition = new Array();
			
			/* Create Farm */
			var farm:Farm = new Farm((Math.floor(Math.random() * (GameController.SCREEN_SIZE_X - 550 + 1)) + 100), 
									   GameController.GROUND_HEIGHT);
			farm.setIsActive(true);
			this.scenery.push(farm);
			this.stageBackground.addChild(farm);
			
			/* Create Tree(s) */
			for(var i:int = 0; i < (Math.floor(Math.random() * 2) + 1); i++) {
				var x:Number = 0; var tree:Tree = new Tree(); var scale:Number = (Math.random() * 0.5 + 0.750);
				tree.scaleX = scale;
				tree.scaleY = scale;
				for(var count:int = 0; count < 100; count++ ) {
					x = (Math.floor(Math.random() * (GameController.SCREEN_SIZE_X - 200 + 1)));
					if(sceneryCheckPositio2n(x, tree.width) == true) {
						break;
					}
				}
				tree.x = x;
				tree.y = GameController.GROUND_HEIGHT;
				tree.setIsActive(true);
				this.scenery.push(tree);
				this.stageBackground.addChild(tree);
			}
			
			/* Create Grass */
			for(var n:int = 0; n < (Math.floor(Math.random() * 4) + 1); n++) {
				var grass:Grass = new Grass((Math.floor(Math.random() * (GameController.SCREEN_SIZE_X - 150 + 1)) + 150), 
											GameController.GROUND_HEIGHT + 20);
				grass.setIsActive(true);
				this.scenery.push(grass);
				this.stageForeground.addChild(grass);
			}
		}
		
		/** Checks to see whether or not the user is in the current bounds of the
		 ** screen. Takes a Scenery object and returns a Boolean. **/
		public function checkObjectBounds(object:Object):Boolean {
			if(((Math.abs(object.x - this.player.localToGlobal(this.player.getLeftPoint()).x) < 100) && 
						 (Math.abs(object.y - this.player.localToGlobal(this.player.getLeftPoint()).y) < 100)) ||
					   ((Math.abs(object.x - this.player.localToGlobal(this.player.getRightPoint()).x) < 100) && 
						 (Math.abs(object.y - this.player.localToGlobal(this.player.getRightPoint()).y) < 100))) {
				return true;
			} else {
				return false;
			}
		}
		
		/** **/
		public function createAnimal(type:Class, positionX:Number):Animal {
			var animal:Animal = new type();
			spawnAnimal(animal, positionX, GameController.GROUND_HEIGHT);
			Debug.debugMessage("Spawning " + animal.getName() + " at [" + positionX  + ", " + GameController.GROUND_HEIGHT + "]");
			return animal;
		}
		
		/** **/
		public function removeAnimalType(type:Class):Boolean {
			for each(var object in this.getParty()) {
				if(object.getType() == type) {
					this.removeAnimal(object);
					return true;
				}
			}
			return false;
		}
		
		/** Checks for any scenery interaction from the player. Runs every time
		 ** the Kinect is updated. **/
		public function checkForSceneryInteraction(leftPosition:Point, rightPosition:Point):void {
			for each (var object in this.getScenery()) {
				if(object.isActive()) {
					if(this.player.getLeftPoint() == null || this.player.getRightPoint() == null) {
						return;
					}
					//Debug.debugMessage("Left: " + this.player.getLeftPoint() + " Right: " + this.player.getRightPoint());
					if(checkObjectBounds(object)) {
						/*if(this.currentObjective != null) {
							if(this.currentObjective.isComplete() == true) {
								Debug.debugMessage("!Objective Complete!");
							}
						}*/
						object.sceneryInteraction();
						//var type:Class = object.getAnimalSpawnType();
						//var animal:Animal = new type();
						//spawnAnimal(animal, object.x, GameController.GROUND_HEIGHT);
						object.setIsActive(false);
						
						this.checkCurrentObjective();
						//Debug.debugMessage("Spawning " + animal.getName() + " at [" + object.x  + ", " + object.y + "]");*/
					}
				}
			}
		}
		
		/** ***************** **/
		/**   A N I M A L S   **/
		/** ***************** **/
		
		/** Runs when the despawn animal timer expires. **/
		public function despawnTimer(animal:Animal, scenery:Object):Function {
			return function(e:TimerEvent):void {
				if(!scenery.isActive()) {
					scenery.setIsActive(true);
				}
				despawnAnimal(animal);
			}
		}
		
		/** Spawns an animal at the given point. Takes an animal, and an x and
		 ** y coordinates. **/
		private function spawnAnimal(animal:Animal, x:Number, y:Number):void {
			this.wild.push(animal);
			animal.x = x;
			animal.y = y;
			animal.setTimerEvent(animalDespawnTimerEvent(animal));
			animal.playIdleAnimation();
			animal.startTimer();
			this.stageAnimals.addChild(animal);
		}
		
		/** Runs when the despawn animal timer expires. **/
		public function animalDespawnTimerEvent(animal:Animal):Function {
			return function(e:TimerEvent):void {
				if(animalIsInParty(animal) == false ) {
					despawnAnimal(animal);
				}
			}
		}
		
		private function animalDespawnTimerEvent2(e:TimerEvent) {
			Debug.debugMessage("Animal Despawn Timer Event");
		}
		
		/** Despawns an animal from the screen. **/
		private function despawnAnimal(animal:Animal):void {
			try {
				this.stageAnimals.removeChild(animal);
			} catch(e:Error) {
				Debug.debugMessage(e.toString());
			}
			for each (var object in wild) {
				if(object == animal) {
					wild.splice(wild.indexOf(object), 1);
				}
			}
		}
		
		/** Adds an animal to the players party. **/
		private function attachAnimal(animal:Animal):void {
			//clear timer for despawnAnimal
			//TODO check for animal interactions
			party.push(animal);
			animal.playWalkAnimation();
			//this.score += animal.getScore();
			this.incrementScore(animal.getScore());
			this.scoreTextField.text = "Score: " + this.getScore();
			for each (var object in wild) {
				if(object == animal) {
					wild.splice(wild.indexOf(animal), 1);
				}
			}
			this.checkCurrentObjective();
			Debug.debugMessage("Attaching " + animal.getName());
			//score += animal.getScore();
		}
		
		/** Removes an animal from the players party. **/
		public function removeAnimal(animal:Animal):Boolean {
			var index = party.indexOf(animal);
			if (index >= 0) {
				party.splice(index, 1);
				score -= animal.getScore();
				return true;
			} else {
				return false;
			}
		}
		
		/** Checks to see whether or not an animal is in the players
		 ** party. */
		public function animalIsInParty(animal:Animal):Boolean {
			for each(var object in this.party) {
				if(object == animal) {
					return true;
				}
			}
			return false;
		}
		
		/** **/
		public function getNumberAnimalInParty(animal:Class):Number {
			var count:Number = 0;
			for each(var object in this.party) {
				if(object.getType() == animal) {
					count++;
				}
			}
			return count;
		}
		
		/** Runs when the player activates one of the Arduino tags. **/
		public function activateTag(tag:String) {
			for each (var animal in wild) {
				if(animal.checkTag(tag)) {
					attachAnimal(animal);
				}
			}
		}
		
		/** Ruins when the player deactivates one of the Arduino tags. **/
		public function deactivateTag(tag:String) {
			
		}
		
		/** Runs when the user presses the space key **/
		private function keySpacePress(e:KeyboardEvent) {
			/* R - Rabbit
			 * D - Dog
			 * C - Cat
			 * O - Owl */
			if(e.keyCode == Keyboard.SPACE) {
				this.activateTag('all');
			} else if(e.keyCode == Keyboard.R) {
				this.activateTag('rabbit');
			} else if(e.keyCode == Keyboard.D) {
				this.activateTag('dog');
			} else if(e.keyCode == Keyboard.C) {
				this.activateTag('cat');
			} else if(e.keyCode == Keyboard.O) {
				this.activateTag('owl');
			} else if(e.keyCode == Keyboard.T) {
				this.activateTag('tiger');
			}
		}
		
		/** *********************** **/
		/**   O B J E C T I V E S   **/
		/** *********************** **/
		
		public function setObjectiveText(text:String) {
			this.objectiveTextField.text = text;
		}
		
		public function getCurrentObjective():Objective {return this.currentObjective;}
		
		public function generateObjective():Objective {
			var number:Number = Debug.randomNumber(0, Assets.OBJECTIVES[0].length - 1);
			var reference:Class = getDefinitionByName(Assets.OBJECTIVES[0][number]) as Class;
			this.currentObjective = new reference();
			Debug.debugMessage("Objective Name: " + this.currentObjective.getName() + " Description: " + this.currentObjective.getDescription());
			this.objectiveTextField.text = this.currentObjective.getDescription();
			return this.currentObjective;
		}
		
		public function completeCurrentObjective() {this.getCurrentObjective().complete();}
		public function setCurrentObjectiveText() {this.objectiveTextField.text = this.currentObjective.getDescription();}
		
		public function checkCurrentObjective() {
			if(this.currentObjective != null) {
				if(this.currentObjective.isComplete() == true) {
					Debug.debugMessage("!Objective Complete!");
					this.incrementScore(this.currentObjective.getScore());
					this.loadScene();
				}
				this.setCurrentObjectiveText();
			}
		}
		
		/** ***************************** **/
		/**   G A M E   D U R A T I O N   **/
		/** ***************************** **/
		
		/** Runs when _____ **/
		private function gameTimerEvent(e:TimerEvent) {
			this.timerTextField.text = "Time: " + Debug.padChar(String(Math.floor(((this.gameIncrement - this.gameTimer.currentCount) / 60) % 60)), 2, '0', true) + 
				":" + Debug.padChar(String((this.gameIncrement - this.gameTimer.currentCount) % 60), 2, '0', true);
			if((this.gameIncrement - this.gameTimer.currentCount) <= 0) {
				Debug.debugMessage("Game Timer Expired. Reloading Scene");
				this.endGame();
			}
		}
		
		/** Removes the current scene from the Game Controllers. **/
		private function sceneCleanup() {
			Debug.debugMessage("Cleaning up scene");
			try {
				while(this.stageMain.numChildren > 0) {this.stageMain.removeChildAt(0);}
				while(this.stageBackground.numChildren > 0) {this.stageBackground.removeChildAt(0);}
				while(this.stageAnimals.numChildren > 0) {this.stageAnimals.removeChildAt(0);}
				while(this.stageForeground.numChildren > 0) {this.stageForeground.removeChildAt(0);}
				this.scenery = null;
				this.wild = null;
				this.party = null;
			} catch(e:Error) {
				Debug.debugMessage(e.toString());
			}
		}
		
		/** Resets this instance of the Game Controller, removing all instances
		 ** of the KinectInput and Player classes, as well as removing all event
		 ** listeners and clearing the stage. **/
		public function gameCleanup() {
			Debug.debugMessage("Cleaning up game controller");
			
			/* Cleanup Classes */
			try {
				this.kinectInput.kinectInputCleanup();
				this.player.playerCleanup();
			} catch(e:Error) {
				Debug.debugMessage(e.toString());
			}
			
			/* Clear Stage */
			try {
				this.sceneCleanup();
				while(this.stagePlayer.numChildren > 0) {this.stagePlayer.removeChildAt(0);}
				while(this.stageOverlay.numChildren > 0) {this.stageOverlay.removeChildAt(0);}
				this.document.removeChild(this.stageOverlay);
				this.document.removeChild(this.stageBackground);
				this.document.removeChild(this.stagePlayer);
				this.document.removeChild(this.stageForeground);
				this.document.removeChild(this.stageMain);
			} catch(e:Error) {
				Debug.debugMessage(e.toString());
			}
			
			/* Cleanup Variables */
			try {
				this.kinectInput = null;
				this.rfidReader = null;
				this.score = 0;
				this.player = null;
				this.scoreTextField = null;
				this.textFormat = null;
			} catch(e:Error) {
				Debug.debugMessage(e.toString());
			}
		}
		
		/** Returns whether or not the game is currently paused. **/
		public function isGamePaused():Boolean {
			return this.paused;
		}
		
		/** Pauses the current game. **/
		public function pauseGame(message:String = "") {
			if(this.isGamePaused() == false) {
				this.paused = true;
				this.gamePausedBackground.visible = true;
				this.gamePausedBackground.messageBox.text = message;
				this.gameTimer.stop();
				Debug.debugMessage("Game paused");
			}
		}
		
		/** Resumes the current game. **/
		public function resumeGame() {
			if(this.paused == true) {
				this.paused = false;
				this.gamePausedBackground.visible = false;
				this.gamePausedBackground.messageBox.text = "";
				this.gameTimer.start();
				Debug.debugMessage("Game resumed");
			}
		}
		
		/** Ends the current game. **/
		public function endGame() {
			trace("================================================================================");
			this.gameCleanup();
			this.startGame();
			this.pauseGame("Enter the playing area to begin the game.");
			Debug.debugMessage("Restarting game");
		}
	}
}