package engine.planets
{
	import engine.gamestates.Game;
	import engine.planets.Planet;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.Image;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	/**
	 * The kamikase - kill it
	 * 
	 * @author Wallace 'Wakko' Morais
	 */
	public class Kamikase extends Sprite 
	{
		// Consts
		
		static public const IDLE:uint = 1;
		
		static public const WALK:uint = 2;
		
		static public const RUN:uint = 3;
		
		static public const WIN:uint = 4;
		
		
		
		
		// Behavior control
		
		private var _behavior:uint = 1;
		
		private var _dying:Boolean;
		
		private var _totallyDeath:Boolean;
		
		private var _talking:Boolean;
		
		private var _px:Number;
		
		private var _pw:Number;
		
		
		
		// Physics
		
		protected const _walking:Number = 1;
		
		protected const _running:Number = 2;
		
		protected var _direction:uint;
		
				
		// References
		
		private var _targets:Array;
		
			
		// Animations
		
		private var _runAnimation:MovieClip;
		
		
		// Art
		
		private var _textures:Vector.<Texture>;
		
		
		
		
		
		
		public function Kamikase( $txt:Vector.<Texture> ) 
		{
			this._textures = $txt;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			this._direction = Math.round( Math.random() );
			this._talking = false;
			this._px = Planet(this.parent).planet.x;
			this._pw = Planet(this.parent).planet.width;
			
			this._targets = Game.INSTANCE.spaceship.weakPoints;
			this._dying = false;
			this._totallyDeath = false;
			
			
			this._runAnimation = new MovieClip( this._textures, 6 );
			this.addChild( this._runAnimation );
			Starling.juggler.add( this._runAnimation );
			this._runAnimation.play();
		}
		
		
		
		
		
		public function update():void
		{
			// if he is in idle mode
			if ( this._behavior == Kamikase.IDLE ) return; 
			
			
			// run or walk?
			var velocity:int;
			velocity = this._behavior == Kamikase.WALK ? this._walking : this._running;
			
			
			
			// check what direction he have to walk
			if ( this._direction == 0 ) 
				this.x -= velocity;
			else 
				this.x += velocity;
		   	 
			 
				
			// Check if is dying
			if ( this._dying ) 
			{
				// automatic run
				this._behavior = Kamikase.RUN;
				
				//If its dying and he pass the stage width, bye bye bye
				if ( this.x > stage.stageWidth || this.x < this.width ) this._totallyDeath = true;
				return;
			}
				
				
				
			// Check bounces
			if ( this.x >= this._px + this._pw ) this._direction = 0;
			else if ( this.x <= this._px ) this._direction = 1;
			
			
			
			// Chech directions
			this.scaleX = this._direction == 0 ? -1 : 1;
		}
		
		
		
		
		
		
		
		internal function die():void { this._dying = true;  }
		
		public function get totallyDeath():Boolean { return _totallyDeath; }
		
		public function get talking():Boolean { return _talking; }
		
		public function set talking(value:Boolean):void { _talking = value; }
		
		public function get behavior():uint { return _behavior;	}
		
		public function set behavior(value:uint):void {	_behavior = value; }
		
	}

}