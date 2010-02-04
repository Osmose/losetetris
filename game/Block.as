package game 
{
	import punk.Actor;
	import FP;
	import punk.core.Entity;
	import punk.util.*;
	
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
		
		private var leftp:Boolean, rightp:Boolean, turnp:Boolean;
		
		[Embed(source = '../resources/block.png')] private var imgBlock:Class;
		
		public function Block(p:Playfield) 
		{
			squares = [new Square(), new Square(), new Square(), new Square()];
			playfield = p;
			
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
			
			for (var k:int = 0; k < squares.length; k++) {
				playfield.add(squares[k]);
			}
		}
		
		override public function update():void {
			var now:Date = new Date();
			if (now.getTime() - time > tdelay) {
				if (collide("block", 0, 7) || y + 7 + 21 > 142) {
					for (var k:int = 0; k < squares.length; k++) {
						squares[k].setCollisionType("block");
					}
					playfield.addBlock();
					playfield.remove(this);
				} else {
					y += 7;
					time = now.getTime();
				}
			}
			
			if (Input.check("left")) {
				if (x - 7 >= 0 && !collide("block", -7, 0) && !leftp) {
					x -= 7;
					leftp = true;
				}
			} else {
				leftp = false;
			}
			
			if (Input.check("right")) {
				if (x + 14 < 71 && !collide("block", 7, 0) && !rightp) {
					x += 7;
					rightp = true;
				}
			} else {
				rightp = false;
			}
			
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
		
		override public function collide(type:String, dx:int, dy:int):Entity {
			var returnVal:Entity = null;
			
			for (var k:int = 0; k < squares.length; k++) {
				returnVal = squares[k].collide(type, squares[k].x + dx, squares[k].y + dy);
				trace(returnVal);
				if (returnVal != null) break;
			}
			
			return returnVal;
		}
		
	}

}