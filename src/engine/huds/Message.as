package engine.huds
{
	import engine.gamestates.Game;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * Message box class - Draw a box and print a text
	 * @author Wallace 'Wakko' Morais
	 */
	public class Message extends Sprite 
	{
		private const _fps:int = 30;
		
		private var _message:String;
		private var _format:String;
		private var _head:Class;
		private var _direction:uint;
		private var _time:Number;
		private var _coroutine:Function;
		private var _co:Boolean;
		
		private var _counter:uint;
		//private var _pointer:Shape;
		//private var _box:Shape;
		private var _alive:Boolean;
		private var _animText:AnimatedTextField
		
		
		//public function Message( $target:DisplayObject, $message:String, $time:Number = 0, $format:String = "normal", $coroutine:Function = null ) 
		public function Message( $head:Class, $message:String, $direction:uint, $time:Number = 0, $format:String = "normal", $coroutine:Function = null ) 
		{
			this._message = $message;
			this._format = $format;
			this._head = $head;
			this._time = $time;
			this._direction = $direction;
			this._coroutine = $coroutine;
			this._alive = true;
			this._co = true;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this._counter = 0;
			
			var modal:Image = new Image( Texture.fromBitmap( new Resource.MODALBOX() ) );
			modal.x = (stage.stageWidth / 2) - (modal.width / 2);
			modal.y = (stage.stageHeight / 2) - (modal.height / 2);
			this.addChild( modal );
			
			var head:Image = new Image( Texture.fromBitmap( new this._head() ) );
			head.y = modal.y + 22;
			if ( this._direction==0 ) {
				head.x = modal.x + 22;
			} else {
				head.x = modal.x + modal.width - 22;
				head.scaleX = -1;
			}
			
			
			_animText = new AnimatedTextField(40, modal.width - head.width - 50, modal.height, this._message, 1, "Visitor", 32, 0x00ff00);
			_animText.y = modal.y + 22;
			if ( this._direction == 0 )
				_animText.x = head.x + head.width + 30;
			else
				_animText.x = modal.x + 30;
			
			
			this.addChild( head );
			this.addChild( _animText );
			_animText.addEventListener(Event.COMPLETE, function():void { _alive = false; } );
			_animText.startAnimation("left");
			
			
			// obsoleto ba garaaaai
			/*
			//this._pointer = new Shape();
			this.addChild( this._pointer );
			
			// get size
			//var tam:uint = (this._message.length <= 20) ? this._message.length : 20;
			var tam:uint = stage.stageWidth - 20;
			//tam *= 13;
			var alt:uint = uint( 30 * (this._message.length / 20));
			
			
			switch( this._format )
			{
				case 'normal' :
					//make box
					this._box = new Shape();
					this._box.graphics.lineStyle(1,0,0);
					this._box.graphics.beginFill(0xffffff);
					this._box.graphics.moveTo(0,0);
					this._box.graphics.lineTo(tam, 0);
					this._box.graphics.lineTo(tam, alt);
					this._box.graphics.lineTo(0, alt);
					this._box.graphics.lineTo(0, 0);
					this._box.graphics.endFill();
					addChild(this._box);
					
					// make text
					var tf:TextField = new TextField(tam, alt, this._message,"Visitor", 38, 0x000000, false );
					addChild(tf);
					
					this.generatePointer(tam, alt);
			}
			*/
		}
		
		
		
		
		/*
		private function generatePointer($tam:Number, $alt:Number):void 
		{
			this._pointer.graphics.clear();
			this._pointer.graphics.lineStyle(1,0,0);
			this._pointer.graphics.beginFill(0xffffff);
			
			
			// Top of screen
			if ( this._target.localToGlobal(new Point(0,0)).y < this.stage.stageHeight / 2 ) {
				this.pivotY = -40;
				$alt = 0;
			}
			// Bottom of screen
			else { this.pivotY = $alt + 40; }
				
			
			this._pointer.graphics.moveTo(($tam / 2) - 10, $alt);
			this._pointer.graphics.lineTo(($tam / 2) + 10, $alt);
			
			
			// Left of screen
			if ( this._target.x < this.stage.stageWidth / 2 ) {
				this._pointer.graphics.lineTo(0, $alt - 40);
				this._pointer.graphics.lineTo(($tam / 2) - 10, $alt);
				this.pivotX = 0;
			} 
			
			// Right of screen
			else {
				this._pointer.graphics.lineTo($tam, $alt - 40);
				this._pointer.graphics.lineTo(($tam / 2) - 10, $alt);
				this.pivotX = $tam;
			}
			
			
			this._pointer.graphics.endFill();
			this.addChild( this._pointer );
		}
		*/
		
		
		
		public function finish( $co:Boolean = true ):void {
			this._co = $co;
			this._alive = false;
			this._animText.stopAnimation();
		}
		
		
		
		
		public function update():void
		{
			if (!this.stage) 
			{
				this.dispose();
				return;
			}
			
			//this.x = this._target.x;
			//this.y = this._target.y;
			
			if ( this._time == 0  ) return;
			this._counter++;
			
			
			// when time's over
			var g:Game = Game.INSTANCE;
			if ( this._counter / this._fps >= this._time ) {
				g = null;
				this.dispose();
			}
		}
		
		
		
		
		override public function dispose():void 
		{
			var hasStage:Boolean = false;
			this._alive = false;
			this.removeChild( this._animText );
			this._animText.dispose();
			
			
			if ( Game.INSTANCE ) delete Game.INSTANCE.messages[ this.name ];			
			if ( this.parent.stage ) {
				hasStage = true;
				this.parent.removeChild( this );
			}
			
			//this._box.dispose();
			//this._pointer.dispose();
			
			if ( this._co && this._coroutine != null && hasStage ) this._coroutine();
			this._coroutine = null;
			
			super.dispose();
		}
		
		
		
		public function get time():Number 
		{
			return _time;
		}
		
		public function get alive():Boolean 
		{
			return _alive;
		}
		
		
	}

}
