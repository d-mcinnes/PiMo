package  {
	
	public class Lion extends Animal implements IAnimal, IPredator {

		public function Lion() {
			// constructor code
		}
		
		public function encounterPrey(prey:IPrey):void {
			
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
