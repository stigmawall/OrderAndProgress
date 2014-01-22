package engine.gamestates
{
	import engine.backgrounds.BackgroundStar;
	import engine.huds.AnimatedTextField;
	import engine.levels.Level1;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.LineGlitchFilter;
	import starling.filters.ScanlineFilter;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	
	
	/**
	 * The Start Menu
	 * @author Wallace 'Wakko' Morais
	 */
	public class MainMenu extends Sprite 
	{
		private var _container:Sprite;
		
		private var _logo:Image;
		private var _tapToPlay:Image;
		private var _startBtn:MovieClip;
		private var _soundBtn:MovieClip;
		private var _exitBtn:MovieClip;
		private var _tapTimer:Timer;
		private var _muteSoundBtn:MovieClip;
		private var _sureExitBtn:MovieClip;
		private var _retrieveTxt:AnimatedTextField;
		private var _scriptText:AnimatedTextField;
		private var _bg:BackgroundStar;
		
		private var _menu_extra_planets:Image;
		private var _menu_extra_map:Image;
		private var _menu_extra_line:Image;
		private var _menu_extra_line_mask:Shape;
		private var _menu_extra_title_text:Image;
		
		
		// Get all textures
		protected var _textureAtlas:TextureAtlas;
		private var _showStartMenu:Boolean = false;
		private var _scanlineFX:Image;
		
		
		// music loop
		private var _stSfxChannel:SoundChannel;
		private var _stSfx:Sound;
		
		
		// starship 
		private var _ss:Image;
		
		
		
		
		
		public function MainMenu() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		
		
		
		private function init(e:Event):void 
		{
			
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			this._container = new Sprite();
			this.addChild(this._container);
			
			
			
			// scanline fx
			this._scanlineFX = new Image( Texture.fromBitmap( new Resource.SCANLINE_FX() ) );
			this._scanlineFX.touchable = false;
			//this._scanlineFX.visible = false;
			this.addChild( this._scanlineFX );
			
			
			
			// creating starship
			var contentfile:ByteArray = new ByteArray();
			contentfile.writeObject(new Resource.SPRITESHEETXML());
			contentfile.position = 0;
			var contentstr:String = contentfile.readUTFBytes( contentfile.length );
			var _textureAtlas:TextureAtlas = new TextureAtlas( Texture.fromBitmap( new Resource.SPRITESHEET() as Bitmap ), new XML( contentstr.substr(3) ) );
			
			
			
			// create ship image
			_ss = new Image( Texture.fromBitmap( new Resource.SPACESHIP() ) );
			_ss.pivotX = _ss.width / 2;
			_ss.pivotY = _ss.height / 2;
			_ss.scaleX = _ss.scaleY = 20;
			_ss.x = this.stage.stageWidth / 2;
			_ss.y = this.stage.stageHeight / 2;
			_ss.rotation = 0.4;
			
			
			
			// creating bg
			this._bg = new BackgroundStar( this.stage.stageWidth, this.stage.stageHeight );
			//this._bg.alpha = 0;
			this._bg.pivotY = this._bg.y = stage.stageHeight / 2;
			this._bg.scaleY = 0;
			this._container.addChild( this._bg );
			
			
			
			// initing animations
			// menu line and title
			this._menu_extra_line = new Image( Texture.fromBitmap( new Resource.MENU_EXTRA_LINE() as Bitmap ) );
			this._menu_extra_line.y = stage.stageHeight - this._menu_extra_line.height - 60;
			this._menu_extra_line.x = 0;
			this._container.addChild( this._menu_extra_line );
			
			
			
			// mask
			this._menu_extra_line_mask = new Shape();
			this._menu_extra_line_mask.graphics.beginFill(0x000000, 1);
			this._menu_extra_line_mask.graphics.moveTo( 0, this._menu_extra_line.y );
			this._menu_extra_line_mask.graphics.lineTo( this._menu_extra_line.width, this._menu_extra_line.y );
			this._menu_extra_line_mask.graphics.lineTo( this._menu_extra_line.width, this._menu_extra_line.y+this._menu_extra_line.height );
			this._menu_extra_line_mask.graphics.lineTo( 0, this._menu_extra_line.y + this._menu_extra_line.height );
			this._menu_extra_line_mask.graphics.lineTo( 0, this._menu_extra_line.y );
			this._menu_extra_line_mask.graphics.endFill();
			this._container.addChild( this._menu_extra_line_mask );
			
			
			
			// mask animation
			var t99:Tween = new Tween( this._menu_extra_line_mask, 1, Transitions.LINEAR );
			t99.moveTo( this._menu_extra_line.x + this._menu_extra_line.width, 0 );
			t99.onComplete = initialAnimation;
			Starling.juggler.add(t99);
			
			
			
			// Textures
			contentfile = new ByteArray();
			contentfile.writeObject( new Resource.MENUSPRITEXML() );
			contentfile.position = 0;
			contentstr = contentfile.readUTFBytes( contentfile.length );
			this._textureAtlas = new TextureAtlas( Texture.fromBitmap( new Resource.MENUSPRITE() as Bitmap ), new XML( contentstr.substr(3) ) );
			
			
			
			// Intro music
			this._stSfx = new Resource.SOUNDTRACK_INTRO() as Sound;
			this.songLoop(null);
		}
		
		
		
		
		
		
		// initial letters animation
		internal function initialAnimation():void 
		{
			
			// letters
			this._scriptText = new AnimatedTextField( 50, 130, 70, "propulsors... ok\nshield... ok\nenergy boost... ok\nlooking for target...\ntarget locked", 1, "Visitor", 10, 0x00ff00 );
			this._scriptText.x = 5;
			this._scriptText.y = stage.stageHeight - this._menu_extra_line.height - 20;
			this._container.addChild( this._scriptText );
			this._scriptText.startAnimation();
			
			
			
			// map
			this._menu_extra_map = new Image( Texture.fromBitmap( new Resource.MENU_EXTRA_MAP() as Bitmap ) );
			this._menu_extra_map.y = stage.stageHeight - this._menu_extra_map.height;
			this._menu_extra_map.x = ( stage.width / 2 ) - ( this._menu_extra_map.width / 2 ) + 20;
			this._container.addChild( this._menu_extra_map );
			
		
			// map mask
			this._menu_extra_line_mask.dispose();
			this._menu_extra_line_mask = new Shape();
			this._menu_extra_line_mask.graphics.beginFill(0x000000, 1);
			this._menu_extra_line_mask.graphics.moveTo( this._menu_extra_map.x, this._menu_extra_map.y );
			this._menu_extra_line_mask.graphics.lineTo( this._menu_extra_map.x+this._menu_extra_map.width, this._menu_extra_map.y );
			this._menu_extra_line_mask.graphics.lineTo( this._menu_extra_map.x+this._menu_extra_map.width, this._menu_extra_map.y+this._menu_extra_map.height );
			this._menu_extra_line_mask.graphics.lineTo( this._menu_extra_map.x, this._menu_extra_map.y + this._menu_extra_map.height );
			this._menu_extra_line_mask.graphics.lineTo( this._menu_extra_map.x, this._menu_extra_map.y );
			this._menu_extra_line_mask.graphics.endFill();
			this._container.addChild( this._menu_extra_line_mask );
			this._container.addChild( this._menu_extra_line );
			
			
			// maskk animation
			var t99:Tween = new Tween( this._menu_extra_line_mask, 2, Transitions.LINEAR );
			t99.delay = 1.5;
			t99.moveTo(0, 140);
			Starling.juggler.add(t99);
			
			
			
			
			// planet
			this._menu_extra_planets = new Image( Texture.fromBitmap( new Resource.MENU_EXTRA_PLANET() as Bitmap ) );
			this._menu_extra_planets.pivotX = this._menu_extra_planets.width / 2;
			this._menu_extra_planets.pivotY = this._menu_extra_planets.height / 2;
			this._menu_extra_planets.y = stage.stageHeight - ( this._menu_extra_planets.height * .5 );
			this._menu_extra_planets.x = stage.stageWidth - ( this._menu_extra_planets.width * .5 ) - 10;
			this._menu_extra_planets.scaleX = this._menu_extra_planets.scaleY = 0;
			this._container.addChild( this._menu_extra_planets );
			
			
			
			// scale and rotations
			var t98:Tween = new Tween( this._menu_extra_planets, 1, Transitions.LINEAR );
			t98.delay = 3;
			t98.scaleTo(1);
			t98.onComplete = setInitialScreen;
			Starling.juggler.add(t98);
			
			var t97:Tween = new Tween( this._menu_extra_planets, 5, Transitions.LINEAR );
			t97.repeatCount = 0;
			t97.animate( "rotation", 6.3 );
			Starling.juggler.add(t97);
		}
		
		
		
		
		
		
		internal function setInitialScreen():void 
		{
			//this.alpha = 0;
			var t1:Tween = new Tween(this._bg, 0.6, Transitions.EASE_OUT);
			t1.scaleTo(1);
			Starling.juggler.add(t1);
			
			
			
			this._logo = new Image( Texture.fromBitmap( new Resource.LOGO_GAME() as Bitmap ) );
			this._logo.y = 100;
			this._logo.x =  ( this.stage.stageWidth / 2 ) - ( this._logo.width / 2 );
			this._logo.alpha = 0;
			this._container.addChild( this._logo );
			
			
			var t2:Tween = new Tween(this._logo, 1);
			t2.fadeTo(1);
			t2.delay = 1;
			Starling.juggler.add( t2 );
			
			
			this._tapToPlay = new Image( Texture.fromBitmap( new Resource.START_BTN() as Bitmap ) );
			this._tapToPlay.y = 450;
			this._tapToPlay.x =  ( this.stage.stageWidth / 2 ) - ( this._tapToPlay.width / 2 );
			this._tapToPlay.visible = false;
			this._container.addChild( this._tapToPlay );
			
			
			this._tapTimer = new Timer(1000);
			this._tapTimer.addEventListener(TimerEvent.TIMER, blinkTap, false, 0, true );
			this._tapTimer.start();
			
			
			this.stage.addEventListener(TouchEvent.TOUCH, onClickPlayButton);
		}
		
		
		
		
		
		
		
		private function songLoop(object:Object):void 
		{
			this._stSfxChannel = this._stSfx.play();
			//this._stSfxChannel.soundTransform
			this._stSfxChannel.addEventListener( 'soundComplete', songLoop, false, 0, true );
		}
		
		
		
		
		
		
		private function stopSounds():void
		{
			this._stSfxChannel.stop();
			this._stSfxChannel.removeEventListener( 'soundComplete', songLoop );
		}
		
		
		
		
		
		
		private function blinkTap(e:TimerEvent = null):void  {
			this._tapToPlay.visible = !this._tapToPlay.visible;
		}
		
	
		
		
		private function showRetrievingData():void 
		{
			this._retrieveTxt = new AnimatedTextField( 50, 250, 100, "Retrieving data...", 2, "Visitor", 28, 0x00ff00 );
			this._retrieveTxt.addEventListener( Event.COMPLETE, createMainMenu );
			this._retrieveTxt.x = (this.stage.stageWidth/2) - (this._retrieveTxt.width / 2) //170;
			this._retrieveTxt.y = 400;
			this._container.addChild( this._retrieveTxt );
			this._retrieveTxt.startAnimation();
		}
		
		
		
		
		
		
		private function createMainMenu(e:Event):void 
		{
			// remove the retrieving text
			this._container.removeChild( this._retrieveTxt );
			this._retrieveTxt.dispose();
			
			
			// create buttons
			this._startBtn = new MovieClip( this._textureAtlas.getTextures('start'), 10 );
			this._soundBtn = new MovieClip( this._textureAtlas.getTextures('sound'), 10 );
			this._exitBtn = new MovieClip( this._textureAtlas.getTextures('exit'), 10 );
			
			this._muteSoundBtn = new MovieClip( this._textureAtlas.getTextures('mutesound'), 10 );
			this._sureExitBtn = new MovieClip( this._textureAtlas.getTextures('sureexit'), 10 );
			
			
			
			// Positions them
			
			this._startBtn.x = this._exitBtn.x = this._sureExitBtn.x = ( this.stage.stageWidth/2 ) - ( this._startBtn.width/2 );
			this._soundBtn.x = this._muteSoundBtn.x = this._exitBtn.width + this._exitBtn.x + 10;
			this._startBtn.y = 200;
			this._exitBtn.y = this._soundBtn.y = this._sureExitBtn.y = this._muteSoundBtn.y = this._startBtn.y + this._startBtn.height + 10 ;
			
			this._startBtn.pivotY = this._startBtn.height / 2;
			this._exitBtn.pivotY = this._exitBtn.height / 2;
			this._soundBtn.pivotY = this._soundBtn.height / 2;
			this._muteSoundBtn.pivotY = this._soundBtn.height / 2;
			this._sureExitBtn.pivotY = this._soundBtn.height / 2;
			
			this._startBtn.scaleY = 0;
			this._soundBtn.scaleY = 0;
			this._exitBtn.scaleY = 0;
			
			
			
			// Animate then
			
			var t2:Tween = new Tween(this._startBtn, 0.2, Transitions.EASE_OUT);
			t2.animate('scaleY', 1);
			var t3:Tween = new Tween(this._soundBtn, 0.2, Transitions.EASE_OUT);
			t3.delay = 0.4;
			t3.animate('scaleY', 1);
			var t4:Tween = new Tween(this._exitBtn, 0.2, Transitions.EASE_OUT);
			t4.delay = 0.2;
			t4.animate('scaleY', 1);
			
			this._container.addChild( this._startBtn );
			this._container.addChild( this._soundBtn );
			this._container.addChild( this._exitBtn );
			
			Starling.juggler.add( this._startBtn );
			Starling.juggler.add( this._soundBtn );
			Starling.juggler.add( this._exitBtn );
			Starling.juggler.add( this._muteSoundBtn );
			Starling.juggler.add( this._sureExitBtn );
			
			Starling.juggler.add(t2);
			Starling.juggler.add(t3);
			Starling.juggler.add(t4);
		}
		
		
		
		
		
		private function onClickPlayButton(e:TouchEvent):void 
		{
			var touch:Touch;
			
			if ( !this._showStartMenu )
			{
				touch = e.getTouch( this.stage );
				if ( touch && touch.phase == TouchPhase.BEGAN ) 
				{
					_showStartMenu = true;
					this._tapTimer.removeEventListener(TimerEvent.TIMER, blinkTap, false );
					this._tapTimer.stop();
					
					this._container.removeChild( this._logo );
					this._container.removeChild( this._tapToPlay );
					this.showRetrievingData();
					//this.createMainMenu();
				}
			}
			else 
			{
				// check strat button
				touch = e.getTouch( this._startBtn );
				if ( touch && touch.phase == TouchPhase.BEGAN ) 
				{
					stopSounds();
					var flying:Sound = new Resource.STARSHIP_FLYING() as Sound;
					flying.play();
					this.showStarshipAnimation();
				}
				
				// Check sound button
				touch = e.getTouch( this._soundBtn );
				if ( touch && touch.phase == TouchPhase.BEGAN ) 
				{
					this._container.removeChild( this._soundBtn );
					this._container.addChild( this._muteSoundBtn );
					SoundMixer.soundTransform = new SoundTransform(0);
				}
				
				// Check sound mute button
				touch = e.getTouch( this._muteSoundBtn );
				if ( touch && touch.phase == TouchPhase.BEGAN ) 
				{
					this._container.removeChild( this._muteSoundBtn );
					this._container.addChild( this._soundBtn );
					SoundMixer.soundTransform = new SoundTransform(1);
				}
				
				// Check exit button
				touch = e.getTouch( this._exitBtn );
				if ( touch && touch.phase == TouchPhase.BEGAN ) 
				{
					this._container.removeChild( this._exitBtn );
					this._container.addChild( this._sureExitBtn );
				}
				
				// Check sure exit button
				touch = e.getTouch( this._exitBtn );
				if ( touch && touch.phase == TouchPhase.BEGAN ) 
				{
					// go out the app
				}
			}
		}
		
		
		
		
		private function showStarshipAnimation():void 
		{
			
			// remove itens
			this._container.removeChild( this._menu_extra_line );
			this._container.removeChild( this._menu_extra_line_mask );
			this._container.removeChild( this._menu_extra_map );
			this._container.removeChild( this._menu_extra_planets );
			this._container.removeChild( this._scriptText );
			
			
			// Remove the buttons
			this._container.removeChild( this._menu_extra_planets );
			this._container.removeChild( this._startBtn );
			this._container.removeChild( this._soundBtn.stage ? this._soundBtn : this._muteSoundBtn );
			this._container.removeChild( this._exitBtn.stage ? this._exitBtn : this._sureExitBtn );
			this._container.removeChild( this._bg );
			
			
			// this._container.filter.dispose();
			// this._container.filter = null;
			
			
			this.removeChild( this._scanlineFX );
			this.removeChild( this._container );
			
			
			Starling.juggler.remove( this._startBtn );
			Starling.juggler.remove( this._soundBtn );
			Starling.juggler.remove( this._exitBtn );
			Starling.juggler.remove( this._muteSoundBtn );
			Starling.juggler.remove( this._sureExitBtn );
			
			Starling.juggler.removeTweens( this._menu_extra_planets );
			Starling.juggler.removeTweens( this._menu_extra_line_mask );
			
			
			this.addChild( _ss );
			
			
			// generate animations
			var t1:Tween = new Tween( _ss, 3, Transitions.EASE_OUT );
			t1.scaleTo(0);
			t1.animate('rotation', -0.6);
			var t2:Tween = new Tween( _ss, 1.5, Transitions.EASE_OUT );
			t2.animate('x', 100);
			var t3:Tween = new Tween( _ss, 1.5, Transitions.EASE_IN );
			t3.delay = 1.5;
			t3.animate('x', 420);
			t3.animate('y', 300);
			
			t1.onComplete = Main.INSTANCE.switchState;
			t1.onCompleteArgs = [ Level1 ];
			//t1.onComplete = Main.INSTANCE.switchState;
			//t1.onCompleteArgs = [ Level1 ];
			
			Starling.juggler.add( t1 );
			Starling.juggler.add( t2 );
			Starling.juggler.add( t3 );
		}
		
		
		
		override public function dispose():void 
		{
			Starling.juggler.purge();
			this._stSfx = null;
			this._stSfxChannel = null;
			this._ss.dispose();
			this._logo.dispose();
			this._tapToPlay.dispose();
			this._startBtn.dispose();
			this._soundBtn.dispose();
			this._exitBtn.dispose();
			this._muteSoundBtn.dispose();
			this._sureExitBtn.dispose();
			this._retrieveTxt.dispose();
			this._bg.dispose();
			this._textureAtlas.dispose();
			super.dispose();
		}
		
	}

}