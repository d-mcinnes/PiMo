package {
	import flash.debug.Debug;
	import flash.display.MovieClip;
	
	public class Food {
		private var name:String = "";
		private var tags:Array = [];
		private var icon:MovieClip;
		private var active:Boolean = false;
		
		public function Food(name:String = "", tags:Array = null, icon:MovieClip = null, active:Boolean = false) {
			this.setName(name);
			this.setTags(tags);
			this.setIcon(icon);
			this.setActive(active);
		}
		
		public function setName(name:String) {this.name = name;}
		public function setTags(tags:Array) {this.tags = tags;}
		public function setIcon(icon:MovieClip) {this.icon = icon;}
		public function setActive(active:Boolean) {this.active = active;}
		
		public function getName():String {return this.name;}
		public function getTags():Array {return this.tags;}
		public function getIcon():MovieClip {return this.icon;}
		public function getActive():Boolean {return this.active;}
		
		/** Takes a tag and returns true if that tag is assigned with this food
		 ** item, otherwise returns false. **/
		public function getIsTag(tag:String):Boolean {
			for each(var i in this.getTags()) {
				if(i == tag) {
					return true;
				}
			}
			return false;
		}
		
		public function checkAnimal(type:Class):Boolean {
			return false;
		}
	}
}