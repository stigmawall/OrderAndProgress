package engine.gamestates
{
	import engine.backgrounds.BackgroundStar;
	import engine.display.DisplayObjectPlus;
	import engine.huds.AnimatedTextField;
	import engine.huds.FinalLevelScreen;
	import engine.huds.Message;
	import engine.huds.ShootTarget;
	import engine.planets.Kamikase;
	import engine.planets.Planet;
	import engine.shoots.AbstractFirewors;
	import engine.shoots.AbstractProjectile;
	import engine.shoots.Fireworks;
	import engine.shoots.Rocket;
	import engine.shoots.Shoot;
	import engine.shoots.TripleFireworks;
	import engine.spaceships.Spaceship;
	import starling.events.EnterFrameEvent;
	
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	
	import starling.filters.BlurFilter;
	import starling.filters.NewsprintFilter;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	
	
 
    public class Game extends Sprite 
	{
		// main game instance
		static protected var _INSTANCE:Game;
		
		
		
		// level configuration - generic values
		public var level:Class = Game;
		public var levelName:String = "Engine Level";
		public var backgroundColor:uint = 0x00ff00;
		public var planetWeapons:Array = [ Fireworks ];
		public var weaponsPercentage:Array = [ 1 ];
		public var turn:uint = 180;
		public var min_atk_turn:uint = 1;
		public var max_atk_turn:uint = 2;
		public var nextLevel:String;
		public var nextLevelClass:Class;
		public var nextLevelArgs:Object;
		
		
		
		// Enemy configuration
		public var planetAsset:Class;
		public var genericCharAsset1:Class;
		public var genericCharAsset2:Class;
		
		
		
		// Game objects
		protected var _bg:BackgroundStar;
		protected var _bgAtmosfere:Image;
		protected var _spaceship:Spaceship;
		protected var _planet:Planet;
		
		
		
		// Hud stuff
		protected var _gameOverScreen:MovieClip;
		protected var _messages:Dictionary;
		protected var _container:Camera;
		protected var _scanlineFX:Image;
		protected var _tvFX:Image;
		protected var _startText:AnimatedTextField;
		protected var _skipButton:Image;
		protected var _pauseButton:Image;
		protected var _playButton:Image;
		protected var _targets:Vector.<ShootTarget>
		
		
		
		// Sound stuff
		protected var _stSfx:Sound;
		protected var _stSfxChannel:SoundChannel;
		
		
		
		// Controls
		protected var _canShoot:Boolean;
		protected var _canRefresh:Boolean;
		protected var _gameRunning:Boolean;
		protected var _isGameOver:Boolean;
		protected var _randomTalk:Boolean;
		protected var _time:Timer;
		protected var _paused:Boolean;
		
		
		
		// Get all textures
		protected var _textureAtlas:TextureAtlas;
		
		
		
		
		public function Game()
		{			
			this._canShoot = false;
			this._canRefresh = false;
			this._isGameOver = false;
			this._randomTalk = false;
			this._gameRunning = false;
			this._targets = new Vector.<ShootTarget>();
			_INSTANCE = this;
			
			
			//this.level = "levels/level1/level" + Settings.level + ".lua";
			this._messages = new Dictionary(true);
			
			
			// Out with the sound
			SoundMixer.soundTransform = new SoundTransform(0.1);
			
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			//this._gameEvents = new EventsControl( this.level );
			//this._gameEvents.addEventListener(Event.COMPLETE, init);
        }
		
		
		
		
		
		
		protected function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			// Level configuration
			//this._gameEvents.run( EventsControl.INIT );
			
			
			// Background
			//this.alpha = 0; 
			this._bg = new BackgroundStar( this.stage.stageWidth, this.stage.stageHeight * 2, 0, -this.stage.stageHeight, this.backgroundColor );
			this.addChild( this._bg );	
			
			
			// main container
			this._container = new Camera();
			this.addChild( this._container );
			//Starling.juggler.tween( this, 2, { alpha:1 } );
			//this._container.scaleX = this._container.scaleY = 2;
			
			
			
			// Textures
			var contentfile:ByteArray = new ByteArray();
			contentfile.writeObject(new Resource.SPRITESHEETXML());
			contentfile.position = 0;
			var contentstr:String = contentfile.readUTFBytes( contentfile.length );
			this._textureAtlas = new TextureAtlas( Texture.fromBitmap( new Resource.SPRITESHEET() as Bitmap ), new XML( contentstr.substr(3) ) );
			
			
			// Spaceship 
			this._spaceship = new Spaceship();
			
			
			
			// planet asset
			if ( !this.planetAsset ) this.planetAsset = Resource.LEVEL1;
			
			// people assets
			var textures:Vector.<Texture> = new Vector.<Texture>();
			if ( !this.genericCharAsset1 ) genericCharAsset1 = Resource.CHAR_ANIM1;
			if ( !this.genericCharAsset2 ) genericCharAsset2 = Resource.CHAR_ANIM2;
			textures.push( Texture.fromBitmap( new this.genericCharAsset1() ) );
			textures.push( Texture.fromBitmap( new this.genericCharAsset2() ) );
			
			
			// Planet settings
			this._planet = new Planet( this.planetAsset, textures, this.planetWeapons, this.weaponsPercentage, this.turn, this.min_atk_turn, this.max_atk_turn );
			
			
			// set next level
			//this.nextLevelClass = getDefinitionByName( this.nextLevel ) as Class;
			
			
			// on screen
			this._container.addChild(this._spaceship);
			this._container.addChild( this._planet );
					
			
			// Sounds
			//this._stSfx = new Resource.SOUNDTRACK_SFX() as Sound;
			//this.songLoop(null);
			
			
			// scanline fx
			this._scanlineFX = new Image( Texture.fromBitmap( new Resource.SCANLINE_FX() ) );
			this._scanlineFX.touchable = false;
			this.addChild( this._scanlineFX );
			
			
			
			// tv effect
			this._tvFX = new Image( Texture.fromBitmap( new Resource.TVFX() ) );
			this._tvFX.touchable = false;
			this.addChild( this._tvFX );
			
			
			
			
			// layers
			this._container.addLayer( this._bg, .5 );
			// camera settings
			this._container.goto(0, -this.stage.stageHeight);
			
			
			
			// Level info
			this._startText = new AnimatedTextField( 80, 250, 100, this.levelName, 1, "Visitor", 28, 0x00ff00 );
			this._startText.x = (this.stage.stageWidth/2) - (this._startText.width / 2);
			this._startText.y = -this._container.y + 400;
			this._container.addChild( this._startText );
			this._startText.startAnimation('center');
			
			
			
			// initial camera animation
			this._container.goto(0, 0, true, 6, 1, beginInteractivity );
		}
		
		
		
		
		
		protected function beginInteractivity():void 
		{
			//this._container.ativeHand(); 
			this._container.removeChild( this._startText ); 
			this._startText.dispose();
			
			
			//this._gameRunning = true;
			//this._planet.setPlanetBehavior( Kamikase.WALK );
			
			
			// pause/play menu
			this._pauseButton = new Image( Texture.fromColor( 100, 40, 0xffff0000 ) );
			this._playButton = new Image( Texture.fromColor( 100, 40, 0xff00ff00 ) );
			this._playButton.visible = false;
			this._playButton.x = this._pauseButton.x = stage.stageWidth - this._pauseButton.width - 18;
			this._playButton.y = this._pauseButton.y = 20;
			this._playButton.addEventListener( TouchEvent.TOUCH, onPlayPause );
			this._pauseButton.addEventListener( TouchEvent.TOUCH, onPlayPause );
			
			
			
			
			// skip button
			this._skipButton = new Image( Texture.fromColor( 100, 40, 0xff00ff00 ) );
			this._skipButton.x = (stage.stageWidth / 2) - ( this._skipButton.width / 2 );
			this._skipButton.y = 20;
			this.addChild( this._skipButton );
			
			
			// Listeners 
			this.addEventListener(Event.ENTER_FRAME, update);
			this.stage.addEventListener(TouchEvent.TOUCH, onTouchScreen );
			
			
			// Event control
			//this._gameEvents.run( EventsControl.BEGIN );
		}
		
		
		
		
		// play/pause buttons
		private function onPlayPause(e:TouchEvent):void 
		{
			if ( e.getTouch( this._pauseButton, TouchPhase.BEGAN ) ) {
				this._pauseButton.visible = false;
				this._playButton.visible = true;
				//Starling.current.stop();
				this._paused = true;
				this.removeEventListener(EnterFrameEvent.ENTER_FRAME, update);
			}
			
			if ( e.getTouch( this._playButton, TouchPhase.BEGAN ) ) {
				this._pauseButton.visible = true;
				this._playButton.visible = false;
				//Starling.current.start();
				this._paused = false;
				this.addEventListener(EnterFrameEvent.ENTER_FRAME, update);
			}
		}
		
		
		
		
		protected function startGame():void 
		{
			//remove o botão skip
			if ( this._skipButton.stage ) this.removeChild( this._skipButton );
			
			// here we start the game
			this.gameRunning = true;
			this.planet.planetAttacking = true;
			this.planet.setPlanetBehavior( Kamikase.RUN );
			this.spaceship.attacking = true;
			this.canShoot = true;
			this.canRefresh = true;
			
			this.addChild( this._pauseButton );
			this.addChild( this._playButton );
		}
		
		
		
		
		
		
		protected function songLoop(object:Object):void 
		{
			this._stSfxChannel = this._stSfx.play();
			//this._stSfxChannel.soundTransform
			this._stSfxChannel.addEventListener( 'soundComplete', songLoop, false, 0, true );
		}
		
		
		
		
		
		
		protected function stopSounds():void
		{
			if ( this._stSfxChannel ) 
			{
				this._stSfxChannel.stop();
				this._stSfxChannel.removeEventListener( 'soundComplete', songLoop );
			}
		}
		
		
		
		
		
		
		protected function onTouchScreen(e:TouchEvent):void 
		{
			if ( this._paused ) return;
			
			
			var msg:Message;
			var touches:Vector.<Touch>;
			touches = e.getTouches( this.stage );
			
			
			if (touches.length == 0) return;
			
			
			// if the game is not running
			if ( !this._gameRunning ) 
			{
				// if click on skip button, go to game
				var t:Touch = e.getTouch( this._skipButton );
				if ( t && t.phase == TouchPhase.BEGAN ) 
				{
					for each( msg in this._messages ) {
						msg.finish(false);
						msg.dispose();
					}
					
					this.startGame();
				}
				
				
				// if have messages to pass, pass it
				if ( touches[0] && touches[0].phase == TouchPhase.BEGAN ) {
					
					for each( msg in this._messages ) 
					{
						if ( msg.alive ) {
							msg.finish();
							break;
						} else {
							msg.dispose();
							break;
						}
					}
				}	
			} else {
						
				// multitouch
				for each( var touch:Touch in touches )
				{
					//Game issues
					
					
					// check if mouse is on, them create a target
					if ( touch && _canShoot && touch.phase == TouchPhase.BEGAN && !this._isGameOver && touch.globalY > 190 ) {
						var tcc:ShootTarget = new ShootTarget( touch );
						this._targets.push( tcc );
						this._container.addChild( tcc );
					}
					
					
					
					// check if mouse is out, them shoot
					if ( touch && _canShoot && touch.phase == TouchPhase.ENDED && !this._isGameOver && touch.globalY > 190 ) 
					{
						// set the target to the shoot and
						// remove the target from that finger
						var tc:ShootTarget;
						for ( var stc:uint = 0; stc < this._targets.length; stc++ ) 
						{
							tc = this._targets[ stc ];
							if ( tc.touch.id == touch.id ) {
								tc.animate();
								this._targets.splice( stc, 1 );
								break;
							}
						}
						
						this._spaceship.shoot( ( ( touch.globalX / this._container.scaleX < this.stage.stageWidth / 2 ) ? 0 : 1 ), 
												   tc.x, tc.y, tc );
					}
					
					
					// check if the player is refhreshing the cannons
					//touch = e.getTouch( this.spaceship.cannon1, TouchPhase.MOVED );
					if	( touch && _canRefresh && touch.phase==TouchPhase.MOVED &&
						( touch.globalY / this._container.scaleY ) < this.spaceship.cannon1.y + this.spaceship.cannon1.height &&
						( touch.globalX / this._container.scaleX ) < this.stage.stageWidth / 2 ) 
					{ this.spaceship.refresh( "_cannon1" ); }
					
					//touch = e.getTouch( this.spaceship.cannon2, TouchPhase.MOVED );
					if	( touch && _canRefresh && touch.phase==TouchPhase.MOVED &&
						(  touch.globalY / this._container.scaleY ) < this.spaceship.cannon2.y + this.spaceship.cannon2.height &&
						( touch.globalX / this._container.scaleX ) > this.stage.stageWidth / 2 )
					{ this.spaceship.refresh( "_cannon2" ); }
					
				}
			}
		}
		
		
		
		
		
		public function clean():void 
		{
			_INSTANCE = null;
			
			// remove listeners
			this.removeEventListener(Event.ENTER_FRAME, update);
			this.stage.removeEventListener(TouchEvent.TOUCH, onTouchScreen );
			
			this._bg.dispose();
			this._spaceship.dispose();
			this._planet.dispose();
			this._container.dispose();
			Starling.juggler.purge();
			
			for each( var m:Message in this._messages ) m.dispose();
			this._messages = null;
			this.dispose();
		}
		
		
		
		
		
		
		public function playerWin():void 
		{			
			stopSounds();
			this.removeTargets();
			this._spaceship.clearShoots();
			this._planet.clearShoots();
			this._planet.explode( null );
			this.removeChild( this._playButton );
			this.removeChild( this._pauseButton );
			this._playButton.removeEventListener(TouchEvent.TOUCH, onPlayPause);
			this._pauseButton.removeEventListener(TouchEvent.TOUCH, onPlayPause);
			
			this._container.ativeHand( 48, 0.1 );
			this._isGameOver = true;
			this._container.filter = new NewsprintFilter(0, 0, 0);
			
			
			// move the camera to top 
			//Starling.juggler.tween( this._container, 2, { y:this._container.y + 300, delay:2, onComplete:function():void 
			Starling.juggler.delayCall( function():void 
			{
				// stop the laser and the effect
				_spaceship.stopLaserCannon();
				_container.deactiveHand();
				_container.filter.dispose();
				_container.filter = null;
				
				
				// make spaceship go out
				//Starling.juggler.tween( _spaceship, 3, { y:-_spaceship.height-300 } ); // menos 300 do mov da camera
				
				
				// call final level screen
				var fls:FinalLevelScreen = new FinalLevelScreen();
				addChild( fls );
				addChild( _scanlineFX );
				addChild( _tvFX );
			}, 2);
		}
		
		
		
		
		public function gameOver():void
		{	
			stopSounds();
			this.removeTargets();
			this._isGameOver = true;
			this._spaceship.clearShoots();
			this._planet.clearShoots();
			this._container.ativeHand( 48, 0.1 );
			
			this.removeChild( this._playButton );
			this.removeChild( this._pauseButton );
			this._playButton.removeEventListener(TouchEvent.TOUCH, onPlayPause);
			this._pauseButton.removeEventListener(TouchEvent.TOUCH, onPlayPause);
			
			this._spaceship.explode( function():void 
			{
				_container.deactiveHand();
				
				// call final level screen
				var fls:FinalLevelScreen = new FinalLevelScreen(false);
				addChild( fls );
				addChild( _scanlineFX );
				addChild( _tvFX );
			} );
		}
		
		
		
		
		
		
		public function createMessage( $head:Class, $message:String, $direction:uint, $time:Number, $coroutine:Function = null ):void
		{
			var m:Message = new Message( $head, $message, $direction, $time, 'normal', $coroutine );
			m.name = new Date().getTime() + '_' + Math.random();
			this._messages[ m.name ] = m;
			this.addChild( m );
		}
		
		
		
		
		
		protected function update(e:Event):void 
		{
			if ( this._isGameOver ) return;
			
			
			// update the planet
			this._planet.update();
			
			
			// update the messages (if have it)
			for each( var m:Message in this._messages ) {
				m.update();
			}
			
			
			// if the game is not running, jump this part
			if ( !this._gameRunning ) return;
			
			
			
			// update the spaceship
			this._spaceship.update();
			
			
			 
			// update the shoots
			for each( var ss:Shoot in this._spaceship.shoots ) {
				for each( var ps:DisplayObjectPlus in this.planet.shoots ) {
					if ( ss.arrived && !ps.arrived && ss.explosion.getBounds( this.container ).intersects( new Rectangle( ps.x, ps.y, 5, 5 ) ) ) {
						ps.explode();
					}
				}
			}
			
			
			
			// update the targets
			for each( var tgs:ShootTarget in this._targets ) {
				tgs.update();
			}
			
			
			
			/* old random messages
			// Generate new random messages
			var kN:uint = Math.floor( Math.random() * this._planet.kamikases.length );
			
			
			// If this kamikase is already talk, skip
			if ( Math.random() > 0.99 && this._planet.kamikases.length > 0 && !this._planet.kamikases[kN].talking && this._randomTalk )
			{
				var msgN:uint = Math.floor( Math.random() * this._randomMessages.length );
				this.createMessage( this._planet.kamikases[ kN ], this._randomMessages[ msgN ][0], this._randomMessages[ msgN ][1] );
			}
			*/
			
			
			// update camera
			//this._container.update();
			
			
			
			// Event control
			//this._gameEvents.run( EventsControl.UPDATE );
		}
		
		
		
		
		public function wait( $time:int, $function:Function ):void
		{
			var t:Timer = new Timer( $time, 1 );
			t.addEventListener( TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
				$function();
			}, false, 0, true );
			t.start();
		}
		
		
		
		
		protected function removeTargets():void {
			for each( var tgt:ShootTarget in this._targets ) {
				tgt.parent.removeChild( tgt );
				tgt = null;
			}
			this._targets = null;
		}
		
		
		
		
		
		public function get spaceship():Spaceship 
		{
			return _spaceship;
		}
		
		public function get planet():Planet 
		{
			return _planet;
		}
		
		static public function get INSTANCE():Game 
		{
			return _INSTANCE;
		}
		
		public function get textureAtlas():TextureAtlas 
		{
			return _textureAtlas;
		}
		
		public function get messages():Dictionary 
		{
			return _messages;
		}
		
		public function get container():Camera 
		{
			return _container;
		}
		
		
		public function get gameRunning():Boolean {
			return this._gameRunning;
		}
		
		public function set gameRunning( value:Boolean ):void {
			this._gameRunning = value;
		}
		
		public function get canRefresh():Boolean 
		{
			return _canRefresh;
		}
		
		public function set canRefresh(value:Boolean):void 
		{
			_canRefresh = value;
		}
		
		public function get canShoot():Boolean 
		{
			return _canShoot;
		}
		
		public function set canShoot(value:Boolean):void 
		{
			_canShoot = value;
		}
    }
	
}
