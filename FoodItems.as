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
		public var cheese1:Cheese = new Cheese();
		public var cheese2:Cheese = new Cheese();
		public var fish:Fish = new Fish();
		public var grass1:Grass = new Grass();
		public var grass2:Grass = new Grass();
		public var meat:Meat = new Meat();
		
		public function FoodItems() {
			this.birdSeed.setName("Bird Seed");
			this.birdSeed.setTags(['2B005BC78037', '2B005B77ECEB', '2B005BD01FBF', '2B005B76B7B1', 
								   '2B005BB69650', '2B005BC51FAA', '2B005BAD29F4', '2B005BBC0AC6']);
			this.birdSeed.setIcon(new Icon_BirdSeed());
			
			this.bone.setName("Bone");
			this.bone.setTags(['2B005B763731', '2B005BDCFD51', '2B005BB1D617', 
							   '2B005BA5895C', '2B005BCD4DF0', '2B005B783830']);
			this.bone.setIcon(new IconBone());
			this.bone.setActive(true);
			
			this.carrot1.setName("Carrot");
			this.carrot1.setTags(['0103C80917D4', '01023880D46F', '010238776E22', '0B00E74BF354', 
								  '0102389F15B1', '0103F49EB8D0', '190065293B6E', '0103D778973A']);
			this.carrot1.setIcon(new Icon_Carrot());
			this.carrot1.setActive(true);
			
			this.carrot2.setName("Carrot");
			this.carrot2.setTags(['01056DF553CF', '0103D7E13703', '2B005BADC71A', '010445B541B4', 
								  '2B005BA24E9C', '0102BC08FF48', '2B005B937B98', '2B005BA6A573']);
			this.carrot2.setIcon(new Icon_Carrot());
			this.carrot2.setActive(true);
			
			this.cheese1.setName("Cheese");
			this.cheese1.setTags(['2B005BC67DCB', '2B005BA4DC08', '2B005BA84F97', '2B005BAEA27C', 
								  '2B005B9AD03A', '2B005B7FACA3', '2B005B934FAC', '2B005B8D42BF']);
			this.cheese1.setIcon(new Icon_Cheese());
			
			this.cheese2.setName("Cheese");
			this.cheese2.setTags(['2B005BC03181', '2B005B8BC932', '2B005BA81AC2', '2B005B760204', 
								  '2B005BDC6AC6', '2B005BC8F74F', '2B005B9C1AF6', '2B005B7D3835']);
			this.cheese2.setIcon(new Icon_Cheese());
			this.cheese2.setActive(true);
			
			this.fish.setName("Fish");
			this.fish.setTags(['2B005B8401F5', '2B005B7FFCF3', '2B005BCA58E2', '2B005B7E6967', '2B005BAC8955', 
							   '2B005B95BE5B', '2B005BBE4789', '2B005B83C231', '2B005BA5D104', '2B005B8C23DF']);
			this.fish.setIcon(new Icon_Fish());
			
			this.grass1.setName("Grass");
			this.grass1.setTags(['2B005BDF71DE', '2B005B9FC32C', '2B005B95B055', '2B005BC2E557', 
								 '2B005BC16FDE', '2B005BDC2488', '2B005B827280', '2B005B79929B']);
			this.grass1.setIcon(new Icon_Grass());
			
			this.grass2.setName("Grass");
			this.grass2.setTags(['2B005BC063D3', '2B005B9058B8', '2B005BABA378', '2B005BDFDC73', 
								 '2B005B789A92', '2B005BD12F8E', '2B005B85DD28', '2B005B8C669A']);
			this.grass2.setIcon(new Icon_Grass());
			
			this.meat.setName("Meat");
			this.meat.setTags(['2B005BB79651', '2B005B767670', '2B005BC811A9', '2B005BA95089', 
							   '2B005BB84B83', '2B005BDD0DA0', '2B005B8DCD30', '2B005B809C6C']);
			this.meat.setIcon(new Icon_Meat());
		}
	}
}