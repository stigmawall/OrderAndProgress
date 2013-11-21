package engine.gamestates
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.animation.Transitions;
	import starling.textures.Texture;
	
	/**
	 * Intro for Main logo
	 * @author Wallace 'Wakko' Morais
	 */
	public class IntroFireHurricane extends Sprite 
	{
		
		private var _logo:Image;
		
		
		public function IntroFireHurricane() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var _self:IntroFireHurricane = this;
			
			
			var _logo:Image = new Image( Texture.fromBitmap( new Resource.INTRO_FIREHURRICANE() as Bitmap ) );
			this.addChild(_logo);
			this.alpha = 0;
			_logo.width = Starling.current.stage.stageWidth;
			_logo.height = Starling.current.stage.stageHeight;
			
			var t1:Tween= new Tween(this, 1.0, Transitions.EASE_IN_OUT);
			t1.fadeTo(1);    // equivalent to 'animate("alpha", 0)'
			
			var t2:Tween = new Tween(this, 1.0, Transitions.EASE_IN_OUT);
			t2.delay = 3;
			t2.fadeTo(0);
			t2.onComplete = Main.INSTANCE.switchState;
			t2.onCompleteArgs = [MainMenu];
			
			Starling.juggler.add( t1 );
			Starling.juggler.add( t2 );
		}
		
	}

}