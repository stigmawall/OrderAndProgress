package engine.shoots
{
	import engine.gamestates.Game;
	import engine.huds.ShootTarget;
	import engine.planets.Planet;
	import flash.display.Bitmap;
	import flash.media.Sound;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import flash.geom.Point;
	import starling.textures.Texture;
	import starling.filters.BlurFilter;
	import starling.utils.deg2rad;
	
	
	/**
	 * Shoot to thrill i'm gonna ready to kill
	 * 
	 * @author Wallace 'Wakko' Morais
	 */
	public class Shoot extends MovieClip 
	{
		
		
		private var _target:Point;
		
		private var _shootVelocity:Number;
		
		private var _angleRadian:Number;
		
		//private var _arrived:Boolean;
		
		private var _explosion:MovieClip;
		
		private var _planetRef:Planet;
		
		private var _shootRotation:Number;
		
		private var _shootTarget:ShootTarget;
		
		
		
		public function Shoot( $targetX:Number, $targetY:Number, $tc:ShootTarget=null ) 
		{
			// creating me
			super( Game.INSTANCE.textureAtlas.getTextures('shoot') );
			this.pivotX = this.width / 2;
			this.pivotY = this.height / 2;
			
			
			// setting the target and speed
			this._target = new Point( $targetX, $targetY );
			this._shootVelocity = 10;
			this._arrived = false;
			
			
			// target 
			this._shootTarget = $tc;
			
			
			// creating the EXPLOSION effect
			this._explosion = new MovieClip( Game.INSTANCE.textureAtlas.getTextures('explosion1'), 12 );
			this._explosion.loop = false;
			this._explosion.scaleX = this._explosion.scaleY = 1.4;
			this._explosion.stop();
			//this._explosion.filter = BlurFilter.createGlow(0xff0000,1,2,0.5);
			
			
			
			// creating sound
			var s:Sound = new Resource.CANNON1_SFX() as Sound;
			s.play();
			
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//Starling.juggler.add( this );
			
			// get planet reference
			this._planetRef = Game.INSTANCE.planet;
			
			this._angleRadian = Math.atan2(this._target.y - this.y, this._target.x - this.x);
			this._shootRotation = this._angleRadian + 0.1;
			
			//( this._angleRadian * 360 / Math.PI ) * 0.01;
		}
		
		
		
		
		
		override public function update():void 
		{
			if ( this._arrived ) return;
			
			
			this.x += ( Math.cos(this._angleRadian) * this._shootVelocity );
			this.y += ( Math.sin(this._angleRadian) * this._shootVelocity );
			
			
			// collision with bounding circle
			var r1:Number = this.width / 2;
			var r2:Number = this._planetRef.planet.width / 2;
			var p1:Point = new Point(this.x, this.y);
			var p2:Point = new Point(this._planetRef.planet.x + r2, this._planetRef.planet.y + r2);
			var d:Number = Point.distance(p1, p2);
			
			
			if ( this.x > this._target.x - 6 && 
				 this.x < this._target.x + 6 && 
				 this.y > this._target.y - 6 && 
				 this.y < this._target.y + 6 && 
				 !this._arrived || 
				 d < r1 + r2 ) 
			{
				this.explode();
			}
		}
		
		
		
		
		
		public function removeTarget():void 
		{
			if ( this._shootTarget ) {
				this._shootTarget.parent.removeChild( this._shootTarget );
				this._shootTarget = null;
			}
		}
		
		
		
		
		
		override public function explode():void 
		{
			this.removeTarget();
			
			this._arrived = true;			
			this._explosion.x = this.x - this._explosion.width / 2;
			this._explosion.y = this.y - this._explosion.height / 2;
			Game.INSTANCE.container.addChild( this._explosion );
			Starling.juggler.add( this._explosion );
			this._explosion.play();
			
			this.visible = false;
			//Starling.juggler.remove( this );
			
			var s:Sound = new Resource.EXPLOSION1_SFX() as Sound;
			s.play();
		}
		
		
		
		
		override public function get arrived():Boolean 
		{
			return super.arrived;
		} 
		
		
		
		
		public function get explosion():MovieClip 
		{
			return _explosion;
		}
		
		
		public function get shootRotation():Number 
		{
			return _shootRotation;
		}
		
		
		
		
		override public function dispose():void 
		{
			Game.INSTANCE.container.removeChild( this._explosion );
			Starling.juggler.remove( this._explosion );
			
			this._planetRef = null;
			this._target = null;
			this._shootVelocity = 0;
			this._angleRadian = 0;
			this._arrived = false;
			this._explosion = null;
			super.dispose();
		}
		
	}

}