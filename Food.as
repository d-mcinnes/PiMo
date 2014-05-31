package {
	import flash.debug.Debug;
	import flash.display.MovieClip;
	
	public class Food {
		private var name:String = "";
		private var tags:Array = [];
		private var icon:MovieClip;
		
		public function Food() {
			
		}
		
		public function setName(name:String) {this.name = name;}
		public function setTags(tags:Array) {this.tags = tags;}
		public function setIcon(icon:MovieClip) {this.icon = icon;}
		
		public function getName():String {return this.name;}
		public function getTags():Array {return this.tags;}
		public function getIcon():MovieClip {return this.icon;}
	}
}