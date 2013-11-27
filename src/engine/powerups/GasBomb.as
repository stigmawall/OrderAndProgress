package engine.powerups 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * Gas bom - pulverize gas upon the people
	 * @author Wallace 'Wakko' Morais
	 */
	public class GasBomb extends Sprite 
	{
		
		private var _icon:Image;
		
		
		public function GasBomb() 
		{
			super();
			this._icon = new Image( new Texture.fromBitmap( new Resource.GAS_BOMB ) );
			this.addChild( this._icon );
		}  
		
	}

}