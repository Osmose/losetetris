package
{
	import punk.core.*;
	import game.*;
	
	[SWF(width = "338", height = "394")]
	[Frame(factoryClass = "punk.core.Factory")]
	
	public class Main extends Engine
	{
		public function Main()
		{
			super(169, 197, 60, 2, Playfield, false, true);
		}
	}
}