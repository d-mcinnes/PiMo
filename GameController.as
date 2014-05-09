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
			this.wild = new Array();
			this.party = new Array();
			
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
			this.scoreTextField.text = "Score: 0";
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
		
		public function renderPlayer() {
			this.player.renderPlayer();
			for each (var animal in party) {
				animal.x = GameController.SCREEN_SIZE_X * this.kinectInput.getKinectSkeleton().getPositionRelative().x - 30;
			}
		}
		
		private function loadScene():void {
			//TODO reset scene elements
			//TODO set background
			loadScenery();
		}
		
		private function loadScenery():void {
			this.scenery = new Array();
			
			/*var rand:int;
			//for (var i:int = 0; i < 3; ++i) {
				//rand = 1 + Math.ceil(Math.random() + 3);
				rand = 2; //TODO only using long grass for prototype
				switch (rand) {
					case 1:
					scenery.push(SceneryTree);
					break;
					
					case 2:
					scenery.push(new Grass());
					break;
					
					case 3:
					scenery.push(SceneryBurrow);
					break;
					
					case 4:
					scenery.push(SceneryFarm);
					break;
				}
			//}*/
			
			scenery.push(new Grass());
			
			for each (var object in scenery) {
				object.x = (Math.floor(Math.random() * (950 - 70 + 1)) + 70);
				object.y = GameController.GROUND_HEIGHT;
				object.setIsActive(true);
				this.stageMain.addChild(object);
				//TODO add image to scene
				//update position data in class
			}
		}
		
		//private function isSceneComplete():Boolean {
			
		public function checkObjectBounds(position:Point, object:Object):Boolean {
			
			/*trace("PAUL: " + (position.x * GameController.SCREEN_SIZE_X) + ", " + (object.x - 50));
			trace("PAUL: " + (position.x * GameController.SCREEN_SIZE_X) + ", " + (object.x + 50));
			trace("PAUL: " + (position.y * GameController.SCREEN_SIZE_Y) + ", " + (object.y - 50));
			trace("PAUL: " + (position.y * GameController.SCREEN_SIZE_Y) + ", " + (object.y + 50));
			*/
			if (position.x * GameController.SCREEN_SIZE_X > object.x - 50
					&& position.x * GameController.SCREEN_SIZE_X < object.x + object.width + 50
					&& position.y * GameController.SCREEN_SIZE_Y > object.y - 50
					&& position.y * GameController.SCREEN_SIZE_Y < object.y + object.height + 50) {
				return true;
			} else {
				return false;
			}
		}
		
		public function checkForSceneryInteraction(leftPosition:Point, rightPosition:Point):void {
			for each (var object in scenery) {
				//trace("Object: " + "(" + object.x + ", " + object.y + ")" + " Hand: " + object.localToGlobal(leftPosition));
				//var point:Point = localToGlobal(new Point(object.x, object.y));
				if(object.isActive()) {
					//trace("X: " + leftPosition.x + " Y: " + leftPosition.y);
					//trace(Math.abs(object.x - (leftPosition.x * GameController.SCREEN_SIZE_X)));
					trace(" L:" + this.player.getLeftPoint() + "  R:" + this.player.getRightPoint());
					trace("LG:" + this.document.localToGlobal(this.player.getLeftPoint()) + " RG:" + this.document.localToGlobal(this.player.getRightPoint()));
					/*
					if((Math.abs(object.x - (leftPosition.x * GameController.SCREEN_SIZE_X)) < 100) && 
					   (Math.abs(object.y - (leftPosition.y * GameController.SCREEN_SIZE_Y)) < 100)) {
						   */
					if (checkObjectBounds(leftPosition, object)) {
						trace("HIT LEFT");
						spawnAnimal(new Rabbit(), object.x, GameController.GROUND_HEIGHT);
						object.setIsActive(false);
						
						var timer:Timer = new Timer(10000);
						timer.addEventListener(TimerEvent.TIMER, timerListener);
						timer.start();
					} else {
						//trace("Object: (" + object.x + ", " + object.y + ") Player: (" + 
						//	  leftPosition.x * GameController.SCREEN_SIZE_X + ")");
							  //trace(object.parent);
					}
				}
				
				/*if((Math.abs(object.x - (rightPosition.x * 1024)) <= 100) &&
				   (Math.abs(object.y - (rightPosition.y * 1024)) <= 100)) {
					   trace("HIT RIGHT");
				   } else {
					   
				   }*/
				
				/*if((object.x > this.player.getPlayerAvatar().x && object.x < (this.player.getPlayerAvatar().x + 
																			  this.player.getPlayerAvatar().width)) && 
				   (object.y > this.player.getPlayerAvatar().y && object.y < (this.player.getPlayerAvatar().y + 
																			  this.player.getPlayerAvatar().height))) {
					trace("HIT");
				} else {
					trace("Object: (" + object.x + ", " + object.y + ") Player: (" + 
						  this.player.getPlayerAvatar().x + ", " + this.player.getPlayerAvatar().y + ")");
					//trace("MISS");
				}*/
			}
			//if(this.player.getPlayerAvatar().x) {
			//if(this.document.grass_mc.hitTestObject(this.player.player)) {
				//trace("HIT");
			//} else {
			//	trace("MISS");
			//}
			//get skeleton from kinect
			//get positions for skeleton
			//for each object in scenery
			//get position
			//get size
			//calculate bounds
			//check for overlap
			//if overlap, spawnAnimal(object.getAnimal)
		}
		
		private function timerListener(e:TimerEvent):void {
			for each (var object in scenery) {
				if(!object.isActive()) {
					object.setIsActive(true);
				}
			}
			for each (var animal in wild) {
				despawnAnimal(animal);
			}
		}
		
		private function spawnAnimal(animal:Animal, x:Number, y:Number):void {
			wild.push(animal);
			animal.x = x;
			animal.y = y;
			this.stageMain.addChild(animal);
		}
		
		private function despawnAnimal(animal:Animal):void {
			this.stageMain.removeChild(animal);
			for each (var object in wild) {
				if(object == animal) {
					wild.splice(wild.indexOf(object), 1);
				}
			}
		}
		
		private function attachAnimal(animal:Animal):void {
			//clear timer for despawnAnimal
			//TODO check for animal interactions
			trace("Attach Animal");
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
		
		public function activateTag(tag:String) {
			for each (var animal in wild) {
				//if(Class(getDefinitionByName(getQualifiedClassName(animal))) == 'Rabbit') {
				if(animal.checkTag(tag)) {
					attachAnimal(animal);
				}
				//}
			}
		}
		
		public function deactivateTag(tag:String) {
			
		}
		
		private function endGame():void {
			
		}
		
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
	}
}