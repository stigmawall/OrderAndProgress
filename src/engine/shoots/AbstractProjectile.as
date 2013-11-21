package engine.shoots 
{
	import starling.animation.IAnimatable;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	
	/**
	 * Abstract DisplayObject to show shots and projectiles and xoxotas :)
	 * @author ...
	 */
	public class AbstractProjectile extends MovieClip
	{
		
		public function AbstractProjectile( textures:Vector.<Texture>, fps:Number ) 
		{
			super(textures, fps);
		}
		
		
	}

}