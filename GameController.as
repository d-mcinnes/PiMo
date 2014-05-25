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
	import deco3850.scenery.*;

	public class GameController {
		private var document:Stage;
		private var stageOverlay:Sprite;
		private var stageMain:Sprite;
		private var stageBackground:Sprite;
		private var stageAnimals:Sprite;
		private var stagePlayer:Sprite;
		private var stageForeground:Sprite;
		private var kinectInput:KinectInput;
		private var rfidReader:RFIDReaderSingle;
		
		private var score:int; //cumulative score for this game, nonnegative
		
		private var gameTimer:Timer;
		private var gameIncrement:Number = 2 * 60;
		
		private var scenery:Array; //interactable objects in the background
		private var sceneryPosition:Array;
		private var wild:Array; //animals in the scene, not following the player
		private var party:Array; //animals currently following the player
		private var player:Player;
		private var scoreTextField:TextField;
		private var textFormat:TextFormat;
		private var timerTextField:TextField;
		
		public static var SCREEN_SIZE_X:Number = 1024;
		public static var SCREEN_SIZE_Y:Number = 600;
		public static var GROUND_HEIGHT:Number = 440;
		public static var DEBUG_MODE_ON:Boolean = true;
		public static var DEBUG_DISPLAY_MODE_ON:Boolean = false;
		
		private static var gameController:GameController = null;

		/**
		 * Controls the proceedings for one round of the game.
		 */
		public function GameController(document:Stage) {
			this.document = document;
			this.kinectInput = new KinectInput(this);
			this.rfidReader = new RFIDReaderSingle(this);
			
			Debug.debugMessage("Game Controller Started");
		}
		
		public static function createInstance(document:Stage):GameController {
			gameController = new GameController(document);
			return gameController;
		}
		
		public static function getInstance():GameController {
			if(gameController == null) {
				Debug.debugMessage("No Game Controller");
				return null;
			}
			return gameController;
		}
		
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
			
			loadScene();
			
			this.player = new Player(this);
			this.player.x = 50;
			this.player.y = 400;
			this.stagePlayer.addChild(this.player);
			
			this.scoreTextField = new TextField();
			this.scoreTextField.y = 10;
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
			this.timerTextField.y = 40;
			this.timerTextField.width = 185;
			this.timerTextField.textColor = 0x000000;
			this.timerTextField.selectable = false;
			this.timerTextField.defaultTextFormat = this.textFormat;
			this.timerTextField.text = "Time: ";
			this.stageOverlay.addChild(this.timerTextField);
			
			var overlay:BlackOverlay = new BlackOverlay();
			overlay.x = -300;
			overlay.y = -110;
			this.stageOverlay.addChild(overlay);
			
			this.document.addEventListener(KeyboardEvent.KEY_DOWN, keySpacePress);
			
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
		
		public function getStage():Stage {return this.document;}
		public function getStageMain():Sprite {return this.stageMain;}
		public function getStageOverlay():Sprite {return this.stageOverlay;}
		public function getKinectSkeleton():KinectSkeleton {return this.kinectInput.getKinectSkeleton();}
		public function getScenery():Array {return this.scenery;}
		public function getParty():Array {return this.party;}
		public function getWildAnimals():Array {return this.wild;}
		
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
			loadScenery();
		}
		
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
						object.sceneryInteraction();
						//var type:Class = object.getAnimalSpawnType();
						//var animal:Animal = new type();
						//spawnAnimal(animal, object.x, GameController.GROUND_HEIGHT);
						object.setIsActive(false);
						//Debug.debugMessage("Spawning " + animal.getName() + " at [" + object.x  + ", " + object.y + "]");*/
					}
				}
			}
		}
		
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
			this.score += animal.getScore();
			this.scoreTextField.text = "Score: " + this.score;
			for each (var object in wild) {
				if(object == animal) {
					wild.splice(wild.indexOf(animal), 1);
				}
			}
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
			if(e.keyCode == Keyboard.SPACE) {
				this.activateTag('010232cd72');
			}
		}
		
		/** Runs when _____ **/
		private function gameTimerEvent(e:TimerEvent) {
			this.timerTextField.text = "Time: " + Debug.padChar(String(Math.floor(((this.gameIncrement - this.gameTimer.currentCount) / 60) % 60)), 2, '0', true) + 
				":" + Debug.padChar(String((this.gameIncrement - this.gameTimer.currentCount) % 60), 2, '0', true);
			if((this.gameIncrement - this.gameTimer.currentCount) <= 0) {
				Debug.debugMessage("Game Timer Expired. Reloading Scene");
			}
		}
		
		/** Removes the current scene from the Game Controllers. **/
		private function sceneCleanup() {
			Debug.debugMessage("Cleaning up scene");
			while(this.stageMain.numChildren > 0) {this.stageMain.removeChildAt(0);}
			while(this.stageBackground.numChildren > 0) {this.stageBackground.removeChildAt(0);}
			while(this.stageAnimals.numChildren > 0) {this.stageAnimals.removeChildAt(0);}
			while(this.stageForeground.numChildren > 0) {this.stageForeground.removeChildAt(0);}
			this.scenery = null;
			this.wild = null;
			this.party = null;
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
		
		/** Ends the current game. **/
		private function endGame():void {
			
		}
	}
}