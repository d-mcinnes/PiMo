package  {
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
	
	public class Scenery extends MovieClip {
		private var active:Boolean = false;

		public function Scenery() {
			// constructor code
		}
		
		public function setIsActive(active:Boolean) {
			this.active = active;
			if(!active) {
				this.filters = [ new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0]) ];
			} else {
				this.filters = [];
			}
		}
		
		public function isActive():Boolean {return this.active;}
	}
}