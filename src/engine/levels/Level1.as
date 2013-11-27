package engine.levels 
{
	import adobe.utils.CustomActions;
	import engine.gamestates.Game;
	import engine.huds.AnimatedTextField;
	import engine.planets.Kamikase;
	import engine.shoots.Fireworks;
	import engine.shoots.GasBomb;
	import engine.shoots.Rocket;
	import engine.shoots.TripleFireworks;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Wallace 'Wakko' Morais
	 */
	public final class Level1 extends Game 
	{
		
		private var _tapHere:Image;
		
		private var _swipeHere:MovieClip;
		
		private var _tapTimes:uint = 0;
		
		private var _planetCerca:Image;
		
		private var _torre1:Image;
		
		private var _torre2:Image;
		
		
		
		
		
		public function Level1() 
		{
			// start everything before init
			// you can ser vars here
			
			// Initial vars and config
			// important note: to set the weapons percentage, set it to more common to more rare, and align it with the weapons
			// the weight is in percentage divided by 100
			
			// implement itens
			// implement day/night
			// implement music
			super();
	
			// name and color settings
			this.levelName = "Level 1\nThe Prison";
			this.backgroundColor = 0x1f2533;
			this.level = Level1;
			
			// weapons, use percentage, ballancing
			this.planetWeapons = [ GasBomb ] //[ Fireworks, TripleFireworks, Rocket ];
			this.weaponsPercentage = [ 1 ]; //[ 0.6, 0.1, 0.1 ];
			this.turn = 180;
			this.min_atk_turn = 1;
			this.max_atk_turn = 2;
			
			
			// planet and chars assets
			this.planetAsset = Resource.LEVEL1;
			this.genericCharAsset1 = Resource.CHAR_ANIM1;
			this.genericCharAsset2 = Resource.CHAR_ANIM2;
		}
		
		
		
		
		
		
		/**
		 * Setting cinematic
		 */
		
		override protected function init(e:Event):void 
		{
			if ( !Settings.firstLevelMainCinematic )
			{			
				var initialTxt:AnimatedTextField = new AnimatedTextField( 80, stage.stageWidth, 120, 
				"What happens if the eviction process was less bureaucratic to business?\n\nYear 2113 ", 1, "Visitor", 28, 0x00ff00 );
				
				initialTxt.x = (this.stage.stageWidth/2) - (initialTxt.width / 2);
				//initialTxt.y = -this._container.y + 400;
				initialTxt.y = (this.stage.stageHeight/2) - 100;
				this.addChild( initialTxt );
				initialTxt.startAnimation('center');
				initialTxt.addEventListener( Event.COMPLETE, startCinematic);
				
				Settings.firstLevelMainCinematic = true;
				
				// you can do things before the initiation
				//super.init(e);
			} else
				startInit(null);
		}
		
		
		
		
		private function startCinematic(e:Event):void 
		{
			var c:AnimatedTextField = e.currentTarget as AnimatedTextField;
			c.removeEventListener( Event.COMPLETE, startCinematic );
			this.wait( 2000, function():void 
			{ 	
				Starling.juggler.tween( c, 1, { alpha:0, onComplete:function():void 
				{
					removeChild( c );
					c.dispose();
					
					var cinematic:Image = new Image( Texture.fromBitmap( new Resource.CINEMATIC_LEVEL1 ) );
					cinematic.alpha = 0;
					addChild( cinematic );
					Starling.juggler.tween( cinematic, 0.5, { alpha:1 } );
					cinematic.addEventListener(TouchEvent.TOUCH, onTouchCinematic);
				} } );
			});
		}
		
		
		private function onTouchCinematic(e:TouchEvent):void 
		{
			var c:Image = e.currentTarget as Image;
			var t:Touch = e.getTouch( c );
			
			if ( t && t.phase == TouchPhase.BEGAN ) {
				c.removeEventListener(TouchEvent.TOUCH, onTouchCinematic);
				Starling.juggler.tween( c, 0.5, { alpha:0, onComplete:startInit, onCompleteArgs:[ c ] } );
			}
		}
		
		
		private function startInit( c:Image ):void 
		{
			if( c ) this.removeChild( c );
			super.init(null);
			
			// extra assets
			this._torre1 = new Image( Texture.fromBitmap( new Resource.LEVEL1_TORRE() ) );
			this._torre2 = new Image( Texture.fromBitmap( new Resource.LEVEL1_TORRE() ) );
			
			
			this._torre1.x = -60;
			this._torre2.x = stage.stageWidth-60;
			this._torre1.y = this._torre2.y = stage.stageHeight - 250;
			this._container.addChild( this._torre1 );
			this._container.addChild( this._torre2 );
			
			this._planetCerca = new Image(  Texture.fromBitmap( new Resource.LEVEL1_CERCA ) );
			this._planetCerca.y = this.stage.stageHeight - this._planetCerca.height - 18;
			this.planet.addChild( this._planetCerca );
		}
		
		
		
		
		
		
		/**
		 * In-game cinematic
		 */
		
		override protected function beginInteractivity():void 
		{
			// you can do things after the interactivity - before the start animation
			super.beginInteractivity();
			
			
			// game.container.deactiveHand()
			// game.container.zoom(3,0)
			// game.container.goto(-650,-1900)
			// game.container.activeHand()
			// game.wait( 1000, function() 
			
			// referencia do game
			var game:Game = this;
			
			
			// start conversation
			game.createMessage( Resource.CORONELHEAD, "Alright rookie, you know how it works here, right?", 0, 0, function():void {
			game.createMessage( Resource.NEWBIEHEAD, "Right, we have to clean this area for our client!", 1, 0, function():void {
			game.createMessage( Resource.CORONELHEAD, "Exactly! First, you can aim that target to warm up our auxiliar cannons!", 0, 0, function():void {
			game.createMessage( Resource.NEWBIEHEAD, "Yes sir!", 1, 0, function():void {
			
			
			// inicia tutorial de como disparar - cria a imagem
			game.gameRunning = true;
			_skipButton.visible = false;
			_tapHere = new Image( Texture.fromBitmap( new Resource.TUTORIAL_TAP ) );
			_tapHere.x = 160 - ( _tapHere.width / 2 );
			_tapHere.y = 480 - ( _tapHere.height / 2 );
			//game.container.addChild( _tapHere )
			game.addChild( _tapHere );
			
			
			// cria o evento para o disparo
			_tapHere.addEventListener(TouchEvent.TOUCH, function(ev1:TouchEvent):void {
			var t:Touch = ev1.getTouch( _tapHere );
			if ( !t || t.phase!=TouchPhase.BEGAN ) return;
			_tapHere.removeEventListener( TouchEvent.TOUCH, arguments.callee );
			
			
			// dispara o tiro
			spaceship.shoot( ( ( t.globalX / game.container.scaleX < stage.stageWidth / 2 ) ? 0 : 1 ), 
												   t.globalX / game.container.scaleX, 
												   t.globalY / game.container.scaleY );
			
			// ao disparar o primeiro tiro, espera um pouco
			game.wait(1000, function():void { 
			game.gameRunning = false;
			_skipButton.visible = true;
			game.createMessage( Resource.CORONELHEAD, "Good, but i ordered to warm up the cannon! Shoot more!", 0, 0, function():void {
			
			
			// prepara para sequencia de tiros
			game.gameRunning = true;
			_skipButton.visible = false;
			_tapHere.addEventListener(TouchEvent.TOUCH, function(ev1:TouchEvent):void {	
			var t:Touch = ev1.getTouch( _tapHere );
			if ( !t || t.phase!=TouchPhase.BEGAN ) return;
			
			
			// dispara o tiro 5 vezes - suficiente para aquecer o canhão
			spaceship.shoot( ( ( t.globalX / game.container.scaleX < stage.stageWidth / 2 ) ? 0 : 1 ), 
												   t.globalX / game.container.scaleX, 
												   t.globalY / game.container.scaleY );
			
			_tapTimes++;
			if ( _tapTimes < 5 ) return;
			_tapHere.removeEventListener( TouchEvent.TOUCH, arguments.callee );
			game.removeChild( _tapHere );
			
			
			// recebe ordem para resfriar o canhão
			game.wait(1000, function():void { 
			game.gameRunning = false;
			_skipButton.visible = true;
			game.createMessage( Resource.CORONELHEAD, "Damn, Rookie! That was too much! Refresh the engines, now!", 0, 0, function():void {
			game.createMessage( Resource.NEWBIEHEAD, "Y...yes sir!!!", 1, 0, function():void {
			
			
			// prepara a imagem que indica o swipe
			game.gameRunning = true;
			_skipButton.visible = false;
			_tapTimes = 0;
			
			
			//_tapHere = new Image( Texture.fromBitmap( new Resource.TUTORIAL_SWIPE ) );
			var txts:Vector.<Texture> = new Vector.<Texture>();
			txts.push( Texture.fromBitmap( new Resource.T_SWIPE1 ), Texture.fromBitmap( new Resource.T_SWIPE2 ) );
			
			
			_swipeHere = new MovieClip( txts, 3 );
			_swipeHere.x = 55;
			_swipeHere.y = 60;
			_swipeHere.play();
			game.container.addChild( _swipeHere );
			Starling.juggler.add( _swipeHere );
			
			
			// prepara o evento de swipe
			_swipeHere.addEventListener(TouchEvent.TOUCH, function(ev1:TouchEvent):void {	
			var touch:Touch = ev1.getTouch( _swipeHere );
			if	( !touch || touch.phase != TouchPhase.MOVED ) return;
			
			// refresca o canhão  - ao dedar cerca de 25 vezes o canhão já estara frio
			game.spaceship.refresh( "_cannon1" );
			_tapTimes++;
			if ( _tapTimes < 25 ) return;
			
			
			// remove o tutorial da tela
			_swipeHere.removeEventListener( TouchEvent.TOUCH, arguments.callee );
			game.container.removeChild( _swipeHere );
			Starling.juggler.remove( _swipeHere );
			game.gameRunning = false;
			_skipButton.visible = true;
			
			
			// inicia conversa final
			game.createMessage( Resource.CORONELHEAD, "Well done, rookie! You can start the main engine and point to that abandoned prison!", 0, 0, function():void {
			game.createMessage( Resource.NEWBIEHEAD, "Yes sir!!!", 1, 0, function():void {
			
			game.wait(1000, function():void { 
			
			game.createMessage( Resource.NEWBIEHEAD, "But sir, i think the prison wasn’t empty! Some people are over there!", 1, 0, function():void {
			game.createMessage( Resource.CORONELHEAD, "...And?", 0, 0, function():void {
			game.createMessage( Resource.NEWBIEHEAD, "What do you mean “and”? These people are in the prison, sir. We can’t shoot right now!", 1, 0, function():void {
			game.createMessage( Resource.CORONELHEAD, "They are in our client building! If the client don’t remove all of them, we won’t too!", 0, 0, function():void {
			game.createMessage( Resource.NEWBIEHEAD, "But sir, we will have to pay the cost for the death of...", 1, 0, function():void {
			game.createMessage( Resource.PRISIONERHEAD, "GROUND 8 IS ABOVE US! GET THE FIREWORKS! NOW!", 0, 0, function():void {
			game.createMessage( Resource.NEWBIEHEAD, "They will start to attack us!", 1, 0, function():void {
			game.createMessage( Resource.CORONELHEAD, "Oh you got a good day to start! Turn on the auxiliar cannons! Don't let them hit the main cannon!", 0, 0, function():void {	
			game.createMessage( Resource.NEWBIEHEAD, "Yes sir!", 1, 0, function():void {
			
			
			startGame();
			
				
			}); // yes sir
			}); // protect main cannon
			}); // attack us
			}); // FIREWORKS
			}); // pay for death
			}); // client terrain
			}); // what do you mean and
			}); // and??
			}); // some people
			}); // wait
			
			
			}); // yes sir
			}); // well done
			
			
			}); // evento de swipe
			
			
			}); // yes sir
			}); // danm rookie
			}); // second wait
				
			}); // second touch event
			
			
			}); // wait the fist shoot
			}); //shoot more
			}); // first touch event
			
			
			
			
			}); // Yes sir!
			}); // warm up our auxiliar cannons
			}); // we have to clean this area 
			}); // Alright rookie
			
			
			// game.planet.setPlanetBehavior(0);
			// game.createMessage( as3.class.Resource.CORONELHEAD, "Someone is coming! SHOOT HIM! TOUCH THEM TO shoot!", 0, 0, function()
		}
		
		
		
		
		
		override protected function startGame():void 
		{
			this.removeChild( this._tapHere );
			this.container.removeChild( this._swipeHere );
			super.startGame();
		}
		
		
		
		
		
		
		override protected function onTouchScreen(e:TouchEvent):void 
		{
			// you can control the clicks
			super.onTouchScreen(e);
		}
		
		
		
		
		
		
		override protected function update(e:Event):void 
		{
			// update settings
			super.update(e);
		}
		
	}

}