package  {
	import flash.debug.Debug;
	
	public class Objective {
		private var name:String = "";
		private var description:String = "";
		
		public function Objective() {
			
		}
		
		public function getName():String {return this.name;}
		public function getDescription():String {return this.description;}
		
		public function setName(name:String) {this.name = name;}
		public function setDescription(description:String) {this.description = description;}
		
		public function isComplete():Boolean {
			return false;
		}
		
		public function complete() {
			
		}
	}
}