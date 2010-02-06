package game 
{
	import punk.core.SpriteMap;
	import punk.core.World;
	
	public class Playfield extends World
	{
		[Embed(source = '../resources/playfield.png')] private var imgPlayfield:Class;
		private var sprPlayfield:SpriteMap = FP.getSprite(imgPlayfield, 169, 197);
		
		public static var 
			playfieldTop:int = 38,
			playfieldLeft:int = 49,
			playfieldRight:int = 120,
			playfieldBottom:int = 180,
			playfieldWidth:int = 79,
			playfieldHeight:int = 142;
			
			public var rows:Vector.<Vector.<Square>> = new  Vector.<Vector.<Square>>(20);
		
		public function Playfield() 
		{
			
		}
		
		override public function init():void {
			for (var k:int = 0; k < 20; k++) {
				rows[k] = new Vector.<Square>(10);
			}
			
			addBlock();
		}
		
		public function checkLines():void {
			var fullRows:Array = [];
			
			for (var k:int = 0; k < 20; k++) {
				for (var i:int = 0; i < 10; i++) {
					if (rows[k][i] == null) {
						break;
					}
				}
				
				if (i == 10) fullRows.push(k);
			}
			
			if (fullRows.length > 0) {
				clearRows(fullRows);
			}
		}
		
		public function clearRows(toClear:Array):void {
			toClear.sort(Array.DESCENDING | Array.NUMERIC);
			
			for (var k:int = 0; k < toClear.length; k++) {
				var removed:Vector.<Vector.<Square>> = rows.splice(toClear[k], 1);
				for each (var sq:Square in removed[0]) {
					remove(sq);
				}
				
				// Move all squares above down.
				for (var i:int = 0; i < toClear[k]; i++) {
					for each (sq in rows[i]) {
						if (sq != null) {
							sq.y += 7;
							trace("(" + sq.gridX + "," + sq.gridY + ")");
						}
					}
				}
			}
			
			// Pad top
			for (k = 0; k < toClear.length; k++) {
				rows.unshift(new Vector.<Square>(10));
			}
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