package  {
	import flash.debug.Debug;
	
	public class Objective {
		private var name:String = "";
		private var description:String = "";
		private var score:Number = 0;
		
		public function Objective() {
			
		}
		
		public function getName():String {return this.name;}
		public function getDescription():String {return this.description;}
		public function getScore():Number {return this.score;}
		
		public function setName(name:String) {this.name = name;}
		public function setDescription(description:String) {this.description = description;}
		public function setScore(score:Number) {this.score = score;}
		
		public function isComplete():Boolean {
			return false;
		}
		
		public function complete() {
			
		}
	}
}