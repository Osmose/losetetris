package game 
{
	import punk.core.SpriteMap;
	import punk.core.World;
	
	public class Playfield extends World
	{
		[Embed(source = '../resources/playfield.png')] private var imgPlayfield:Class;
		private var sprPlayfield:SpriteMap = FP.getSprite(imgPlayfield, 169, 197);
		
		public var 
			playfieldTop:int = 38,
			playfieldLeft:int = 49,
			playfieldRight:int = 120,
			playfieldBottom:int = 180,
			playfieldWidth:int = 79,
			playfieldHeight:int = 142;
		
		public function Playfield() 
		{
			
		}
		
		override public function init():void {
			addBlock();
		}
		
		
		public function addBlock():void {
			var b:Block = new Block(this);
			add(b);
			b.x = playfieldLeft + (28);
			b.y = playfieldTop;
		}
		
		override public function render():void {
			drawSprite(sprPlayfield);
		}
	}

}