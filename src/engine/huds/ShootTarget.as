package engine.huds 
{
	import engine.gamestates.Game;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.textures.Texture;
	
	/**
	 * target for shoots
	 * @author Wallace wakko Morais
	 */
	public class ShootTarget extends Image 
	{
		
		private var _touch:Touch;
		private var _shoot:Boolean;
		private var _scaleXContainer:Number;
		private var _scaleYContainer:Number;
		
		
		
		public function ShootTarget( $touch:Touch ) 
		{
			this._shoot = false;
			this._touch = $touch;
			this.touchable = false;
			super( Texture.fromBitmap( new Resource.TARGET ) );
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			this._scaleXContainer = Game.INSTANCE.container.scaleX;
			this._scaleYContainer = Game.INSTANCE.container.scaleY;
		}
		
		
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.pivotX = this.width / 2;
			this.pivotY = this.height / 2;
			
			this.x = this._touch.globalX / this._scaleXContainer;
			this.y = this._touch.globalY / this._scaleYContainer;
		}
		
		
		
		public function animate():void 
		{
			this._shoot = true;
			Starling.juggler.tween( this, 0.2, { rotation: 0.8 } );
		}
		
		
		override public function update():void 
		{
			this.x = this._touch.globalX / this._scaleXContainer;
			this.y = this._touch.globalY / this._scaleYContainer;
		}
		
		
		public function get touch():Touch 
		{
			return _touch;
		}
		
	}

}