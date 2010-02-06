package game 
{
	import punk.core.SpriteMap;
	import punk.core.World;
	
	/**
	 * Main World of game. Stores a grid of Squares to check for complete lines.
	 */
	public class Playfield extends World
	{
		[Embed(source = '../resources/playfield.png')] private var imgPlayfield:Class;
		private var sprPlayfield:SpriteMap = FP.getSprite(imgPlayfield, 169, 197);
		
		// Playfield bounds
		public static var 
			playfieldTop:int = 38,
			playfieldLeft:int = 49,
			playfieldRight:int = 120,
			playfieldBottom:int = 180,
			playfieldWidth:int = 79,
			playfieldHeight:int = 142;
			
		// Square Grid (Adobe claims Vectors are faster than Arrays)
		public var rows:Vector.<Vector.<Square>> = new  Vector.<Vector.<Square>>(20);
		
		public function Playfield() 
		{
			
		}
		
		override public function init():void {
			// Init grid
			for (var k:int = 0; k < 20; k++) {
				rows[k] = new Vector.<Square>(10);
			}
			
			addBlock();
		}
		
		/**
		 * Scans the grid for complete lines, and calls clearRows on all complete lines.
		 */
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
		
		/**
		 * Removes all squares from a row to be cleared and adds in new rows at the top of the
		 * grid.
		 * @param	toClear		Array of indexes of rows to be cleared
		 */
		public function clearRows(toClear:Array):void {
			// Sort so that lower rows are removed first so that upper rows
			// get shifted down properly
			toClear.sort(Array.DESCENDING | Array.NUMERIC);
			
			for (var k:int = 0; k < toClear.length; k++) {
				
				// Remove the row and remove its squares from the world
				var removed:Vector.<Vector.<Square>> = rows.splice(toClear[k], 1);
				for (var m:int = 0; m < removed[0].length; m++) {
					remove(removed[0][m]);
				}
				
				// Move all squares above down.
				for (var i:int = 0; i < toClear[k]; i++) {
					for each (var sq:Square in rows[i]) {
						if (sq != null) sq.y += 7;
					}
				}
			}
			
			// Pad top of grid with new rows
			for (k = 0; k < toClear.length; k++) {
				rows.unshift(new Vector.<Square>(10));
			}
		}
		
		public function debugShowRows():void
		{
			trace("Rows:\n--------------------------------------------------");
			var debugdisplay:String = "";
			for (var k:int = 0; k < 20; k++) {
				debugdisplay = debugdisplay + "\t";
				for (var i:int = 0; i < 10; i++) {
					if (rows[k][i] == null)
					{
						debugdisplay = debugdisplay + "[ ]";
					}
					else
					{
						debugdisplay = debugdisplay + "[X]";
					}
					
				}
				debugdisplay = debugdisplay + "\n";
			}
			debugdisplay = debugdisplay + "--------------------------------------------------";
			trace(debugdisplay);
		}
		
		/**
		 * Creates a new block at the top of the screen
		 */
		public function addBlock():void {
			var b:Block = new Block(this);
			add(b);
			b.x = playfieldLeft + (28);
			b.y = playfieldTop;
		}
		
		/**
		 * Draws the overlay
		 */
		override public function render():void {
			drawSprite(sprPlayfield);
		}
	}

}