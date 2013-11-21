package engine.gamestates
{
	import engine.huds.AnimatedTextField;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import starling.core.Starling;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	//import flash.filesystem.File;
	//import flash.filesystem.FileMode;
	//import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * Abstract class to control cinematics
	 * Using xml to carry the assets and lua to make short animations
	 * 
	 * @author Wallace 'Wakko' Morais
	 */
	public class Cinematic extends Sprite 
	{
		static private var _fileName:String;
		
		static private var _className:Class;
		
		
		
		private var _xml:XML;
		
		private var _frames:Array;
		
		private var _currentFrame:uint = 0;
		
		private var _loadingText:TextField;
		
		private var _animatedText:AnimatedTextField;
		
		//private var _fileStream:FileStream;
		
		private var _skipText:TextField;
		
		private var _imageCounter:uint = 0;
		
		private var _imageTotal:uint = 0;
		
		private var _showFrameComplete:Boolean;
		
		
		
		
		public function Cinematic() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		
		// Load all assets
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if ( !_fileName ) throw new Error('variable fileName not setted');
			
			//this._animatedText = new AnimatedTextField( 50, 100, 40, "Loading...", 999, "Visitor", 16, 0xffffff );
			this._loadingText = new TextField( 200, 100, "Loading...", "Visitor", 16, 0xffffff );
			this.addChild( this._loadingText );
			
			
			this._frames = [];
			this._showFrameComplete = false;
			
			
			this._skipText = new TextField( 200, 50, "Skip cinematic", "Visitor", 20, 0xffffff, false );
			this._skipText.x = -10;
			this._skipText.y = stage.stageHeight - 50;
			
			
			// Load xml with cinematic config
			/*var f:File = File.applicationDirectory.resolvePath( "cinematics/" + this._fileName + "/" + this._fileName + ".xml" );
			this._fileStream = new FileStream();
			this._fileStream.open( f, FileMode.READ );
			this._xml = new XML( this._fileStream.readUTFBytes( f.size ) );
			this._fileStream.close();
			*/
			
			
			var l:URLLoader = new URLLoader();
			l.load( new URLRequest( "cinematics/" + _fileName + "/" + _fileName + ".xml" ) );
			l.addEventListener("complete", onLoadXML, false, 0, true);
		}
		
		
		
		
		
		
		private function onLoadXML(e:*):void 
		{
			//this._xml = new XML( this._fileStream.readUTFBytes( f.size ) );
			this._xml = new XML( e.target.data );
			
			
			// Load all the assets and texts to make the frames animation
			var ba:ByteArray;
			var loader:Loader;
			var arrImgCount:Array = [];
			
			
			// load all frames
			for (var i:uint = 0; i < this._xml.frame.length(); i++)
			{
				// keep the space of an existing image in a array
				arrImgCount = [];
				this._imageTotal += this._xml.frame[i].image.length();
				
				
				
				// load all images
				for (var j:uint = 0; j < this._xml.frame[i].image.length(); j++)
				{
					/*f = File.applicationDirectory.resolvePath( this._xml.frame[i].image[j] );
					ba = new ByteArray();
					
					this._fileStream = new FileStream();
					this._fileStream.open( f, FileMode.READ );
					this._fileStream.readBytes( ba );
					this._fileStream.close();*/
					
					loader = new Loader();
					loader.load( new URLRequest( this._xml.frame[i].image[j] ) );
					loader.x = i;
					loader.y = j;
					loader.contentLoaderInfo.addEventListener("init", onLoaderInit, false, 0, true);
					//loader.loadBytes(ba);
					
					arrImgCount.push( { image:null, 
										time: parseFloat(this._xml.frame[i].image[j].@time),
										xi: parseFloat(this._xml.frame[i].image[j].@xi),
										xf: parseFloat(this._xml.frame[i].image[j].@xf),
										yi: parseFloat(this._xml.frame[i].image[j].@yi),
										yf: parseFloat(this._xml.frame[i].image[j].@yf),
										alphai: parseFloat(this._xml.frame[i].image[j].@alphai),
										alphaf: parseFloat(this._xml.frame[i].image[j].@alphaf),
										scalei: parseFloat(this._xml.frame[i].image[j].@scalei),
										scalef: parseFloat(this._xml.frame[i].image[j].@scalef) } );
				}
				
				
				// load all sounds
				
				
				
				//saving frames 
				this._frames.push( { text:this._xml.frame[i].text, textx:parseFloat(this._xml.frame[i].text.@x), texty:parseFloat(this._xml.frame[i].text.@y), images:arrImgCount } );
			}
		}
		
		
		
		
		
		
		// Finish load images
		private function onLoaderInit(e:*):void 
		{
			this.removeChild( this._loadingText );
			this._loadingText.dispose();
			
			
			var l:Loader = e.target.loader;
			this._frames[ l.x ].images[ l.y ].image = new Image( Texture.fromBitmap(l.content as Bitmap) );
			this._imageCounter++;
			
			// if everything is ready
			if ( this._imageCounter == this._imageTotal ) 
			{
				this.addChild( this._skipText );
				this.clearFrame();
				this.showFrame();
				this.stage.addEventListener(TouchEvent.TOUCH, onClick);
			}
		}
		
		
		
		
		
		private function onClick(e:TouchEvent):void 
		{
			var touch:Touch;
			
			touch = e.getTouch( this._skipText );
			if ( touch && touch.phase == TouchPhase.BEGAN ) 
			{
				this.finishCinematic();
				return;
			}
			
			touch = e.getTouch( this.stage );
			if ( touch && touch.phase == TouchPhase.BEGAN ) 
			{
				// keep passing the frames
				if( this._currentFrame < this._frames.length-1 )
				{
					this.clearFrame();
					this._currentFrame++;
					this.showFrame();
				}
				
				// animate the end 
				else
				{
					this.finishCinematic();
				}
			}
		}
		
		
		
		
		
		// show actual frame
		private function showFrame():void 
		{
			// add all images in this frame
			for each( var img:Object in this._frames[ _currentFrame ].images )
			{
				img.image.x = img.xi;
				img.image.y = img.yi;
				img.image.alpha = !isNaN(img.alphai) ? img.alphai : 1;
				img.image.scaleX = img.image.scaleY = !isNaN(img.scalei) ? img.scalei : 1;
				this.addChild( img.image );
				
				if ( img.time == undefined ) break;
				var props:Object = { };
				
				if ( !isNaN(img.xf) ) props.x = img.xf;
				if ( !isNaN(img.yf) ) props.y = img.yf;
				if ( !isNaN(img.alphaf) ) props.alpha = img.alphaf;
				if ( !isNaN(img.scalef) ) props.scaleX = props.scaleY = img.scalef;
				
				Starling.juggler.tween( img.image, img.time, props );
			}
			
			
			//create new text
			_animatedText = new AnimatedTextField(50, stage.stageWidth-10, 300, this._frames[ _currentFrame ].text, 1, "Visitor", 18, 0xffff00 );
			_animatedText.x = !isNaN( this._frames[ _currentFrame ].textx ) ? this._frames[ _currentFrame ].textx : 10;
			_animatedText.y = !isNaN( this._frames[ _currentFrame ].texty ) ? this._frames[ _currentFrame ].texty : 260;
			
			
			this.addChild( _animatedText );
			_animatedText.startAnimation();
		}
		
		
		
		
		
		private function clearFrame():void
		{
			//clear text
			if ( _animatedText )
			{
				this.removeChild( _animatedText );
				_animatedText.dispose();
			}
			
			// add all images in this frame
			for each( var img:Object in this._frames[ _currentFrame ].images ) {
				if(img.image.stage) this.removeChild( img.image );
			}
		}
		
		
		
		
		
		private function finishCinematic():void
		{
			this.stage.removeEventListener(TouchEvent.TOUCH, onClick);
			Starling.juggler.tween( this, 2, { alpha:0, onComplete:function():void 
			{
				clearFrame();
				Main.INSTANCE.switchState( Cinematic.className );
			} } );
		}
		
		
		
		
		
		override public function dispose():void 
		{
			_className = null;
			_fileName = null;
			super.dispose();
		}
		
		
		
		
		static public function get className():Class 
		{
			return _className;
		}
		
		static public function set className(value:Class):void 
		{
			_className = value;
		}
		
		static public function get fileName():String 
		{
			return _fileName;
		}
		
		static public function set fileName(value:String):void 
		{
			_fileName = value;
		}
		
		
	}

}