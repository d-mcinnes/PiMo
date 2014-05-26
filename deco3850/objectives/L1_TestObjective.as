package deco3850.objectives {
	import flash.debug.Debug;
	
	public class L1_TestObjective extends Objective {
		
		public function L1_TestObjective() {
			this.setName("Test Objective 1");
			this.setDescription("This is a test objective.");
		}
		
		override public function isComplete():Boolean {
			return false;
		}
	}
}