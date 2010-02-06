package game 
{
	import punk.Actor;
	import FP;
	import punk.core.Entity;
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
		
		private var squares:Array;
		private var time:Number;
		private var tdelay:int = 500;
		private var playfield:Playfield;
		private var rotation:int;
		
		// Booleans for handling when arrows are held down
		private var leftp:Boolean, rightp:Boolean, turnp:Boolean;
		
		[Embed(source = '../resources/block.png')] private var imgBlock:Class;
		
		public function Block(p:Playfield) 
		{
			// Create contained squares
			squares = [new Square(), new Square(), new Square(), new Square()];
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
			for (var k:int = 0; k < squares.length; k++) {
				playfield.add(squares[k]);
			}
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
			
			// Update position of childen boxes
			// Positions should be pushed to XML or something
			if (rotation == UP) {
				squares[0].x = x + 0;
				squares[0].y = y + 0;
				squares[1].x = x + 0;
				squares[1].y = y + 7;
				squares[2].x = x + 0;
				squares[2].y = y + 14;
				squares[3].x = x + 7;
				squares[3].y = y + 14;
			} else if (rotation == RIGHT) {
				squares[0].x = x + 0;
				squares[0].y = y + 0;
				squares[1].x = x + 7;
				squares[1].y = y + 0;
				squares[2].x = x + 14;
				squares[2].y = y + 0;
				squares[3].x = x + 0;
				squares[3].y = y + 7;
			} else if (rotation == DOWN) {
				squares[0].x = x + 0;
				squares[0].y = y + 0;
				squares[1].x = x + 7;
				squares[1].y = y + 0;
				squares[2].x = x + 7;
				squares[2].y = y + 7;
				squares[3].x = x + 7;
				squares[3].y = y + 14;
			} else if (rotation == LEFT) {
				squares[0].x = x + 0;
				squares[0].y = y + 7;
				squares[1].x = x + 7;
				squares[1].y = y + 7;
				squares[2].x = x + 14;
				squares[2].y = y + 7;
				squares[3].x = x + 14;
				squares[3].y = y + 0;
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