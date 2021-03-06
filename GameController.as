﻿package  {
	import flash.debug.Debug;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.printing.PrintJob;
	import flash.printing.PrintJobOptions;
	import flash.printing.PrintJobOrientation;
	import flash.printing.PaperSize;
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
	import deco3850.food.*;
	
	import com.greensock.TweenLite;
	import com.greensock.events.TweenEvent;
	import com.greensock.easing.Bounce;
	import com.adobe.images.JPGEncoder;
	//import flash.utils.ByteArray;
		
	public class GameController {
		private static var gameController:GameController = null;
		
		/* General Variables */
		private var document:Stage;
		private var kinectInput:KinectInput;
		private var rfidReader:RFIDReaderSingle;
		private var socket:SocketController;
		private var gameInterface:GameInterface;
		
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
		private var gameIncrement:Number = 1.5 * 60;
		private var objectivesLevel:Number = 0;
		
		/* Gameplay Objects */
		private var scenery:Array; //interactable objects in the background
		private var sceneryPosition:Array;
		private var wild:Array; //animals in the scene, not following the player
		private var party:Array; //animals currently following the player
		private var player:Player;
		private var paused:Boolean = false;
		private var foodItems:FoodItems;
		private var animalHistory:Array = [];
		
		/* Static Variables */
		public static var SCREEN_SIZE_X:Number = 1024;
		public static var SCREEN_SIZE_Y:Number = 600;
		public static var GROUND_HEIGHT:Number = 440;
		public static var MAX_ANIMALS:Number = 6;
		public static var DEBUG_MODE_ON:Boolean = true;
		public static var DEBUG_DISPLAY_MODE_ON:Boolean = false;

		/**
		 * Controls the proceedings for one round of the game.
		 */
		public function GameController(document:Stage) {
			this.document = document;
			this.kinectInput = new KinectInput();
			this.rfidReader = new RFIDReaderSingle(this);
			this.socket = new SocketController();
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
			
			this.gameInterface = new GameInterface();
			
			this.score = 0;
			this.objectivesLevel = 0;
			this.party = new Array();
			this.wild = new Array();
			this.foodItems = new FoodItems();
			
			this.player = new Player();
			this.player.x = 50;
			this.player.y = 400;
			this.stagePlayer.addChild(this.player);
			
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
			this.gameInterface.setTimerText(this.gameIncrement, this.gameTimer.currentCount);
			
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
		public function getSocket():SocketController {return this.socket;}
		public function getPlayerX():Number {return this.player.getPlayerX();}
		public function getFoodItems():FoodItems {return this.foodItems;}
		public function getAnimalHistory():Array {return this.animalHistory;}
		
		public function displayGameMessage(text:String) {this.gameInterface.displayGameMessage(text);}
		public function renderFoodIcons() {this.gameInterface.renderFoodIcons();}
		
		public function getScore():Number {return this.score;}
		public function incrementScore(increment:Number) {
			this.score += increment;
			this.gameInterface.setScoreText(this.score);
			this.gameInterface.displayScoreUpdate(increment);
		}
		
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
				var x:Number = GameController.SCREEN_SIZE_X * this.kinectInput.getKinectSkeleton().getPositionRelative().x - 200 - (index * 30);
				if(x < 80) {
					x = 80;
				}
				animal.x = x;
				index++;
			}
		}
		
		/** Loads a scene. **/
		public function loadScene():void {
			this.sceneCleanup();
			this.wild = new Array();
			this.party = new Array();
			this.loadScenery();
			//this.generateObjective();
		}
		
		public function saveScreenshot() {
			/*var jpgEncoder:JPGEncoder = new JPGEncoder(90);
			var bitmapData:BitmapData = new BitmapData(1024, 600);
			var img:ByteArray;
			
			bitmapData.draw(this.document);
			img = jpgEncoder.encode(bitmapData);
			
			var sendHeader:URLRequestHeader = new URLRequestHeader("Content-type","application/octet-stream");
			var sendReq:URLRequest = new URLRequest("pimo.uqcloud.net/savepicture.php");
			
			sendReq.requestHeaders.push(sendHeader);
			sendReq.method = URLRequestMethod.POST;
			sendReq.data = img;
			
			var sendLoader:URLLoader;
			sendLoader = new URLLoader();
			//sendLoader.addEventListener(Event.COMPLETE, imageSentHandler);
			sendLoader.load(sendReq);*/
			
			//var file:FileReference = new FileReference();
			//file.save(img, "filename.jpg");
		}
		
		public function printScreenshot() {
			//this.gameInterface.generateFinalScreen();
			var printJob:PrintJob = new PrintJob();
			var printOptions:PrintJobOptions = new PrintJobOptions();
			printOptions.printAsBitmap = true;
			printJob.orientation = PrintJobOrientation.LANDSCAPE;
			printJob.selectPaperSize(PaperSize.A6);
			//printJob.start();
			printJob.start2(null, false);
			try {
				printJob.addPage(this.gameInterface.generateFinalScreen(), null, printOptions);
			} catch(e:Error) {
				trace ("Had problem adding the page to print job: " + e);
			}
			try {
				printJob.send();
			} catch(e:Error) {
				trace ("Had problem printing: " + e); 
			}
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
			
			var fence:Fence = new Fence(300, GameController.GROUND_HEIGHT + 45);
			fence.setIsActive(true);
			this.scenery.push(fence);
			this.stageBackground.addChild(fence);
			
			var farm:Farm = new Farm(420, GameController.GROUND_HEIGHT + 50);
			farm.setIsActive(true);
			this.scenery.push(farm);
			this.stageBackground.addChild(farm);
			
			var burrow:Burrow = new Burrow(30, GameController.GROUND_HEIGHT + 80);
			burrow.setIsActive(true);
			this.scenery.push(burrow);
			this.stageBackground.addChild(burrow);
			
			var burrow2:Burrow = new Burrow(780, GameController.GROUND_HEIGHT + 110, 1);
			burrow2.setIsActive(true);
			this.scenery.push(burrow2);
			this.stageBackground.addChild(burrow2);
			
			/* Create Tree(s) */
			var tree:Tree = new Tree(70, GameController.GROUND_HEIGHT, 1.2);
			tree.setIsActive(true);
			this.scenery.push(tree);
			this.stageBackground.addChild(tree);
			
			//var tree2:Tree = new Tree(860, GameController.GROUND_HEIGHT + 40, 1);
			//tree2.setIsActive(true);
			//this.scenery.push(tree2);
			//this.stageBackground.addChild(tree2);
			
			/* Create Grass */
			var grass:Grass = new Grass(170, GameController.GROUND_HEIGHT + 100, 1.1);
			grass.setIsActive(true);
			this.scenery.push(grass);
			this.stageForeground.addChild(grass);
			
			var grass2:Grass = new Grass(660, GameController.GROUND_HEIGHT + 80, 0.9);
			grass2.setIsActive(true);
			this.scenery.push(grass2);
			this.stageForeground.addChild(grass2);
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
					if(checkObjectBounds(object)) {
						object.sceneryInteraction();
						object.setIsActive(false);
						this.checkCurrentObjective();
					}
				}
			}
		}
		
		/** *********************** **/
		/**   B A C K G R O U N D   **/
		/** *********************** **/
		
		private function generateBackground() {
			// TODO: Generate Random Background
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
		public function spawnAnimal(animal:Animal, x:Number, y:Number):void {
			this.wild.push(animal);
			animal.x = x;
			animal.y = y;
			animal.setTimerEvent(animalDespawnTimerEvent(animal));
			animal.playIdleAnimation();
			animal.startTimer();
			TweenLite.to(animal, 0, {y:(animal.y - 30), alpha:0});
			this.stageAnimals.addChild(animal);
			TweenLite.to(animal, 0.5, {y:(animal.y + 30), alpha:1, ease:Bounce.easeOut});
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
			var animalRemoveFunction:Function = function():void {
				try {
					stageAnimals.removeChild(animal);
				} catch(e:Error) {
					Debug.debugMessage(e.toString());
				}
			}
			for each (var object in wild) {
				if(object == animal) {
					wild.splice(wild.indexOf(object), 1);
				}
			}
			TweenLite.to(animal, 1, {alpha:0, onComplete:animalRemoveFunction});
		}
		
		/** Adds an animal to the players party. **/
		public function attachAnimal(animal:Animal):void {
			var sound:Glockenspiel = new Glockenspiel();
			party.push(animal);
			this.animalHistory.push(animal.getType());
			animal.playWalkAnimation();
			animal.interactionAttachGlobal();
			animal.interactionAttach();
			sound.play();
			this.incrementScore(animal.getScore());
			for each (var object in wild) {
				if(object == animal) {
					wild.splice(wild.indexOf(animal), 1);
				}
			}
			this.checkCurrentObjective();
			Debug.debugMessage("Attaching " + animal.getName());
		}
		
		/** Removes an animal from the players party. **/
		public function removeAnimal(animal:Animal):Boolean {
			var index = party.indexOf(animal);
			var animalRemoveFunction:Function = function():void {
				try {
					stageAnimals.removeChild(animal);
				} catch(e:Error) {
					Debug.debugMessage(e.toString());
				}
			}
			if (index >= 0) {
				party.splice(index, 1);
				TweenLite.to(animal, 1, {alpha:0, onComplete:animalRemoveFunction});
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
		
		/** Takes an animal type and checks to see whether or not that
		 ** animal has already spawned in the wild. **/
		public function getIsAnimalInWild(animal:Class):Boolean {
			for each(var object in this.getWildAnimals()) {
				if(object.getType() == animal) {
					return true;
				}
			}
			return false;
		}
		
		/** Takes an animal type and checks to see whether or not that
		 ** animal is already in the players party. **/
		public function getIsAnimalInParty(animal:Class):Boolean {
			for each(var object in this.getParty()) {
				if(object.getType() == animal) {
					return true;
				}
			}
			return false;
		}
		
		/** Takes an animal type and returns the number of animals of that type in the
		 ** party. **/
		public function getNumberAnimalInParty(animal:Class):Number {
			var count:Number = 0;
			for each(var object in this.party) {
				if(object.getType() == animal) {
					count++;
				}
			}
			return count;
		}
		
		/** Returns the number of animals which are currently in the players party. **/
		public function getNumberOfAnimalsInParty():Number {return this.getParty().length;}
		
		/** Makes all animals in the players party face left. **/
		public function setPartyFacingLeft() {
			for each(var obj in this.getParty()) {
				obj.setFacingAngleLeft();
			}
		}
		
		/** Makes all animals in the players party face right. **/
		public function setPartyFacingRight() {
			for each(var obj in this.getParty()) {
				obj.setFacingAngleRight();
			}
		}
		
		public function setPartyMoveAnimation() {
			for each(var obj in this.getParty()) {
				obj.playWalkAnimation();
			}
		}
		
		public function setPartyIdleAnimation() {
			for each(var obj in this.getParty()) {
				obj.playIdleAnimation();
			}
		}
		
		/** Runs when the player activates one of the Arduino tags. **/
		public function activateTag(tag:String) {
			var food:Food = null;
			for each(var f in this.getFoodItems().getFoodItems()) {
				if(f.getIsTag(tag) == true) {
					Debug.debugMessage("Tag Activated: " + f.getName());
					food = f;
					if(food.getActive() == true) {
						this.renderFoodIcons();
						break;
					}
					if(this.getFoodItems().getNumberActiveItems() >= 4) {
						this.getFoodItems().removeFoodItem();
					}
					food.setActive(true);
					this.renderFoodIcons();
					break;
				}
			}
			for each(var animal in wild) {
				try {
					if(food.checkAnimal(animal.getType()) == true) {
						this.attachAnimal(animal);
					}
				} catch(e:Error) {
					Debug.debugMessage("Error: " + e.toString());
				}
			}
		}
		
		/** Runs when the player activates one of the Arduino tags. **/
		public function activateTagOld(tag:String) {
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
			if(e.keyCode == Keyboard.NUMBER_1) {
				/* 1 - Bird Seed */
				this.activateTag('2B005BC78037');
			} else if(e.keyCode == Keyboard.NUMBER_2) {
				/* 2 - Bone */
				this.activateTag('2B005B763731');
			} else if(e.keyCode == Keyboard.NUMBER_3) {
				/* 3 - Carrot */
				this.activateTag('0103C80917D4');
			} else if(e.keyCode == Keyboard.NUMBER_4) {
				/* 4 - Cheese */
				this.activateTag('2B005BC67DCB');
			} else if(e.keyCode == Keyboard.NUMBER_5) {
				/* 5 - Fish */
				this.activateTag('2B005B8401F5');
			} else if(e.keyCode == Keyboard.NUMBER_6) {
				/* 6 - Grass */
				this.activateTag('2B005BDF71DE');
			} else if(e.keyCode == Keyboard.NUMBER_7) {
				/* 7 - Meat */
				this.activateTag('2B005BB79651');
			}
		}
		
		/** *********************** **/
		/**   O B J E C T I V E S   **/
		/** *********************** **/
		
		public function getCurrentObjective():Objective {return this.currentObjective;}
		
		public function generateObjective():Objective {
			Debug.debugMessage("Generating objective for level " + this.objectivesLevel);
			try {
				var number:Number = Debug.randomNumber(0, Assets.OBJECTIVES[this.objectivesLevel].length - 1);
				var reference:Class = getDefinitionByName(Assets.OBJECTIVES[this.objectivesLevel][number]) as Class;
				this.currentObjective = new reference();
				this.gameInterface.setObjectiveText(this.currentObjective);
				return this.currentObjective;
			} catch(e:Error) {
				Debug.debugMessage("Unable to get objectives.");
			}
			return null;
			
		}
		
		public function setObjectiveText() {this.gameInterface.setObjectiveText(this.currentObjective);}
		
		public function checkCurrentObjective() {
			if(this.currentObjective != null) {
				if(this.currentObjective.isComplete() == true) {
					this.completeCurrentObjective();
				}
				this.setObjectiveText();
			}
		}
		
		public function completeCurrentObjective() {
			if(this.currentObjective != null) {
				Debug.debugMessage("!Objective Complete!");
				this.incrementScore(this.currentObjective.getScore());
				this.objectivesLevel++;
				if(this.objectivesLevel >= 3) {
					Debug.debugMessage("| Complete Game? |");
				}
				this.loadNextScene();
			}
		}
		
		/** ***************************** **/
		/**   G A M E   D U R A T I O N   **/
		/** ***************************** **/
		
		/** Runs when _____ **/
		private function gameTimerEvent(e:TimerEvent) {
			this.gameInterface.setTimerText(this.gameIncrement, this.gameTimer.currentCount);
			if((this.gameIncrement - this.gameTimer.currentCount) <= 0) {
				Debug.debugMessage("Game Timer Expired. Reloading Scene");
				this.endGame();
			}
		}
		
		public function loadNextScene() {
			var timer:Timer = new Timer(1000);
			var startLoadingScene:Function = function(e:TimerEvent):void {
				timer.removeEventListener(TimerEvent.TIMER, startLoadingScene);
				timer = null;
				loadScene();
				gameInterface.hideTransitionBackground(1);
			}
			this.gameInterface.displayTransitionBackground(1);
			timer.addEventListener(TimerEvent.TIMER, startLoadingScene);
			timer.start();
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
				this.gameInterface = null;
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
				this.gameInterface.setPausedVisible(true);
				this.gameInterface.setPausedTitle("Game Paused");
				this.gameInterface.setPausedText(message);
				this.gameTimer.stop();
				Debug.debugMessage("Game paused");
			}
		}
		
		/** Resumes the current game. **/
		public function resumeGame() {
			if(this.paused == true) {
				this.paused = false;
				this.gameInterface.setPausedVisible(false);
				this.gameInterface.setPausedText("");
				this.gameTimer.start();
				Debug.debugMessage("Game resumed");
			}
		}
		
		/** Ends the current game. **/
		public function endGame() {
			var score:Number = this.getScore();
			trace("================================================================================");
			this.printScreenshot();
			this.gameCleanup();
			this.startGame();
			this.pauseGame("Enter the playing area to begin a new game.");
			this.gameInterface.setPausedTitle("Game Over - Score: " + score);
			Debug.debugMessage("Restarting game");
		}
	}
}