package game 
{
	import punk.Actor;
	import punk.core.*;
	
	public class Square extends Actor
	{
		// Colors and sprites for squares
		[Embed(source = '../resources/square_blue.png')] 	private static var imgSquareBlue:Class;
		[Embed(source = '../resources/square_orange.png')] 	private static var imgSquareOrange:Class;
		[Embed(source = '../resources/square_green.png')] 	private static var imgSquareGreen:Class;
		[Embed(source = '../resources/square_red.png')] 	private static var imgSquareRed:Class;
		[Embed(source = '../resources/square_yellow.png')] 	private static var imgSquareYellow:Class;
		[Embed(source = '../resources/square_cyan.png')] 	private static var imgSquareCyan:Class;
		[Embed(source = '../resources/square_purple.png')] 	private static var imgSquarePurple:Class;
	
		private static var sprSquareBlue:SpriteMap 		= FP.getSprite(imgSquareBlue, 8, 8);
		private static var sprSquareOrange:SpriteMap 	= FP.getSprite(imgSquareOrange, 8, 8);
		private static var sprSquareGreen:SpriteMap 	= FP.getSprite(imgSquareGreen, 8, 8);
		private static var sprSquareRed:SpriteMap 		= FP.getSprite(imgSquareRed, 8, 8);
		private static var sprSquareYellow:SpriteMap 	= FP.getSprite(imgSquareYellow, 8, 8);
		private static var sprSquareCyan:SpriteMap 		= FP.getSprite(imgSquareCyan, 8, 8);
		private static var sprSquarePurple:SpriteMap 	= FP.getSprite(imgSquarePurple, 8, 8);
		
		public static var colors:Array = [
			sprSquareBlue, 
			sprSquareCyan, 
			sprSquareGreen, 
			sprSquareOrange, 
			sprSquarePurple, 
			sprSquareRed,
			sprSquareYellow
		];
		
		public var id:String;
		
		public function Square(sprSquare:SpriteMap) 
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