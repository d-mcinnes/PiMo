package deco3850.food {
	public class Bone extends Food {
		public function Bone() {
			this.setName("Bone");
			this.setTags([]);
			this.setIcon(new IconBone());
			this.getIcon().x = 0;
			this.getIcon().y = 0;
			this.getIcon().visible = false;
		}
	}
}