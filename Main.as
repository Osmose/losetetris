package
{
	import punk.core.*;
	import game.*;
	
	[SWF(width = "142", height = "284")]
	[Frame(factoryClass = "punk.core.Factory")]
	
	public class Main extends Engine
	{
		public function Main()
		{
			super(71, 142, 60, 2, Playfield, false, true);
		}
	}
}