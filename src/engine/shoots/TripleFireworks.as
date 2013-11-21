package engine.shoots 
{
	import engine.gamestates.Game;
	import starling.extensions.PDParticleSystem;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import flash.geom.Point;
	import starling.extensions.ColorArgb;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TripleFireworks extends AbstractFirewors 
	{
		
		
		
		private var _target:Point;
		
		private var _shootVelocity:Number;
		
		private var _angleRadian:Number;
		
		private var _explosion:MovieClip;
		
		
		
		
		
		
		public function TripleFireworks(x:Number, y:Number)
		{
			this._target = new Point(x, y*3);
			this._shootVelocity = 4;
			
			// generating the shoots
			var shootXml:XML = XML( new Resource.FIREWORKPARTICLE() );
			var shootTex:Texture = Texture.fromBitmap(new Resource.FIREWORKTEXTURE() );
			
			super(shootXml, shootTex);
			var c:ColorArgb = new ColorArgb(1, .83, .49, 1);
			this.startColor = c;
			c.alpha = 0;
			this.endColor = c;
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			this._explosion = new MovieClip( Game.INSTANCE.textureAtlas.getTextures('explosion2'), 12 );
			this._explosion.loop = false;
			this._explosion.pivotX = this._explosion.width / 2;
			this._explosion.pivotY = this._explosion.height / 2;
		}
		
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Starling.juggler.add( this );
			this._angleRadian = Math.atan2(this._target.y - this.y, this._target.x - this.x);
			//this._shootRotation = ( this._angleRadian * 360 / Math.PI ) * 0.01;
			this.start();
			_arrived = _finished = false;
		}
		
		
		
		
		override public function update():void 
		{
			// check explosion
			if ( this._explosion.isComplete && this._explosion.stage )
			{
				Game.INSTANCE.container.removeChild( this._explosion );
				Starling.juggler.remove( this._explosion );
				this._finished = true;
			}
			
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
				this.explode();
				this.createFireworks();
			}
		}
		
		
		
		
		private function createFireworks():void 
		{
			var points:Array = Game.INSTANCE.spaceship.weakPoints;
			
			var sh1:AbstractFirewors = new Fireworks( points[0].x, points[0].y );
			sh1.x = this.x; sh1.y = this.y;
			var sh2:AbstractFirewors = new Fireworks( points[1].x, points[1].y );
			sh2.x = this.x; sh2.y = this.y;
			var sh3:AbstractFirewors = new Fireworks( points[2].x, points[2].y );
			sh3.x = this.x; sh3.y = this.y;
			
			Game.INSTANCE.container.addChild( sh1 );
			Game.INSTANCE.container.addChild( sh2 );
			Game.INSTANCE.container.addChild( sh3 );
			Game.INSTANCE.planet.shoots.push( sh1, sh2, sh3 );
		}
		
		
		
		
		override public function explode():void 
		{
			this._arrived = true;
			this.stop();
			this._explosion.x = this.x;
			this._explosion.y = this.y;
			Game.INSTANCE.container.addChild( this._explosion );
			Starling.juggler.add( this._explosion );
			
			
		}
		
		
		
		override public function dispose():void 
		{
			this.stop();
			if( this._explosion.stage ) {
				Game.INSTANCE.container.removeChild( this._explosion );
				Starling.juggler.remove( this._explosion );
			}
			
			Game.INSTANCE.container.removeChild( this );
			Starling.juggler.remove( this );
			super.dispose();
		}
		
		
		
		
		
	}

}