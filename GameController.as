package  {
	import flash.display.Stage;

	public class GameController {
		private var document:Stage;
		
		private var kinectInput:KinectInput;
		//private var rfidReader:RFIDReaderSingle;
		
		private var score:int; //cumulative score for this game, nonnegative
		
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
			//this.rfidReader = new RFIDReaderSingle(this);
			this.score = 0;
			this.wild = new Array();
			this.party = new Array();
			
			this.player = new Player(this.kinectInput.getKinectSkeleton());
			this.player.x = 50;
			this.player.y = 400;
			this.document.addChild(this.player);
			
			loadScene();
			loadScenery();
			
			//while loop for playing game
			
			endGame();
		}
		
		public function renderPlayer() {
			//trace("Render");
			this.player.renderPlayer();
		}
		
		private function loadScene():void {
			//TODO reset scene elements
			//TODO set background
			loadScenery();
		}
		
		private function loadScenery():void {
			this.scenery = new Array();
			
			var rand:int;
			for (var i:int = 0; i < 3; ++i) {
				//rand = 1 + Math.ceil(Math.random() + 3);
				rand = 2; //TODO only using long grass for prototype
				switch (rand) {
					case 1:
					scenery.push(SceneryTree);
					break;
					
					case 2:
					scenery.push(SceneryGrass);
					break;
					
					case 3:
					scenery.push(SceneryBurrow);
					break;
					
					case 4:
					scenery.push(SceneryFarm);
					break;
				}
			}
			
			for each (var object in scenery) {
				//TODO add image to scene
				//update position data in class
			}
		}
		
		//private function isSceneComplete():Boolean {
		
		private function checkForSceneryInteraction():void {
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