package  {
	import flash.display.Stage;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.*;
	import flash.utils.getTimer;
	import flash.geom.Point;
	import flash.geom.*;

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

		/**
		 * Controls the proceedings for one round of the game.
		 */
		public function GameController(document:Stage) {
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
			//trace("Render");
			this.player.renderPlayer();
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
			
			var rand:int;
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
			//}
			
			for each (var object in scenery) {
				object.x = (Math.floor(Math.random() * (950 - 70 + 1)) + 70);
				object.y = 300;
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
				if((Math.abs(object.x - (leftPosition.x * 1024)) <= 100) && 
				   (Math.abs(object.y - (leftPosition.y * 1024)) <= 100)) {
					trace("HIT LEFT");
				} else {
					trace("Object: (" + object.x + ", " + object.y + ") Player: (" + 
						  leftPosition.x * 1024 + ")");
						  //trace(object.parent);
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
		
		private function spawnAnimal(object:SceneryObject):void {
			var animal:Animal = object.getAnimal();
			wild.push(animal);
			//add animal to stage
			//start timer
			//when timer ends, call despawnAnimal
		}
		
		private function despawnAnimal(animal:Animal):void {
			
		}
		
		private function attachAnimal(animal:Animal):void {
			//clear timer for despawnAnimal
			//TODO check for animal interactions
			party.push(animal);
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
		
		private function activateTag(tag:String) {
			
		}
		
		private function deactivateTag(tag:String) {
			
		}
		
		private function endGame():void {
			
		}
	}
}