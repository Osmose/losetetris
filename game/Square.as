package game 
{
	import punk.Actor;
	import punk.core.*;
	
	public class Square extends Actor
	{
		[Embed(source = '../resources/square.png')] private static var imgSquare:Class;
		private static var sprSquare:SpriteMap = FP.getSprite(imgSquare, 8, 8);
		
		public function Square() 
		{
			sprite = sprSquare;
			setCollisionRect(6, 6, 1, 1);
		}
		
	}

}