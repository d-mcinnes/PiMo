package  {
	import flash.display.Stage;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.Font;

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
		public static var GROUND_HEIGHT:Number = 350;

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
			this.player.renderPlayer();
			for each (var animal in party) {
				animal.x = GameController.SCREEN_SIZE_X * this.kinectInput.getKinectSkeleton().getPositionRelative().x - 30;
			}
		}
		
		/** Loads a scene. **/
		private function loadScene():void {
			//TODO reset scene elements
			//TODO set background
			loadScenery();
		}
		
		/** Loads the scenery for the current scene. **/
		private function loadScenery():void {
			this.scenery = new Array();
			scenery.push(new Grass());
			
			for each (var object in scenery) {
				object.x = (Math.floor(Math.random() * (950 - 70 + 1)) + 70);
				object.y = GameController.GROUND_HEIGHT;
				object.setIsActive(true);
				this.stageMain.addChild(object);
			}
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
						var animal:Animal = new Rabbit();
						var timer:Timer = new Timer(10000);
						spawnAnimal(animal, object.x, GameController.GROUND_HEIGHT);
						object.setIsActive(false);
						timer.addEventListener(TimerEvent.TIMER, despawnTimer(animal, object));
						timer.start();
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
			this.stageMain.addChild(animal);
		}
		
		/** Despawns an animal from the screen. **/
		private function despawnAnimal(animal:Animal):void {
			try {
				this.stageMain.removeChild(animal);
			} catch(e:Error) {
				trace("Error Removing Animal: Does not Exist.");
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
			this.score += 10;
			this.scoreTextField.text = "Score: " + this.score;
			for each (var object in wild) {
				if(object == animal) {
					wild.splice(wild.indexOf(animal), 1);
				}
			}
			score += animal.getScore();
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
		
		/** Resets this instance of the Game Controller, removing all instances
		 ** of the KinectInput and Player classes, as well as removing all event
		 ** listeners and clearing the stage. **/
		public function gameCleanup() {
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
	}
}