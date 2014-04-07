package  {
	import flash.display.MovieClip;
	
	public class Main extends MovieClip {
		private var environment:Environment;
		
		public function Main() {
			
		}
		
		private function createEnvironment() {
			this.environment = new Environment();
		}
	}
}