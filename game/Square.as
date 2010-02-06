package game 
{
	import punk.Actor;
	import punk.core.*;
	
	public class Square extends Actor
	{
		[Embed(source = '../resources/square.png')] private static var imgSquare:Class;
		private static var sprSquare:SpriteMap = FP.getSprite(imgSquare, 8, 8);
		
		public var id:String;
		
		public function Square() 
		{
			sprite = sprSquare;
			setCollisionRect(6, 6, 1, 1);
			
			var now:Date = new Date();
			id = "id" + now.getTime();
		}
		
		public function get gridX():int {
			return (x - Playfield.playfieldLeft) / 7;
		}
		
		public function set gridX(val:int):void {
			x = Playfield.playfieldLeft + (val * 7);
		}
		
		public function get gridY():int {
			return (y - Playfield.playfieldTop) / 7;
		}
		
		public function set gridY(val:int):void {
			y = Playfield.playfieldTop + (val * 7)
		}
	}

}