package  {
	import flash.display.MovieClip;
	
	public class Animal extends MovieClip {
		private var tags:Array = [];
		
		public function Animal() {
			// constructor code
		}
		
		public function getScore():Number {
			return 0;
		}
		
		public function setTags(tags:Array) {this.tags = tags;}
		public function getTags():Array {return this.tags;}
		
		public function checkTag(tag:String):Boolean {
			for each(var object in this.tags) {
				if(object == tag) {
					return true;
				}
			}
			return false;
		}
	}
}