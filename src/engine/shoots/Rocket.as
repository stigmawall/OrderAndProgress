package engine.shoots
{
	import engine.gamestates.Game;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import flash.geom.Point;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.deg2rad;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Rocket extends AbstractProjectile 
	{
		
		
		private var _target:Point;
		
		private var _shootVelocity:Number;
		
		private var _angleRadian:Number;
		
		private var _explosion:MovieClip;
		
		
		
		
		
		public function Rocket( x:Number, y:Number ) 
		{
			this._target = new Point(x, y);
			this._shootVelocity = 3;
			
			// generating the shoots
			var txts:Vector.<Texture> = new Vector.<Texture>();
			txts.push( Texture.fromBitmap( new Resource.ROCKET1 ), Texture.fromBitmap( new Resource.ROCKET2 ) );
			super( txts, 6 );
			this.x = this.x;
			this.y = this.y;
			
			
			this._explosion = new MovieClip( Game.INSTANCE.textureAtlas.getTextures('explosion2'), 12 );
			this._explosion.loop = false;
			this._explosion.smoothing = TextureSmoothing.NONE;
			this._explosion.pivotX = this._explosion.width / 2;
			this._explosion.pivotY = this._explosion.height / 2;
			this._explosion.scaleX = this._explosion.scaleY = 2;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Game.INSTANCE.container.addChild( this );
			Starling.juggler.add( this );
			
			this._angleRadian = Math.atan2(this._target.y - this.y, this._target.x - this.x);
			
			if( this._target.x < this.x ) {
				//angle = (Math.PI/4);
				this.rotation = this._angleRadian * 0.05;
			}
			else {
				//angle = -(Math.PI/4);
				this.rotation = -(this._angleRadian * 0.05);
			}
			
			//this.rotation = this._angleRadian * 0.05; //( this._angleRadian * 360 / Math.PI ) * 0.1;
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
				this.damage();
				this.explode();
			}
		}
		
		
		
		private function damage():void 
		{
			//trace('talke that');
			Game.INSTANCE.spaceship.takeDamage( 30, this._target );
		}
		
		
		
		override public function explode():void 
		{
			this._arrived = true;
			Game.INSTANCE.container.removeChild( this );
			Starling.juggler.remove( this );
			
			this._explosion.x = this.x;
			this._explosion.y = this.y;
			Game.INSTANCE.container.addChild( this._explosion );
			Starling.juggler.add( this._explosion );
		}
		
		
		
		override public function dispose():void 
		{
			if( this._explosion.stage ) {
				Game.INSTANCE.container.removeChild( this._explosion );
				Starling.juggler.remove( this._explosion );
			}
			
			super.dispose();
		}
		
		
		
		
	}

}