package  {
	
	public class Rabbit extends Animal implements IAnimal, IPrey {

		public function Rabbit() {
			// constructor code
		}
		
		public function encounterPredator(predator:IPredator):void {
			
		}
		
		public function idle():void {
			
		}
		
		public function move(partySize:int):void {
			//if (partySize <= 0, error
			if (partySize <= 2) {
				moveCalm();
			} else if (partySize <= 4) {
				moveEager();
			} else if (partySize <= 6) {
				moveExcited();
			}
		}
		
		public function moveCalm():void {
			
		}
		
		public function moveEager():void {
			
		}
		
		public function moveExcited():void {
			
		}

	}
	
}
