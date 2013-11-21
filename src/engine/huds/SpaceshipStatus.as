package engine.huds 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * Status bar of spaceship
	 * @author Wallace 'Wakko' Morais
	 */
	public class SpaceshipStatus extends Sprite 
	{
		
		private var _life:Image;
		
		
		public function SpaceshipStatus() 
		{
			// getting player data 
			// ...
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// There will be blood
			this._life = new Image( Texture.fromColor( 30, 300, 0xffff0000 ) );
			this._life.x = 20;
			this._life.y = 20;
			this.addChild( this._life );
		}
		
		
		
		public function damage( value:Number ):void {
			this._life.scaleY += value;
			this._life.scaleY = this._life.scaleY < 0 ? 0 : this._life.scaleY;
		}
		
		
		
		public function get life():Number 
		{
			return _life.scaleY;
		}
		
	}

}