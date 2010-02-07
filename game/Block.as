package game 
{
	import punk.Actor;
	import FP;
	import punk.core.Entity;
	import punk.core.SpriteMap;
	import punk.util.*;
	
	/**
	 * Acts as a container for squares, arranged in a certain shape. Square position is 
	 * an offset of the block containing it while it is falling. Once a block falls, it is
	 * destroyed and the squares within it are left on the playfield.
	 */
	public class Block extends Actor
	{
		public static const UP:int = 0;
		public static const RIGHT:int = 1;
		public static const DOWN:int = 2;
		public static const LEFT:int = 3;
		
		public static const
			J:int = 0,
			L:int = 1,
			S:int = 2,
			Z:int = 3,
			O:int = 4,
			I:int = 5,
			T:int = 6;
			
			
		[Embed(source = "../resources/block_J.xml", mimeType = "application/octet-stream")]private static var blockJ:Class;
		[Embed(source = "../resources/block_L.xml", mimeType = "application/octet-stream")]private static var blockL:Class;
		[Embed(source = "../resources/block_S.xml", mimeType = "application/octet-stream")]private static var blockS:Class;
		[Embed(source = "../resources/block_Z.xml", mimeType = "application/octet-stream")]private static var blockZ:Class;
		[Embed(source = "../resources/block_O.xml", mimeType = "application/octet-stream")]private static var blockO:Class;
		[Embed(source = "../resources/block_I.xml", mimeType = "application/octet-stream")]private static var blockI:Class;
		[Embed(source = "../resources/block_T.xml", mimeType = "application/octet-stream")]private static var blockT:Class;
		
		private static var blockJ_XML:XML = XML(new blockJ());
		private static var blockL_XML:XML = XML(new blockL());
		private static var blockS_XML:XML = XML(new blockS());
		private static var blockZ_XML:XML = XML(new blockZ());
		private static var blockO_XML:XML = XML(new blockO());
		private static var blockI_XML:XML = XML(new blockI());
		private static var blockT_XML:XML = XML(new blockT());
		
		public static var blocks:Array = [blockJ_XML, blockL_XML, blockS_XML, blockZ_XML, blockO_XML, blockI_XML, blockT_XML];
		
		private var squares:Array;
		private var time:Number;
		private var tdelay:int = 500;
		private var playfield:Playfield;
		private var rotation:int;
		private var blockXML:XML;
		
		// Booleans for handling when arrows are held down
		private var leftp:Boolean, rightp:Boolean, turnp:Boolean;
		
		public function Block(p:Playfield, type:int) 
		{
			blockXML = blocks[type];
			
			// Create contained squares
			squares = [];
			for (var k:int = 0; k < blockXML.@squares; k++) {
				squares.push(new Square(Square.colors[type]));
			}
			
			playfield = p;
			
			// 
			var now:Date = new Date();
			time = now.getTime();
			
			Input.define("left", Key.LEFT);
			Input.define("right", Key.RIGHT);
			Input.define("down", Key.DOWN);
			Input.define("turn", Key.D);
			
			leftp = false;
			rightp = false;
			turnp = false;
			delay = 0;
			
			rotation = UP;
			
			
			// Add contained squares to playfield
			for (k = 0; k < squares.length; k++) {
				playfield.add(squares[k]);
			}
			
			updateSquares();
		}
		
		override public function update():void {
			var now:Date = new Date();
			
			// Check the time delay
			// Blocks only move downward every tdelay milliseconds.
			if (now.getTime() - time > tdelay) {
				
				// Have we landed?
				if (collide("block", 0, 7) || outOfBounds(0, 7)) {
					
					// Make squares solid and add to playfield grid
					for (var k:int = 0; k < squares.length; k++) {
						squares[k].setCollisionType("block");
						playfield.rows[squares[k].gridY][squares[k].gridX] = squares[k];
					}
					
					// Check for full lines, cleanup
					playfield.checkLines();
					playfield.addBlock();
					playfield.remove(this);
					return;
				} else {
					y += 7;
					time = now.getTime();
				}
			}
			
			// Left movement
			if (Input.check("left")) {
				if (!outOfBounds(-7, 0) && !collide("block", -7, 0) && !leftp) {
					x -= 7;
					leftp = true;
				}
			} else {
				leftp = false;
			}
			
			// Right Movement
			if (Input.check("right")) {
				if (!outOfBounds(7, 0) && !collide("block", 7, 0) && !rightp) {
					x += 7;
					rightp = true;
				}
			} else {
				rightp = false;
			}
			
			// Down = smaller delay
			if (Input.check("down")) {
				tdelay = 50;
			} else {
				tdelay = 500;
			}
			
			if (Input.check("turn")) {
				if (!turnp) {
					rotation = (rotation + 1) % 4;
					turnp = true;
				}
			} else {
				turnp = false;
			}
			
			updateSquares();
		}
		
		private function updateSquares():void {
			// Update position of childen boxes
			// Positions should be pushed to XML or something
			var orientXML:XML;
			switch (rotation) {
				case UP:
					orientXML = blockXML.up[0]; break;
				case RIGHT:
					orientXML = blockXML.right[0]; break;
				case DOWN:
					orientXML = blockXML.down[0]; break;
				case LEFT:
					orientXML = blockXML.left[0]; break;
			}
			
			for (var m:int = 0; m < orientXML.square.length(); m++) {
				squares[m].x = x + int(orientXML.square[m].@x);
				squares[m].y = y + int(orientXML.square[m].@y);
			}
		}
		
		/**
		 * Checks collision by checking collision of each individual square.
		 * 
		 * @param	type	Type of object to check collision againts
		 * @param	dx		Change in X position to check at (ie dx = 4, will check at x + 4)
		 * @param	dy		Change in Y position to check at
		 * @return			Entity currently colliding with, or null if no collision occurs
		 */
		override public function collide(type:String, dx:int, dy:int):Entity {
			var returnVal:Entity = null;
			
			for (var k:int = 0; k < squares.length; k++) {
				returnVal = squares[k].collide(type, squares[k].x + dx, squares[k].y + dy);
				if (returnVal != null) break;
			}
			
			return returnVal;
		}
		
		/**
		 * Checks if any squares are out of the playfield bounds
		 * 
		 * @param	dx		Change in X position to check at (ie dx = 4, will check at x + 4)
		 * @param	dy		Change in Y position to check at
		 * @return			True if out of bounds, false otherwise
		 */
		private function outOfBounds(dx:int, dy:int):Boolean {
			var returnVal:Boolean = false;
			
			var nx:int = 0, ny:int = 0;
			for (var k:int = 0; k < squares.length && !returnVal; k++) {
				nx = squares[k].x + dx;
				ny = squares[k].y + dy;
				
				returnVal = returnVal 
					|| nx < Playfield.playfieldLeft 
					|| nx + 7 > Playfield.playfieldRight
					|| ny < Playfield.playfieldTop
					|| ny + 7 > Playfield.playfieldBottom;
			}
			
			return returnVal;
		}
		
	}

}