package deco3850.animals {
	import flash.debug.Debug;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	public class Rat extends Animal {
		public function Rat() {
			this.setName("Rat");
			this.createTimer(7000);
			this.setTags(['all', 'rat', '2B005BC03181', '2B005B8BC932', '2B005BA81AC2', '2B005B760204', 
						  '2B005BDC6AC6', '2B005BC8F74F', '2B005B9C1AF6', '2B005B7D3835', '2B005BC67DCB', 
						  '2B005BA4DC08', '2B005BA84F97', '2B005BAEA27C', '2B005B9AD03A', '2B005B7FACA3', 
						  '2B005B934FAC', '2B005B8D42BF']);
			this.setScore(10);
			this.scaleX *= -1;
		}
		
		override public function interactionAttach():Boolean {
			if(GameController.getInstance().getIsAnimalInParty(Owl.getClass()) == false &&
			   GameController.getInstance().getIsAnimalInWild(Owl.getClass()) == false) {
				GameController.getInstance().spawnAnimal(new Owl(), Debug.randomNumber(200, GameController.SCREEN_SIZE_X - 200), GameController.GROUND_HEIGHT);
			}
			return true;
		}
		
		public static function getClass():Class {return getDefinitionByName("deco3850.animals.Rat") as Class;}
	}
}