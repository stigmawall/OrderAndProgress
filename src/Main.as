package 
{
	import engine.gamestates.Cinematic;
	import engine.gamestates.Game;
	import engine.gamestates.IntroFireHurricane;
	import engine.gamestates.MainMenu;
	import engine.huds.Console;
	import engine.levels.Level1;
	import engine.shoots.*;
	import engine.gamestates.Game;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.net.registerClassAlias;
	import flash.utils.getQualifiedClassName;
	
	import starling.events.Event;
	import starling.core.Starling;
	import starling.events.ResizeEvent;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	

	
	//[SWF(width = "640", height = "960", frameRate="60", backgroundColor = "#000000")]
	public final class Main extends Sprite
	{
		
		static private var _INSTANCE:Main;
		
		private var _starling:Starling;
		
		
		
		
		public function Main():void 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			this.switchState( Level1 ); // IntroFireHurricane // MainMenu
			_INSTANCE = this;
			
			Console.init(false);
			stage.addEventListener( "deactivate", deactivate,false,0,true);
			//NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, deactivate);
		}
		
		
		
		
		private function deactivate( e:Object ):void 
		{
			stage.removeEventListener( "deactivate", deactivate );
			//NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, deactivate);
			
			//this._starling.stop();
			//this._starling.dispose();
			_INSTANCE = null;
			NativeApplication.nativeApplication.exit();
		}
		
		
		

		private function init(e:Event):void 
		{
			// Setting fonts
			// Visitor font
			var texture:Texture = Texture.fromBitmap( new Resource.VISITORFONTTEXTURE() );
			var xml:XML = XML( new Resource.VISITORFONTXML() );
			TextField.registerBitmapFont( new BitmapFont(texture, xml) );
		}
		
		
		
		
		
		public function switchState( $state:Class, $args:Object=null ):void
		{
			if (_starling)
			{
				//Starling.handleLostContext = true;
				_starling.stop();
				_starling.dispose();
				_starling = null;
			}
			
			
			
			Starling.multitouchEnabled = true;
			_starling = new Starling($state, stage, null, null, "auto", "baseline"); //"baseline"
			//_starling.simulateMultitouch = true;
			_starling.stage.addEventListener(ResizeEvent.RESIZE, onResized);
			//stage.addEventListener(ResizeEvent.RESIZE, resizeStage);
			
			
			
			//_starling.showStats = true;
			//_starling.showStatsAt('right');
			
			
			if ( $args ) {
				Cinematic.fileName = $args.fileName;
				Cinematic.className = $args.className;
			}
			
			
			// android settings
			//_starling.stage.stageWidth = 640;
			//_starling.stage.stageHeight = 960;
			_starling.start();
			//onResized(null);
		}
		
		
		
		
		private function onResized(e:ResizeEvent):void
		{
			RectangleUtil.fit(
			  new Rectangle(0, 0, stage.stageWidth, stage.stageHeight),
			  new Rectangle(0, 0, stage.stageWidth, stage.stageHeight),
			  ScaleMode.SHOW_ALL, false,
			  Starling.current.viewPort
		   );
		   
		   _starling.stage.removeEventListener(ResizeEvent.RESIZE, onResized);
		}
		
		
		
		static public function get INSTANCE():Main 
		{
			return _INSTANCE;
		}
		
	}
}