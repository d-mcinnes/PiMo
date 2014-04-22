package  {
	import flash.display.Stage;

	public class GameController {
		private var party:Array;
		private var kinectInput:KinectInput;
		private var document:Stage;

		public function GameController(document:Stage) {
			// constructor code
			this.document = document;
			this.kinectInput = new KinectInput(this.document);
		}
	}
}