package {
	import flash.debug.Debug;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class GameInterfaceFood extends MovieClip {
		private var foodItems:Array;
		
		public function GameInterfaceFood() {
			this.x = GameController.SCREEN_SIZE_X;
			this.y = 40;
			this.foodItems = new Array();
			this.renderIcons();
		}
		
		public function renderIcons() {
			for each(var object in this.foodItems) {
				this.removeChild(object);
			}
			this.foodItems = new Array();
			var food:FoodItems = GameController.getInstance().getFoodItems();
			
			if(food != null) {
				if(food.birdSeed.getActive() == true) {
					this.foodItems.push(food.birdSeed.getIcon());
				}
				if(food.bone.getActive() == true) {
					this.foodItems.push(food.bone.getIcon());
				}
				if(food.carrot1.getActive() == true) {
					this.foodItems.push(food.carrot1.getIcon());
				}
				if(food.carrot2.getActive() == true) {
					this.foodItems.push(food.carrot2.getIcon());
				}
				if(food.cheese1.getActive() == true) {
					this.foodItems.push(food.cheese1.getIcon());
				}
				if(food.cheese2.getActive() == true) {
					this.foodItems.push(food.cheese2.getIcon());
				}
				if(food.fish.getActive() == true) {
					this.foodItems.push(food.fish.getIcon());
				}
				if(food.grass1.getActive() == true) {
					this.foodItems.push(food.grass1.getIcon());
				}
				if(food.grass2.getActive() == true) {
					this.foodItems.push(food.grass2.getIcon());
				}
				if(food.meat.getActive() == true) {
					this.foodItems.push(food.meat.getIcon());
				}
				
				var x:Number = -10;
				for each(var foodObject in this.foodItems) {
					foodObject.x = x;
					foodObject.y = 0;
					x -= 35;
					this.addChild(foodObject);
				}
			}
		}
	}
}