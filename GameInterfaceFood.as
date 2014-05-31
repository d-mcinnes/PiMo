package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class GameInterfaceFood extends MovieClip {
		private var foodItems:Array;
		
		public function GameInterfaceFood() {
			//this.width = 400;
			//this.height = 50;
			this.x = GameController.SCREEN_SIZE_X;
			//this.x = 300;
			this.y = 40;
			this.foodItems = new Array();
			//var bone:IconBone = new IconBone();
			//bone.x = 50;
			this.foodItems.push(new IconBone());
			
			//this.addChild(bone);
			
			this.addChild(this.foodItems[0]);
			this.foodItems[0].x = -10;
			//GameController.getInstance().getStageOverlay().addChild(this.foodItems[0]);
			
			//this.graphics.lineStyle(0,0x7B7B7B); //lineStyle(thickness, color)
			//this.graphics.beginFill(0xA6A6A6); //beginFill(color)
			//this.graphics.drawRect(0,0,60,60); //drawRect(x,y,width,height)
			//this.graphics.endFill(); //endfill
		}
	}
}