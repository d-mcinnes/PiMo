package  {
	import flash.display.Stage;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.geom.Point;

	public class GameController {
		private var document:Stage;
		
		private var kinectInput:KinectInput;
		private var rfidReader:RFIDReaderSingle;
		
		private var score:int; //cumulative score for this game, nonnegative
		
		private var gameDuration = 3*60*1000; //milliseconds
		
		private var scenery:Array; //interactable objects in the background
		private var wild:Array; //animals in the scene, not following the player
		private var party:Array; //animals currently following the player
		private var player:Player;
		
		public static var SCREEN_SIZE_X:Number = 1024;
		public static var SCREEN_SIZE_Y:Number = 600;
		public static var GROUND_HEIGHT:Number = 350;

		/**
		 * Controls the proceedings for one round of the game.
		 */
		public function GameController(document:Stage) {
			trace("HELLO");
			this.document = document;
			this.kinectInput = new KinectInput(this.document, this);
			this.rfidReader = new RFIDReaderSingle(this);
			this.score = 0;
			this.wild = new Array();
			this.party = new Array();
			
			loadScene();
			//loadScenery();
			
			this.player = new Player(this.kinectInput.getKinectSkeleton());
			this.player.x = 50;
			this.player.y = 400;
			this.document.addChild(this.player);
			
			//while loop for playing game
			/*var startTime:uint = getTimer();
			while(getTimer() - startTime < this.gameDuration) {
				checkForSceneryInteraction();
			}
			
			endGame();*/
		}
		
		public function renderPlayer() {
			this.player.renderPlayer();
			for each (var animal in party) {
				animal.x = GameController.SCREEN_SIZE_X * this.kinectInput.getKinectSkeleton().getPositionRelative().x - 30;
			}
			//var parent:Stage = this.document;
			//this.document.setChildIndex(this.player.getPlayerAvatar(), this.document.numChildren-1);
			//this.document.addChild(this.player.getPlayerAvatar());
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
				this.document.addChild(object);
				//TODO add image to scene
				//update position data in class
			}
		}
		
		//private function isSceneComplete():Boolean {
		
		public function checkForSceneryInteraction(leftPosition:Point, rightPosition:Point):void {
			for each (var object in scenery) {
				//trace("Object: " + "(" + object.x + ", " + object.y + ")" + " Hand: " + object.localToGlobal(leftPosition));
				//var point:Point = localToGlobal(new Point(object.x, object.y));
				if(object.isActive()) {
					if((Math.abs(object.x - (leftPosition.x * GameController.SCREEN_SIZE_X)) <= 100) && 
					   (Math.abs(object.y - (leftPosition.y * GameController.SCREEN_SIZE_X)) <= 100)) {
						trace("HIT LEFT");
						//this.party.push(new Rabbit());
						spawnAnimal(new Rabbit());
						object.setIsActive(false);
						
						var timer:Timer = new Timer(10000);
						timer.addEventListener(TimerEvent.TIMER, timerListener);
						timer.start();
					} else {
						trace("Object: (" + object.x + ", " + object.y + ") Player: (" + 
							  leftPosition.x * GameController.SCREEN_SIZE_X + ")");
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
			trace("Timer");
			for each (var object in scenery) {
				if(!object.isActive()) {
					object.setIsActive(true);
				}
			}
			for each (var animal in wild) {
				despawnAnimal(animal);
			}
		}
		
		private function spawnAnimal(animal:Animal):void {
			//trace(object);
			//var animal:Animal = object.getAnimal();
			wild.push(animal);
			animal.x = 100;
			animal.y = GameController.GROUND_HEIGHT;
			this.document.addChild(animal);
			//add animal to stage
			//start timer
			//when timer ends, call despawnAnimal
		}
		
		private function despawnAnimal(animal:Animal):void {
			this.document.removeChild(animal);
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
			//if(tag == '') {
				for each (var animal in wild) {
					//if(Class(getDefinitionByName(getQualifiedClassName(animal))) == 'Rabbit') {
					if(animal.checkTag(tag)) {
						attachAnimal(animal);
					}
					//}
				}
			//}
		}
		
		public function deactivateTag(tag:String) {
			
		}
		
		private function endGame():void {
			
		}
	}
}