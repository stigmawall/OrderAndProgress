package engine.planets
{
	import engine.display.DisplayObjectPlus;
	import engine.gamestates.Game;
	import engine.shoots.AbstractFirewors;
	import engine.shoots.AbstractProjectile;
	import engine.shoots.*;
	
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.ColorArgb;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	
	
	/**
	 * Planet assets and stuffs and shit and shoshotas :)
	 * 
	 * @author Wallace 'Wakko' Morais
	 */
	public class Planet extends Sprite 
	{
		private var _planet:Image;
		
		private var _kamikases:Vector.<Kamikase>;
		
		private var _shakeControl:uint;
		
		private const _shakeLimit:uint = 5;
		
		private var _kamikaseControl:uint;
		
		private const _kamikaseLimit:uint = 5;
		
		private var _habitantsBehavior:uint = 1;
		
		private var _planetAttacking:Boolean = false;
		
		private var _shoots:Vector.<DisplayObjectPlus>;
		
		private var _explodingParticle:PDParticleSystem;
		
		private var _classArr:Array;
		
		
		
		
		private var _planetAsset:Class;
		
		private var _charsAsset:Vector.<Texture>;
		
		private var _turn:uint;
		
		private var _max_turn:uint;
		
		private var _min_atk_turn:uint;
		
		private var _max_atk_turn:uint;
		
		private var _weaponsPerc:Array;
		
		
		
		
		
		public function Planet( $planetAsset:Class, $charsAssets:Vector.<Texture>, $classArray:Array, $weaponsPerc:Array, $turn:uint, $min_atk_turn:uint, $max_atk_turn:uint )
		{
			// settings
			// convert strings to classes
			this._classArr = $classArray;
			this._weaponsPerc = $weaponsPerc;
			this._turn = 0;
			this._max_turn = $turn;
			this._min_atk_turn = $min_atk_turn;
			this._max_atk_turn = $max_atk_turn;
			this._planetAsset = $planetAsset;
			this._charsAsset = $charsAssets;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		// init functions
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			// Generating the planet
			this._planet = new Image( Texture.fromBitmap( new this._planetAsset() ) );
			this._planet.x = -20;
			this._planet.y = this.stage.stageHeight - this._planet.height;
			this.addChild( this._planet );
			
			
			// Generating the party people
			this.generateKamikases();
			
			
			// generating the shoots
			this._shoots = new Vector.<DisplayObjectPlus>();
			
			
			// settings for shaking and dying
			this._shakeControl = 0;
			this._kamikaseControl = 0;
			
			
			
			// explosion
			this._explodingParticle = new PDParticleSystem( XML( new Resource.EXPLODEPARTICLE() ), 
															Texture.fromBitmap( new Resource.PARTICLETEXTURE() ) );
			this._explodingParticle.startColor = new ColorArgb(0.33, 0.33, 0.33, 1);
			this._explodingParticle.endColor = new ColorArgb(0.33, 0.33, 0.33, 1);
			this._explodingParticle.startColorVariance = new ColorArgb(0, 0, 0, 1);
			this._explodingParticle.endColorVariance = new ColorArgb(0, 0, 0, 1);
			this._explodingParticle.x = stage.stageWidth / 2;
			this._explodingParticle.y = this._planet.y + this._planet.height/2;
		}
		
		
		
		
		// Update everything on the planet
		public function update():void
		{
			// In case there's no more kamikases alive, the player win the battle
			var l:uint = this._kamikases.length;
		
			
			
			// sum turn counter
			this._turn++;
			
			
			
			//&& Math.random() < 0.006
			// check if they attack
			if ( Game.INSTANCE.gameRunning && this._planetAttacking && this._turn >= this._max_turn )
			{
				var len:uint = this._min_atk_turn + Math.floor( Math.random() * this._max_atk_turn );
				for ( var r:uint = 0; r < len; r++ ) this.attack();
			}
			
			
			
			
			// update shoots
			for ( var i:uint; i < this._shoots.length; i++ ) 
			{
				var s:DisplayObjectPlus = _shoots[i];
				s.update();
				if ( s.finished ) {
					Game.INSTANCE.container.removeChild( s );
					this._shoots.splice(i, 1);
					s.dispose();
				}
			}
			
			
			
			// First check if the kamikase has death, and if so, remove it from screen and from update list
			for ( i = 0; i < l; i++ ) 
			{
				if ( this._kamikases[i].totallyDeath ) {
					this.removeChild( this._kamikases[i] );
					this._kamikases[i].dispose();
					this._kamikases.splice(i, 1);
					i--;
					l--;
				}
				else 
					this._kamikases[i].update();
			}
		}
		
		
		
		
		// send one attack
		private function attack():void 
		{
			// select kamikaze
			var ran:uint = Math.floor( Math.random() * this._kamikases.length );
			var k:Kamikase = this._kamikases[ ran ];
			
			// select weak point
			var points:Array = Game.INSTANCE.spaceship.weakPoints;
			var wp:Point = points[ Math.floor( Math.random() * points.length ) ];
			
			
			// select weapon
			var prob:Number = Math.random();
			for ( var i:uint = 0; i < _weaponsPerc.length - 1; i++ ) {
				if ( prob < _weaponsPerc[i] ) break;
			}
			
			var sh:DisplayObjectPlus = new _classArr[ i ] ( wp.x, wp.y );
			
			this._turn = 0;
			sh.x = k.x;
			sh.y = k.y;
			
			Game.INSTANCE.container.addChild( sh );
			_shoots.push( sh );
		}
		
		
		
		
		
		public function clearShoots():void 
		{
			for each( var s:DisplayObjectPlus in this._shoots ) {
				Game.INSTANCE.container.removeChild( s );
				s.dispose();
			}
			//this._shoots = null;
		}
		
		
		
		
		
		public function explode( $callback:Function ):void 
		{
			this.addChild( this._explodingParticle );
			Starling.juggler.add( this._explodingParticle );
			this._explodingParticle.start();
			//Game.INSTANCE.container.shakeVar = 14;
			//Game.INSTANCE.container.shakeTime = 0.2;
			
			var t5:Timer = new Timer(3000, 1);
			t5.addEventListener(TimerEvent.TIMER_COMPLETE, function():void 
			{
				_explodingParticle.pause();
				Game.INSTANCE.container.shakeVar = 4;
				Game.INSTANCE.container.shakeTime = 0.5;
				Game.INSTANCE.container.deactiveHand();
				if( $callback!=null ) $callback();
				
			},false, 0, true );
			t5.start()
		}
		
		
		
		
		
		
		// Create alll the kamikases of the planet
		private function generateKamikases():void 
		{
			var x1:int;
			var y1:int;
			var k:Kamikase;
			
			this._kamikases = new Vector.<Kamikase>();
			
			
			// details
			for ( var i:uint = 0; i <= 6; i++ )
			{
				k = new Kamikase( this._charsAsset );
				k.pivotX = k.width / 2;
				k.pivotY = 70;
				k.x = this._planet.x + ( 100 * i );
				k.y = 925;
				
				this.addChild(k);
				this._kamikases.push(k);
			}
		}
		
		
		
		
		public function setPlanetBehavior( $behavior:uint ):void {
			this._habitantsBehavior = $behavior;
			for each( var k:Kamikase in this._kamikases ) k.behavior = $behavior;
		}
		
		
		
		
		override public function dispose():void 
		{
			for each( var k:Kamikase in this._kamikases ) {
				this.removeChild( k );
				k.dispose();
			}
			this._explodingParticle.stop();
			this._explodingParticle.dispose();
			this._shoots = null;
			super.dispose();
		}
		
		
		
		
		public function get planet():Image { return this._planet; }
		
		public function get kamikases():Vector.<Kamikase> { return _kamikases; }
		
		public function get shoots():Vector.<DisplayObjectPlus> { return _shoots; }
		
		public function get planetAttacking():Boolean {
			return _planetAttacking;
		}
		
		public function set planetAttacking(value:Boolean):void {
			_planetAttacking = value;
		}
		
	}

}