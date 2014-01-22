package engine.huds
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.VAlign;
	
	/**
	 * 
	 * 
	 * @author Wallace 'Wakko' Morais
	 */
	public class AnimatedTextField extends TextField 
	{
		
		private var _string:String;
		private var _count:uint;
		private var _timer:Timer;
		private var _repeat:uint; 
		private var _repeatCount:uint; 
		
		
		public function AnimatedTextField( $timeInterval:Number, $width:Number, $height:Number, $text:String, $repeat:uint = 1, $fontName:String="Verdana", $fontSize:uint=12, $color:uint=0x0, $bold:Boolean=false ) {
			this._string = $text;
			this._count = 0;
			this._repeat = $repeat;
			this._repeatCount = 0;
			this._timer = new Timer( $timeInterval, this._string.length * $repeat );
			
			super($width, $height, "", $fontName, $fontSize, $color, $bold);
		}
		
		
		private function onTimerInterval(e:TimerEvent):void {
			this._count++;
			
			if ( this._count == this._string.length && this._repeat > 1 )
			{
				this._repeatCount++;
				this._count = 0;
				this.text = "";
				
				if ( this._repeatCount == this._count )
					return;
			}
			else
			{
				this.text = this._string.substr( 0, this._count );
			}
		}
		
		
		private function onTimerComplete(e:TimerEvent):void {
			this.dispatchEvent( new Event( Event.COMPLETE, false ) );
			this._timer.removeEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete );
			this._timer.removeEventListener( TimerEvent.TIMER, onTimerInterval );
		}
		
		
		public function startAnimation($align:String = 'left'):void {
			this._timer.addEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete, false, 0, true );
			this._timer.addEventListener( TimerEvent.TIMER, onTimerInterval, false, 0, true );
			
			this.text = "";
			this.hAlign = $align;
			this.vAlign = VAlign.TOP;
			this._count = 0;
			this._timer.start();
		}
		
		public function stopAnimation():void 
		{
			this._timer.stop();
			this._timer.removeEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete );
			this._timer.removeEventListener( TimerEvent.TIMER, onTimerInterval );
			this.text = this._string;
		}
		
	}

}