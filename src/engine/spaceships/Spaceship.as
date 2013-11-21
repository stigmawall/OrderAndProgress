package engine.spaceships
{
	import engine.gamestates.Game;
	import engine.huds.ShootTarget;
	import engine.huds.SpaceshipStatus;
	import engine.shoots.Fireworks;
	import engine.shoots.Shoot;

	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.utils.Timer;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.extensions.PDParticleSystem;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	import starling.filters.NewsprintFilter;
	import starling.textures.Texture;
	import starling.display.Image;
	import starling.textures.TextureSmoothing;
	
	
	
	/**
	 * The SpaceShit
	 * 
	 * @author Wallace 'Wakko' Morais
	 */
	public class Spaceship extends Sprite
	{
		private var _weakPoints:Array = [ new Point(190, 150), new Point(325, 250), new Point(455, 150) ];
		
		private var _cabin1:Sprite;
		
		private var _cabin2:Sprite;
		
		private var _spaceshipBar:SpaceshipStatus;
		
		private var _cannon1:Image;
		
		private var _cannon2:Image;
		
		private var _spaceship:Image;
		
		private var _shoots:Vector.<Shoot>;
		
		private var _takingDamage:Boolean;
		
		private var _initialXPos:Number;
		
		private var _shakeControl:uint;
		
		private const _shakeLimit:uint = 5;
		
		private var _explodingParticle:PDParticleSystem;
		
		private var _chipParticle:PDParticleSystem;
		
		private var _laserBeam:MovieClip;
		
		private var _photoCannon:MovieClip;
		
		private var _cannon1Particle:PDParticleSystem;
		
		private var _cannon2Particle:PDParticleSystem;
		
		private var _dying:Boolean;
		
		private var _attacking:Boolean = false;
		
		
		
		
		
		
		public function Spaceship() 
		{ 
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		
		
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			// shake control
			this._shakeControl = 0;
			
			
			// dying
			this._dying = false;
			
			
			
			// creating the spaceship
			this._spaceship = new Image( Texture.fromBitmap( new Resource.SPACESHIP() ) );
			this.addChild( this._spaceship );
			this._initialXPos = this.x;
			this._spaceship.x = (this.stage.stageWidth / 2) - ( this._spaceship.width / 2 );
			this._spaceship.y = 20;
			
			
			
			// creating the cabin
			this._cabin1 = new Sprite();
			this._cabin1.x = this._spaceship.x + 210;
			this._cabin1.y = this._spaceship.y + 125;
			this.addChild( this._cabin1 );
			
			this._cabin2 = new Sprite();
			this._cabin2.x = this._spaceship.x + 270;
			this._cabin2.y = this._spaceship.y + 125;
			this.addChild( this._cabin2 );
			
			
			
			// creating motherfucker cannons
			this._cannon1 = new Image( Texture.fromBitmap( new Resource.PHOTONCANNON() as Bitmap ) );
			this._cannon1.pivotX = this._cannon1.width / 2;
			this._cannon1.pivotY = this._cannon1.height;
			this._cannon1.rotation = 3.15;
			this._cannon1.x = this._spaceship.x + 180;
			this._cannon1.y = this._spaceship.y + 104;
			this.addChild( this._cannon1 );
			
			
			
			this._cannon2 = new Image( Texture.fromBitmap( new Resource.PHOTONCANNON() as Bitmap ) );
			this._cannon2.pivotX = this._cannon2.width / 2;
			this._cannon2.pivotY = this._cannon2.height;
			this._cannon2.rotation = 3.15;
			this._cannon2.x = this._spaceship.x + 452;
			this._cannon2.y = this._spaceship.y + 104;
			this.addChild( this._cannon2 );
			
			
			
			// laser beam
			this._laserBeam = new MovieClip( Game.INSTANCE.textureAtlas.getTextures('explosion1'), 24 );
			this._laserBeam.scaleX = this._laserBeam.scaleY = 0;
			this._laserBeam.filter = BlurFilter.createGlow( 0x00ccff, 1, 2, 0.5 );
			this._laserBeam.smoothing = TextureSmoothing.NONE;
			this._laserBeam.x = (this._spaceship.width / 2) - ( this._laserBeam.width/2 ) + 5;
			this._laserBeam.y = this._spaceship.height;
			this.addChild( this._laserBeam );
			Starling.juggler.add( this._laserBeam );
			
			
			
			// preparing shoots to kill
			this._shoots = new Vector.<Shoot>();
			
			
			
			// explosion
			this._explodingParticle = new PDParticleSystem( XML( new Resource.EXPLODEPARTICLE() ), 
															Texture.fromBitmap( new Resource.PARTICLETEXTURE() ) );
			//this._explodingParticle.maxNumParticles = 15;
			this._explodingParticle.startSize = 1;
			this._explodingParticle.x = stage.stageWidth / 2;
			this._explodingParticle.y = this._spaceship.height / 2;
			
			
			// chip explosion
			this._chipParticle = new PDParticleSystem( XML( new Resource.CHIPPARTICLE() ), 
														Texture.fromBitmap( new Resource.CHIPTEXTURE() ) );
			this._chipParticle.x = stage.stageWidth / 2;
			this._chipParticle.y = this._spaceship.height / 2;
			
			
			// cannon smoke
			this._cannon1Particle = new PDParticleSystem( XML( new Resource.SMOKINGPARTICLE() ), 
															Texture.fromBitmap( new Resource.PARTICLETEXTURE() ) );
			this._cannon2Particle = new PDParticleSystem( XML( new Resource.SMOKINGPARTICLE() ), 
															Texture.fromBitmap( new Resource.PARTICLETEXTURE() ) );
															
			this._cannon1Particle.x = this.cannon1.x;
			this._cannon1Particle.y = this.cannon1.y;
			this.addChild( this._cannon1Particle );
			Starling.juggler.add( this._cannon1Particle );
			
			this._cannon2Particle.x = this.cannon2.x;
			this._cannon2Particle.y = this.cannon2.y;
			this.addChild( this._cannon2Particle );
			Starling.juggler.add( this._cannon2Particle );
			
			
			// creating the status
			this._spaceshipBar = new SpaceshipStatus();
			this.addChild( this._spaceshipBar );
		}
		
		

		
		public function update( dt:Number = 0 ):void 
		{
			var angleRadian:Number;
			var l:uint = this._shoots.length;
			var ex:MovieClip;
			
			
			// if the spaceship start the attack
			if ( this._attacking )
			{
			
				this._laserBeam.scaleX = this._laserBeam.scaleY += 0.0005; //0.0005;
				this._laserBeam.x = (this._spaceship.width / 2) - ( this._laserBeam.width / 2 ) + 5;
				
				
				// if reach this scale, they will shoot
				if ( this._laserBeam.scaleX >= 3 ) 
				{
					// remove the concentrations ball
					this._laserBeam.stop();
					this.removeChild( this._laserBeam );
					Starling.juggler.remove( this._laserBeam );
					this._laserBeam.filter.dispose();
					this._laserBeam.filter = null;
					
					
					this.startLaserCannon();
					
					// you can check if they have to shoow twice
					Game.INSTANCE.playerWin();
					return;
				}
			}
			
			
			
			// First check if the shoot has finish, and if so, remove it from screen and from update list
			for ( var i:uint = 0; i < l; i++ ) 
			{
				ex = this._shoots[i].explosion;
				
				if ( ex.isComplete )
				{
					Starling.juggler.remove( ex );
					Game.INSTANCE.container.removeChild( ex );
					Game.INSTANCE.container.removeChild( this._shoots[i] );
					this._shoots[i].dispose();
					this._shoots.splice(i, 1);
					i--;
					l--;
				}
				else
					this._shoots[i].update();
			}
			
			
			// Check if the spaceship is alive, otherwise, the game is over
			if ( this._spaceshipBar.life <= 0 ) {
				Game.INSTANCE.gameOver();
			}
			
			
			// if the spaceship take damage, shake a little
			if ( this._takingDamage || this._dying ) {
				
				this._shakeControl++;
				if ( this._shakeControl == this._shakeLimit ) {
					this.x = ( this.x == this._initialXPos + 5 ) ? this._initialXPos - 5 : this._initialXPos + 5;
					this._shakeControl = 0;
				}
			} 
		
		}
		
		
		
		
		
		
		public function refresh( target:String ):void 
		{
			var cannon:Image = this[target] as Image;
			if( cannon.color < 16777215 )
				cannon.color += 4369;
				
			stopSmokingCannon(target);
		}
		
		
		
		
		
		private function startSmokingCannon( cannon:String ):void {
			var c:PDParticleSystem = this[ cannon + "Particle"] as PDParticleSystem;
			c.start();
		}
		
		
		
		private function stopSmokingCannon( cannon:String ):void {
			var c:PDParticleSystem = this[ cannon + "Particle"] as PDParticleSystem;
			c.pause();
		}
		
		
		
		
		
		
		public function startLaserCannon():void 
		{
			// photo cannoooooon
			var txt:Vector.<Texture> = new Vector.<Texture>();
			txt.push( Texture.fromBitmap( new Resource.PHOTO_CANNON1 ), Texture.fromBitmap( new Resource.PHOTO_CANNON2 ) );
			
			this._photoCannon = new MovieClip( txt , 30 );
			this._photoCannon.smoothing = TextureSmoothing.NONE;
			this._photoCannon.x = (this._spaceship.width / 2) - ( this._photoCannon.width/2 ) + 5;
			this._photoCannon.y = this._spaceship.height;
			this.addChild( this._photoCannon );
			Starling.juggler.add( this._photoCannon );
		}
		
		
		
		public function stopLaserCannon():void 
		{
			this._photoCannon.stop();
			this.removeChild( this._photoCannon );
			Starling.juggler.remove( this._photoCannon );
		}
		
		
		
		
		
		
		
		public function shoot( $side:uint, $targetX:Number, $targetY:Number, $tc:ShootTarget=null ):void
		{	
			// caso esse canhão esteja sobreaquecido
			if ( this['_cannon' + ($side + 1)].color <= 16711680 ) {
				startSmokingCannon( '_cannon' + ($side + 1) );
				
				// remove the target if the shoot was not dispatched
				if ( $tc ) {
					$tc.parent.removeChild( $tc );
					$tc = null;
				}
				
				return;
			}
			
			var s:Shoot = new Shoot( $targetX, $targetY, $tc );
			if ( $side == 0 ) s.x = this._cannon1.x;
			else s.x = this._cannon2.x;
			
			s.y = this._cannon2.y;
			
			Game.INSTANCE.container.addChild( s );
			this._shoots.push( s );
			
			this['_cannon' + ($side + 1)].rotation = s.shootRotation + 1.4;
			this['_cannon' + ($side + 1)].color -= 13107;
		}
		
		
		

		public function takeDamage( damage:Number, target:Point ):void 
		{
			// diminui o dano
			this._spaceshipBar.damage( -(damage * 0.01) );
			this._takingDamage = true;
			
			
			// caso o dano seja no canhão central, cancela o tiro e recomeça
			if ( target.x == this._weakPoints[1].x ) {
				this._laserBeam.scaleX = this._laserBeam.scaleY = 0;
			}
			
			
			// se estiver morrendo, treme todo
			if ( this._spaceshipBar.life < 0.3 && !this._explodingParticle.stage ) 
			{
				this.addChild( this._explodingParticle );
				Starling.juggler.add( this._explodingParticle );
				this._explodingParticle.start();
				this._dying = true;
			}
			
			
			// timer pra parar de tremer se não tiver morrendo
			var t:Timer = new Timer(1000, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void { 
				_takingDamage = false; 
				x = _initialXPos;
			}, false, 0, true );
			t.start();
		}
		
		
		
		
		
		
		public function explode( $callback:Function ):void 
		{
			var txts:Vector.<Texture> = Game.INSTANCE.textureAtlas.getTextures('explosion1');
			var txts2:Vector.<Texture> = Game.INSTANCE.textureAtlas.getTextures('explosion2');
			var ex1:MovieClip = new MovieClip( txts, 12 );
			var ex2:MovieClip = new MovieClip( txts, 12 );
			var ex3:MovieClip = new MovieClip( txts, 12 );
			var ex4:MovieClip = new MovieClip( txts2, 12 );
			var ex5:MovieClip = new MovieClip( txts2, 12 );
			
			
			Game.INSTANCE.container.shakeVar = 14;
			Game.INSTANCE.container.shakeTime = 0.2;
			this._explodingParticle.startSize = 100;
			
			
			Game.INSTANCE.container.addChild( _chipParticle );
			Starling.juggler.add( _chipParticle );
			_chipParticle.start();
			
			
			// removing particles from the cannons
			if ( this._cannon1Particle.stage ) {
				this._cannon1Particle.stop();
				this.removeChild( this._cannon1Particle );
				Starling.juggler.remove( this._cannon1Particle );
			}
			if ( this._cannon2Particle.stage ) {
				this._cannon2Particle.stop();
				this.removeChild( this._cannon2Particle );
				Starling.juggler.remove( this._cannon2Particle );
			}
			
			
			
			var s1:Sound = new Resource.EXPLOSION1_SFX() as Sound;
			s1.play();
			
			var t2:Timer = new Timer(100, 1);
			t2.addEventListener(TimerEvent.TIMER_COMPLETE, function():void 
			{
				ex3.smoothing = TextureSmoothing.NONE;
				ex3.loop = false;
				ex3.color = 0xfd0000;
				ex3.scaleX = ex3.scaleY = 2;
				ex3.x = (stage.stageWidth / 2) + ex3.width;
				ex3.y = 50;
				ex3.addEventListener(Event.COMPLETE, movieCompletedHandler);
				Game.INSTANCE.container.addChild( ex3 );
				Starling.juggler.add( ex3 );
				ex3.play();
				
				var s2:Sound = new Resource.EXPLOSION1_SFX() as Sound;
				s2.play();
			},false, 0, true );
			t2.start();
			
			
			var t3:Timer = new Timer(150, 1);
			t3.addEventListener(TimerEvent.TIMER_COMPLETE, function():void 
			{
				ex2.smoothing = TextureSmoothing.NONE;
				ex2.loop = false;
				ex2.scaleX = ex2.scaleY = 2;
				ex2.color = 0xfd0000;
				ex2.x = ex2.width;
				ex2.y = 50;
				ex2.addEventListener(Event.COMPLETE, movieCompletedHandler);
				Game.INSTANCE.container.addChild( ex2 );
				Starling.juggler.add( ex2 );
				ex2.play();
				
			},false, 0, true );
			t3.start();
			
			
			var t4:Timer = new Timer(200, 1);
			t4.addEventListener(TimerEvent.TIMER_COMPLETE, function():void 
			{
				ex1.smoothing = TextureSmoothing.NONE;
				ex1.loop = false;
				ex1.scaleX = ex1.scaleY = 4;
				ex1.x = ( stage.stageWidth / 2) - (ex1.width / 2);
				ex1.y = _spaceship.y;
				ex1.addEventListener(Event.COMPLETE, movieCompletedHandler);
				Game.INSTANCE.container.addChild( ex1 );
				Starling.juggler.add( ex1 );
				ex1.play();
				
				
				var t5:Timer = new Timer(150, 1);
				t5.addEventListener(TimerEvent.TIMER_COMPLETE, function():void 
				{
					_chipParticle.pause();
					visible = false;
					Game.INSTANCE.container.shakeVar = 4;
					Game.INSTANCE.container.shakeTime = 0.5;
					Game.INSTANCE.container.deactiveHand();
					$callback();
					
				},false, 0, true );
				t5.start()
				
				
			},false, 0, true );
			t4.start();
		}
		
		
		
		
		private function movieCompletedHandler(e:Event):void 
		{
			var ex:MovieClip = e.currentTarget as MovieClip;
			ex.removeEventListener(Event.COMPLETE, movieCompletedHandler);
			Game.INSTANCE.container.removeChild( ex );
			Starling.juggler.remove( ex );
		}
		
		
		
		
		public function clearShoots():void
		{
			for each( var s:Shoot in this._shoots ) {
				Game.INSTANCE.container.removeChild( s );
				s.dispose();
			}
			
			this._shoots = null;
		}
		
		
		
		
		override public function dispose():void 
		{
			// spaceship bar
			this.removeChild( this._spaceshipBar );
			
			// removing particles from the cannons
			if ( this._cannon1Particle.stage ) {
				this._cannon1Particle.stop();
				this.removeChild( this._cannon1Particle );
				Starling.juggler.remove( this._cannon1Particle );
			}
			if ( this._cannon2Particle.stage ) {
				this._cannon2Particle.stop();
				this.removeChild( this._cannon2Particle );
				Starling.juggler.remove( this._cannon2Particle );
			}
			
			this._cannon1Particle.dispose();
			this._cannon2Particle.dispose();
			this._chipParticle.dispose()
			super.dispose();
		}
		
		
		
		public function get spaceshipBar():SpaceshipStatus { return this._spaceshipBar; }
		
		public function get weakPoints():Array { return _weakPoints; }
		
		public function get cabin1():Sprite { return _cabin1; }
		
		public function get cabin2():Sprite { return _cabin2; }
		
		public function get shoots():Vector.<Shoot> { return this._shoots; }
		
		public function get cannon1():Image { return _cannon1; }
		
		public function get cannon2():Image { return _cannon2; }
		
		public function get attacking():Boolean 
		{
			return _attacking;
		}
		
		public function set attacking(value:Boolean):void 
		{
			_attacking = value;
		}
		
		//public function get drill():Drill { return _drill; }
		
		
	}

}