package engine.huds
{
	import starling.core.Starling;
	import starling.display.Sprite;	
	import starling.text.TextField;
	
	
	/**
	 * Console for trace erros, warnings and everything I want, ohoho
	 * @author Wallace 'Wakko' Morais
	 */
	public class Console extends Sprite 
	{
		private static var _container:*;
		
		private static var _instance:Console;
		
		private static var _messages:TextField;
		
		private static var _debug_button:uint;
		
		private static var _debug:Boolean = false;
		
		public function Console() { }
		
		
		
		public static function getInstance():Console
		{
			if ( !_instance )
			{
				_instance = new Console();
			} 
			
			return _instance;
		}
		
		
		
		
		public static function init( $debug:Boolean = true, $debugInScreen:Boolean = false, $debug_button:uint = 17 ):void
		{
			//_container = $container;
			_messages = new TextField( 640, 200, "", "Arial", 10, 0xffffff, true );
			_messages.x = 0;
			_messages.y = -90;
			
			_debug_button = $debug_button
			
			getInstance();
			drawModal();
			
			_debug = $debug;
			
			_instance.addChild( _messages );
			//_container.addChild( _instance );
		}
		
		
		
		
		
		static private function drawModal():void
		{
			_instance.y = _instance.x = 0;
		}
		
		
		
		
		public static function log( text:* ):void
		{
			if(_debug) {
				_messages.text = text;
				Starling.current.stage.addChild( _instance );
			}
		}
		
	}

}