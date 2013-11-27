package engine.shoots 
{
	import starling.display.Image;
	import engine.gamestates.Game;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import flash.geom.Point;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.deg2rad;
	
	/**
	 * Gas bom - pulverize gas upon the people
	 * @author Wallace 'Wakko' Morais
	 */
	public class GasBomb extends AbstractFirewors 
	{
		
		private var _target:Point;
		
		private var _shootVelocity:Number;
		
		private var _angleRadian:Number;
		
		private var _initialY:Number;
		
		//private var _explosion:MovieClip;
		
		private var _falled:Boolean;
		
		
		
		public function GasBomb( x:Number, y:Number ) 
		{			
			this._target = new Point(x, y);
			this._shootVelocity = 4;
			this._falled = false;
			
			
			// generating the shoots
			var shootXml:XML = XML( new Resource.GAS_FALLING_PARTICLE() );
			var shootTex:Texture = Texture.fromBitmap(new Resource.PARTICLETEXTURE() );
			super(shootXml, shootTex);
			//var c:ColorArgb = new ColorArgb( 0, 1, 0, 1 );
			
			//this.startColor = c;
			//c.alpha = 0;
			//this.endColor = c;
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			/*this._explosion = new MovieClip( Game.INSTANCE.textureAtlas.getTextures('explosion2'), 12 );
			this._explosion.loop = false;
			this._explosion.pivotX = this._explosion.width / 2;
			this._explosion.pivotY = this._explosion.height / 2;*/
		}
		
		
		
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this._initialY = this.y;
			
			Starling.juggler.add( this );
			this._angleRadian = Math.atan2(this._target.y - this.y, this._target.x - this.x);
			//this._shootRotation = ( this._angleRadian * 360 / Math.PI ) * 0.01;
			this.start();
			_arrived = _finished = false;
		}
		
		
		
		
		override public function update():void 
		{
			// check explosion
			/*
			if ( this._explosion.isComplete && this._explosion.stage )
			{
				Game.INSTANCE.container.removeChild( this._explosion );
				Starling.juggler.remove( this._explosion );
				this._finished = true;
			}
			*/
			if ( this._arrived ) return;
			
			
			this.x += ( Math.cos(this._angleRadian) * this._shootVelocity );
			this.y += ( Math.sin(this._angleRadian) * this._shootVelocity );
			
			
			// collision with bounding circle
			/*var r1:Number = this.width / 2;
			var r2:Number = this._planetRef.planet.width / 2;
			var p1:Point = new Point(this.x, this.y);
			var p2:Point = new Point(this._planetRef.planet.x + r2, this._planetRef.planet.y + r2);
			var d:Number = Point.distance(p1, p2);*/
			
			
			if ( this.x > this._target.x - 6 && 
				 this.x < this._target.x + 6 && 
				 this.y > this._target.y - 6 && 
				 this.y < this._target.y + 6 && 
				 !this._arrived ) //|| 
				 /*this.getBounds( this.parent ).intersects( this._planetRef.planet.getBounds( this._planetRef ) )*/
				 //d < r1 + r2 ) 
			{
				//this.damage();
				if ( this._falled ) 
					this.explode();
				else
					this.fall();
			}
		}
		
		
		
		private function damage():void 
		{
			//trace('talke that');
			Game.INSTANCE.spaceship.takeDamage( 10, this._target );
		}
		
		
		
		private function fall():void 
		{
			this._falled = true;
			this._target.y = this._initialY;
			this._shootVelocity = 10;
			this._angleRadian = Math.atan2( this._target.y - this.y, this._target.x - this.x);
		}
		
		
		
		override public function explode():void 
		{
			this._arrived = true;
			this.stop();
			this.maxNumParticles = 178;
			this.lifespan = 3;
			this.emitterXVariance = 212;
			this.speed = 35;
			this.start();
		}
		
		
		
		override public function dispose():void 
		{
			this.stop();
			/*if( this._explosion.stage ) {
				Game.INSTANCE.container.removeChild( this._explosion );
				Starling.juggler.remove( this._explosion );
			}*/
			
			Game.INSTANCE.container.removeChild( this );
			Starling.juggler.remove( this );
			super.dispose();
		}
		
		
	}

}