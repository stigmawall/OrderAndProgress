package engine.backgrounds
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DBlendFactor;
	import flash.geom.Rectangle;
	 
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.extensions.ColorArgb;
	import starling.extensions.Particle;
	import starling.extensions.ParticleSystem;
	import starling.textures.Texture;
	
	/**
	 * This is stars particle system
	 */
	internal class Stars extends ParticleSystem {
		
		// texture for star
		internal static var particleTexture:Texture;
	 
		private const lifeSpan:Number = 10.0;
		// main color of stars, will be some randomize in initParticle
		private const color:ColorArgb = new ColorArgb(0.5, 0.5, 1.0);
	 
		public function Stars() 
		{
			var numParticles:int = 30;
			createTexture();
	 
			super(particleTexture, numParticles / lifeSpan, numParticles, numParticles,
				Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				
			// this is a main part of this tutorial
			// we initialize all our stars, and don't wait juggler
			mNumParticles = numParticles;
			var w:Number = Starling.current.stage.stageWidth;
			for (var i:int = 0; i < numParticles; ++i) {
				// get every particle
				var particle:StarParticle = mParticles[i] as StarParticle;
				// initialize it
				initParticle(particle);
				var rand:Number = Math.random();
				// place every star on whole stageWidth
				particle.x = w * rand;
				// decrease a totalTime of star, because we moved it
				particle.totalTime *= 1.0 - rand;
			}
		}
	 
		// create a simple texture with white "+"
		private function createTexture():void 
		{
			if (particleTexture) return;
			var skin:BitmapData = new BitmapData(8, 8, true, 0);
			var r:Rectangle = new Rectangle();
			r.setTo(2, 1, 1, 3);
			skin.fillRect(r, 0xFFFFFFFF);
			r.setTo(1, 2, 3, 1);
			skin.fillRect(r, 0xFFFFFFFF);
			particleTexture = Texture.fromBitmapData(skin, false);
			skin.dispose();
		}
	 
		/**
		 * Create out own particle class instead default
		 */
		override protected function createParticle():Particle {
			return new StarParticle();
		}
	 
		/**
		 * This function will initialize particle every time it start its life
		 */
		override protected function initParticle(_particle:Particle):void 
		{
			var particle:StarParticle = _particle as StarParticle;
			var st:Stage = Starling.current.stage;
	 
			// reset current time to zero
			particle.currentTime = 0.0;
			// randomize life time 30 + 30 * [-0.5, 0.5] = [15, 45]
			particle.totalTime = lifeSpan + lifeSpan * (Math.random() - 0.5);
	 
			// randomize size of star [1.0, 2.5]
			particle.scale = 1.0 + 1.5 * Math.random();
			// place star outsize of left bound
			particle.x = st.stageWidth * Math.random();
			//particle.x = -particleTexture.width * 0.5 * particle.scale;
			// randomize vertical placement of star
			particle.y = st.stageHeight * Math.random();
			// calculate speed, we need add speed*pasedTime to `x` on every advance
			// in the end we should be outside of right bound
			particle.speed = 0//((st.stageWidth + particleTexture.width * particle.scale) - particle.x) / particle.totalTime;
	 
			// randomize star color
			color.red   = 0.5 + 0.25 * (Math.random() * 2.0 - 1.0);
			color.green = 0.5 + 0.25 * (Math.random() * 2.0 - 1.0);
			particle.color = color.toRgb();
		}
	 
		/**
		 * Advance every star
		 * when currentTime will be more then totalTime, star will go to
		 * initParticle method and all start again
		 */
		override protected function advanceParticle(_particle:Particle, passedTime:Number):void {
			var particle:StarParticle = _particle as StarParticle;
			//particle.x += particle.speed * passedTime;
			particle.currentTime += passedTime;
		}
		
	 
	}

}