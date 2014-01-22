package engine.display
{
	import starling.display.DisplayObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class DisplayObjectPlus extends DisplayObject 
	{
		
		protected var _finished:Boolean;
		
		protected var _arrived:Boolean;
		
		
		
		public function DisplayObjectPlus() 
		{
			super();
		}
		
		
		public function update():void { }
		
		public function explode():void 
		{ 
			
		}
		
		public function get finished():Boolean { return _finished; }
		
		public function get arrived():Boolean { return _arrived; }
		
	}

}