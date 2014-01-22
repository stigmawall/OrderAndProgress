package  
{
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * Camera control - control angle, and animation speed
	 * 
	 * @author Wallace 'Wakko' Morais
	 */
	public class Camera extends Sprite 
	{
		
		public var _hand:Boolean;
		private var _shakeVar:Number;
		private var _shakeTime:Number;
		private var _tween:Tween;
		private var _x:Number;
		private var _y:Number;
		private var _layers:Array;
		
		
		
		public function Camera( $hand:Boolean = false ) 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			this._hand = $hand;
		}
		
		
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this._shakeVar = 4;
			this._shakeTime = .5
			this._x = this.x;
			this._y = this.y;
			this._layers = [];
			
			if (this._hand) recursiveHandAnimation();
		}
		
		
		
		public function ativeHand( $shakeVar:Number, $shakeTime:Number ):void 
		{ 
			this._shakeVar = $shakeVar;
			this._shakeTime = $shakeTime;
			this._hand = true;
			recursiveHandAnimation();
		}
		
		
		
		public function deactiveHand():void 
		{
			this._hand = false;
			Starling.juggler.remove( this._tween );
			this._tween = null;
		}
		
		
		
		private function recursiveHandAnimation():void 
		{
			try { Starling.juggler.remove( this._tween ); } catch (e:Error) { }
			
			this._tween = new Tween( this, Math.random()*this._shakeTime );
			this._tween.moveTo( this._x + ( -this._shakeVar + (Math.random() * this._shakeVar)), 
								this._y + ( -this._shakeVar + (Math.random() * this._shakeVar)) );
			this._tween.onComplete = recursiveHandAnimation;
			Starling.juggler.add( this._tween );
		}
		
		
		
		public function zoom( $zoom:Number, $anim:Number = 0 ):void {
			Starling.juggler.tween( this, $anim, { scaleY:$zoom, scaleX:$zoom } );
		}
		
		
		
		public function goto($x:Number, $y:Number, $anim:Boolean = false, $t:Number = 1, $d:Number = 0, $f:Function = null ):void 
		{
			var i:uint;
			this._x = $x;
			this._y = $y;
			
			if ( !$anim ) {
				this.x = -$x; 
				this.y = -$y;
				for ( i = 0; i < this._layers.length; i++ ) {
					this._layers[i].item.x = -($x * this._layers[i].depth);
					this._layers[i].item.y = -($y * this._layers[i].depth);
				}
				
				if ($f!=null) $f();
			} else {
				
				Starling.juggler.tween( this, $t, { x: -$x, y: -$y, delay: $d, transition: Transitions.EASE_IN_OUT, onComplete: $f } );
				for ( i = 0; i < this._layers.length; i++ ) {
					
					Starling.juggler.tween( this._layers[i].item, $t, { x: -($x * this._layers[i].depth), 
																		y: -($y * this._layers[i].depth), 
																		delay: $d, 
																		transition: Transitions.EASE_IN_OUT } );
				}
			}
		}
		
		
		
		public function addLayer( obj:*, $depth:Number = 1 ):void {
			this._layers.push( { item: obj, depth:$depth } );
		}
		
		public function get shakeVar():Number {
			return _shakeVar;
		}
		
		public function set shakeVar(value:Number):void 
		{
			_shakeVar = value;
		}
		
		public function get shakeTime():Number 
		{
			return _shakeTime;
		}
		
		public function set shakeTime(value:Number):void 
		{
			_shakeTime = value;
		}
		
		
	}

}