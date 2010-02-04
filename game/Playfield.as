package game 
{
	import punk.core.World;
	
	public class Playfield extends World
	{
		
		public function Playfield() 
		{
			
		}
		
		override public function init():void {
			addBlock();
		}
		
		
		public function addBlock():void {
			var b:Block = new Block(this);
			add(b);
		}
	}

}