package engine.backgrounds
{
	import flash.display.BitmapData;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import flash.display.Shape;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * Background of the game with stars and everything :)
	 * @author Wallace 'Wakko' Morais
	 */
	public class BackgroundStar extends Sprite
	{
		private var _bg:Image;
		private var stars:Stars;
		private var _bgcolors:uint;
		
		private var _w:Number;
		private var _h:Number;
		private var _x:Number;
		private var _y:Number;
		
		
		
		public function BackgroundStar( $w:Number, $h:Number, $x:Number = 0, $y:Number=0, $bgcolor:uint = 0x110000 ) 
		{
			this._w = $w;
			this._h = $h;
			this._x = $x;
			this._y = $y;
			this._bgcolors = $bgcolor;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this._bg = new Image( this.generateBG() );
			this._bg.y = this._y;
			this.addChild( this._bg );
			
			stars = new Stars();
			stars.start();
			Starling.juggler.add(stars);
			addChild(stars);
		}
		
		
		
		internal function generateBG():Texture
		{
			var x1:int;
			var y1:int;
			var wid:int;
			var chooseColor:uint;
			
			
			// bg fill
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(1, 0, 0);
			shape.graphics.beginFill( this._bgcolors );
			shape.graphics.moveTo(this._x, this._y);
			shape.graphics.lineTo(this._w, this._y);
			shape.graphics.lineTo(this._w, this._h);
			shape.graphics.lineTo(this._x, this._h);
			shape.graphics.lineTo(this._x, this._y);
			shape.graphics.endFill();
			
			/*
			// details
			for ( var i:uint = 0; i <= 100; i++ )
			{
				chooseColor = this._colors[ Math.floor( Math.random() * this._colors.length ) ];
				shape.graphics.beginFill( chooseColor, Math.random() );
				
				x1 = Math.random() * this.stage.stageWidth;
				wid = 30 + ( Math.random() * 80 );
				y1 = Math.random() * this.stage.stageHeight;
				
				shape.graphics.moveTo(x1, y1);
				shape.graphics.lineTo(x1+wid, y1);
				shape.graphics.lineTo(x1+wid, y1+wid);
				shape.graphics.lineTo(x1, y1+wid);
				shape.graphics.lineTo(x1, y1);
				shape.graphics.endFill();
			}
			*/
			
			var bd:BitmapData = new BitmapData( this._w, this._h, false );
			bd.draw( shape );
			
			return Texture.fromBitmapData( bd );
		}
		
		
		
		override public function dispose():void 
		{
			Stars.particleTexture = null;
			Starling.juggler.remove(stars);
			this.removeChild(this._bg);
			this.removeChild(this.stars);
			
			this._bg.dispose();
			this.stars.stop();
			this.stars.dispose();
			super.dispose();
		}
	}

}