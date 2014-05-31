package {
	import deco3850.food.BirdSeed;
	import deco3850.food.Bone;
	import deco3850.food.Carrot;
	import deco3850.food.Cheese;
	import deco3850.food.Fish;
	import deco3850.food.Grass;
	import deco3850.food.Meat;
	
	public class FoodItems {
		public var birdSeed:BirdSeed = new BirdSeed();
		public var bone:Bone = new Bone();
		public var carrot1:Carrot = new Carrot();
		public var carrot2:Carrot = new Carrot();
		public var cheese:Cheese = new Cheese();
		public var fish:Fish = new Fish();
		public var grass1:Grass = new Grass();
		public var grass2:Grass = new Grass();
		public var meat:Meat = new Meat();
		
		public function FoodItems() {
			this.birdSeed.setName("Bird Seed");
			this.birdSeed.setTags([]);
			this.birdSeed.setIcon(new Icon_BirdSeed());
			
			this.bone.setName("Bone");
			this.bone.setTags([]);
			this.bone.setIcon(new IconBone());
			
			this.carrot1.setName("Carrot");
			this.carrot1.setTags([]);
			this.carrot1.setIcon(new Icon_Carrot());
			
			this.carrot2.setName("Carrot");
			this.carrot2.setTags([]);
			this.carrot2.setIcon(new Icon_Carrot());
			
			this.cheese.setName("Cheese");
			this.cheese.setTags([]);
			this.cheese.setIcon(new Icon_Cheese());
			
			this.fish.setName("Fish");
			this.fish.setTags([]);
			this.fish.setIcon(new Icon_Fish());
			
			this.meat.setName("Meat");
			this.meat.setTags([]);
			this.meat.setIcon(new Icon_Meat());
		}
	}
}