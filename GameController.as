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
		private var stagePlayer:Sprite;
		private var kinectInput:KinectInput;
		private var rfidReader:RFIDReaderSingle;
		
		private var score:int; //cumulative score for this game, nonnegative
		
		private var gameDuration = 3*60*1000; //milliseconds
		
		private var scenery:Array; //interactable objects in the background
		private var wild:Array; //animals in the scene, not following the player
		private var party:Array; //animals currently following the player
		private var player:Player;
		private var scoreTextField:TextField;
		private var textFormat:TextFormat;
		
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
			this.stageMain = new Sprite();
			this.document.addChild(this.stageMain);
			this.stagePlayer = new Sprite();
			this.document.addChild(this.stagePlayer);
			this.stageOverlay = new Sprite();
			this.document.addChild(this.stageOverlay);
			
			this.kinectInput = new KinectInput(this);
			this.rfidReader = new RFIDReaderSingle(this);
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
			this.scoreTextField.x = 825;
			this.scoreTextField.width = 185;
			this.scoreTextField.textColor = 0x000000;
			this.scoreTextField.selectable = false;
			
			this.textFormat = new TextFormat();
			this.textFormat.size = 25;
			this.textFormat.align = TextFormatAlign.RIGHT;
			this.textFormat.bold = true;
			this.textFormat.font = new ScoreFont().fontName;
			
			this.scoreTextField.defaultTextFormat = this.textFormat;
			this.scoreTextField.text = "Score: " + this.score;
			this.document.addChild(this.scoreTextField);
			
			this.document.addEventListener(KeyboardEvent.KEY_DOWN, keySpacePress);
			
			Debug.debugMessage("Game Controller Started");
			
			//while loop for playing game
			/*var startTime:uint = getTimer();
			while(getTimer() - startTime < this.gameDuration) {
				checkForSceneryInteraction();
			}
			
			endGame();*/
		}
		
		public function getStageMain():Sprite {return this.stageMain;}
		public function getStageOverlay():Sprite {return this.stageOverlay;}
		public function getKinectSkeleton():KinectSkeleton {return this.kinectInput.getKinectSkeleton();}
		
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
		private function loadScene():void {
			//TODO reset scene elements
			//TODO set background
			loadScenery();
		}
		
		/** Takes a position and creates the scenery object. **/
		private function createSceneryObject(type:Class, x:Number, y:Number):Scenery {
			var object:Scenery = new type();
			return object;
		}
		
		/** Loads the scenery for the current scene. **/
		private function loadScenery_Obsolete():void {
			this.scenery = new Array();
			
			/* Create Farm */
			this.scenery.push(new Farm((Math.floor(Math.random() * (GameController.SCREEN_SIZE_X - 100 + 1)) + 100), 
									   GameController.GROUND_HEIGHT));
			
			/* Create Tree(s) */
			for(var i:int = 0; i < (Math.floor(Math.random() * 2) + 1); i++) {
				this.scenery.push(new Tree((Math.floor(Math.random() * (GameController.SCREEN_SIZE_X - 150 + 1)) + 150), 
									   GameController.GROUND_HEIGHT));
			}
			
			/* Create Grass */
			for(var n:int = 0; n < (Math.floor(Math.random() * 4) + 1); n++) {
				this.scenery.push(new Grass((Math.floor(Math.random() * (GameController.SCREEN_SIZE_X - 150 + 1)) + 150), 
											GameController.GROUND_HEIGHT));
			}
			//scenery.push(new Grass());
			
			for each (var object in scenery) {
				//object.x = (Math.floor(Math.random() * (950 - 70 + 1)) + 70);
				//object.y = GameController.GROUND_HEIGHT;
				//object.setIsActive(true);
				this.stageMain.addChild(object);
			}
		}
		
		/** Takes a x position and checks whether or not it collides with any other
		 ** objects. **/
		private function sceneryCheckPosition(x:Number):Boolean {
			for each(var object in this.scenery) {
				if(x > object.x && x < object.x + object.width) {
					return false;
				}
			}
			return true;
		}
		
		/** Loads the scenery for the current scene. **/
		private function loadScenery():void {
			this.scenery = new Array();
			
			/* Create Farm */
			this.scenery.push(new Farm((Math.floor(Math.random() * (GameController.SCREEN_SIZE_X - 550 + 1)) + 100), 
									   GameController.GROUND_HEIGHT));
			
			/* Create Tree(s) */
			for(var i:int = 0; i < (Math.floor(Math.random() * 2) + 1); i++) {
				var x:Number = (Math.floor(Math.random() * (GameController.SCREEN_SIZE_X - 150 + 1)) + 150);
				this.scenery.push(new Tree(x, GameController.GROUND_HEIGHT, 
										   (Math.random() * 0.5 + 0.750)));
			}
			
			/* Create Grass */
			for(var n:int = 0; n < (Math.floor(Math.random() * 4) + 1); n++) {
				this.scenery.push(new Grass((Math.floor(Math.random() * (GameController.SCREEN_SIZE_X - 150 + 1)) + 150), 
											GameController.GROUND_HEIGHT));
			}
			
			for each (var object in scenery) {this.stageMain.addChild(object);}
		}
		
		//private function isSceneComplete():Boolean {
		
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
		
		/** Checks for any scenery interaction from the player. Runs every time
		 ** the Kinect is updated. **/
		public function checkForSceneryInteraction(leftPosition:Point, rightPosition:Point):void {
			for each (var object in scenery) {
				if(object.isActive()) {
					if(this.player.getLeftPoint() == null || this.player.getRightPoint() == null) {
						return;
					}
					if(checkObjectBounds(object)) {
						object.sceneryInteraction();
						var type:Class = object.getAnimalSpawnType();
						var animal:Animal = new type();
						spawnAnimal(animal, object.x, GameController.GROUND_HEIGHT);
						object.setIsActive(false);
						Debug.debugMessage("Spawning " + animal.getName() + " at [" + object.x  + ", " + object.y + "]");
						//timer.addEventListener(TimerEvent.TIMER, despawnTimer(animal, object));
						//timer.start();
						/*
						//var animal:Animal = new Rabbit();
						var animal:Animal = new Owl();
						//var timer:Timer = new Timer(10000);
						spawnAnimal(animal, object.x, GameController.GROUND_HEIGHT);
						object.setIsActive(false);
						Debug.debugMessage("Spawning " + animal.getName() + " at [" + object.x  + ", " + object.y + "]");
						//timer.addEventListener(TimerEvent.TIMER, despawnTimer(animal, object));
						//timer.start();*/
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
		
		/** Runs when the despawn animal timer expires. **/
		/*private function timerListener(e:TimerEvent, num:Number):void {
			trace("Num: " + num);
			for each (var object in scenery) {
				if(!object.isActive()) {
					object.setIsActive(true);
				}
			}
			for each (var animal in wild) {
				despawnAnimal(animal);
			}
		}*/
		
		/** Spawns an animal at the given point. Takes an animal, and an x and
		 ** y coordinates. **/
		private function spawnAnimal(animal:Animal, x:Number, y:Number):void {
			wild.push(animal);
			animal.x = x;
			animal.y = y;
			animal.setTimerEvent(animalDespawnTimerEvent);
			animal.startTimer();
			this.stageMain.addChild(animal);
		}
		
		private function animalDespawnTimerEvent(e:TimerEvent) {
			Debug.debugMessage("Animal Despawn Timer Event");
		}
		
		/** Despawns an animal from the screen. **/
		private function despawnAnimal(animal:Animal):void {
			try {
				this.stageMain.removeChild(animal);
			} catch(e:Error) {
				Debug.debugMessage("Error removing animal: does not exist");
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
		private function removeAnimal(animal:Animal):Boolean {
			var index = party.indexOf(animal);
			if (index >= 0) {
				party.splice(index, 1);
				score -= animal.getScore();
				return true;
			} else {
				return false;
			}
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
		
		/** Resets this instance of the Game Controller, removing all instances
		 ** of the KinectInput and Player classes, as well as removing all event
		 ** listeners and clearing the stage. **/
		public function gameCleanup() {
			Debug.debugMessage("Cleaning up game controller");
			
			/* Cleanup Classes */
			this.kinectInput.kinectInputCleanup();
			this.player.playerCleanup();
			
			/* Clear Stage */
			while(this.stageOverlay.numChildren > 0) {
				this.stageOverlay.removeChildAt(0);
			}
			while(this.stagePlayer.numChildren > 0) {
				this.stagePlayer.removeChildAt(0);
			}
			while(this.stageMain.numChildren > 0) {
				this.stageMain.removeChildAt(0);
			}
			this.document.removeChild(this.stageOverlay);
			this.document.removeChild(this.stagePlayer);
			this.document.removeChild(this.stageMain);
			
			/* Cleanup Variables */
			this.kinectInput = null;
			this.rfidReader = null;
			this.score = 0;
			this.gameDuration = null;
			this.scenery = null;
			this.wild = null;
			this.party = null;
			this.player = null;
			this.scoreTextField = null;
			this.textFormat = null;
		}
		
		/** Ends the current game. **/
		private function endGame():void {
			
		}
		
		/*private function millisecondsToTimecode(milliseconds:int):String {
			var seconds:int = Math.floor((milliseconds/1000) % 60);
			var strSeconds:String = (seconds < 10) ? ("0" + String(seconds)):String(seconds);
			var minutes:int = Math.round(Math.floor((milliseconds/1000)/60));
			var strMinutes:String = (minutes < 10) ? ("0" + String(minutes)):String(minutes);
			var strMilliseconds:String = milliseconds.toString();
			strMilliseconds = strMilliseconds.slice(strMilliseconds.length -3, strMilliseconds.length)
			var timeCode:String = strMinutes + ":" + strSeconds + ':' + strMilliseconds;
			return timeCode;
		}*/
		
		/** Takes a string and prints a debug message. **/
		/*public static function debugMessage2(text:String):void {
			if(GameController.DEBUG_MODE_ON == true) {
				var location:String = new Error().getStackTrace().match( /(?<=\/|\\)\w+?.as:\d+?(?=])/g )[1].replace( ":" , ", line " );
				var x:int = getTimer() / 1000;
				var seconds:int = x % 60;
				x /= 60;
				var minutes:int = x % 60;
				x /= 60;
				var hours:int = x % 24;
				
				trace("[" + PadZero.convert(hours) + ":" + PadZero.convert(minutes) + ":" + PadZero.convert(seconds) + "]" + "[" + location + "] " + text);
			}
		}*/
	}
}