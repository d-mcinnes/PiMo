package  {
	
	//Defines methods that all Animal classes need to implement.
	public interface IAnimal {
		
		//Animals are idle before they are 'attracted' by the player
		public function idle():void;
		
		//Movement 'enthusiasm' increases with party size
		public function moveBySize(partySize:int):void;
		public function moveCalm():void;
		public function moveEager():void;
		public function moveExcited():void;
		
		//Gives the score associated with this animal
		public function getScore():int;
	}
	
}
