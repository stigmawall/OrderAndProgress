package engine.huds 
{
	import engine.gamestates.Game;
	import engine.gamestates.MainMenu;
	import engine.levels.Level1;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * Controla a tela final de cada fase
	 * @author Wallace
	 */
	public class FinalLevelScreen extends Sprite 
	{
		
		private var _menu:AnimatedTextField;
		
		private var _retry:AnimatedTextField;
		
		private var _next:AnimatedTextField;
		
		private var _bg:MovieClip;
		
		private var _tvolt:Boolean;
		
		
		
		public function FinalLevelScreen( tvolt:Boolean = true ) 
		{
			_tvolt = tvolt;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var txtmission:String = "Mission failed";
			
			if ( _tvolt ) 
			{
				txtmission = "Mission Complete";
				
				var txt:Vector.<Texture> = new Vector.<Texture>();
				txt.push( Texture.fromBitmap( new Resource.LOSTSIGNAL1 ), Texture.fromBitmap( new Resource.LOSTSIGNAL2 ) );
				this._bg = new MovieClip( txt, 12 );
				this.addChild( this._bg );
				Starling.juggler.add( this._bg );
			}
			
			
			// Mission Complete
			var levelCompletePhase:AnimatedTextField = new AnimatedTextField( 60, stage.stageWidth, 100, txtmission, 1, "Visitor", 65, 0x00ff00);
			levelCompletePhase.y = 200;
			this.addChild( levelCompletePhase );
			levelCompletePhase.startAnimation("center");
			levelCompletePhase.addEventListener(Event.COMPLETE, function():void 
			{
				// Status
				var statusPhases:AnimatedTextField = new AnimatedTextField( 60, 
																		 stage.stageWidth, 
																		 120, 
																		 "Time: 99:99:99\nDamage: 50%\nDeaths: 50%", 
																		 1, 
																		 "Visitor", 
																		 40, 
																		 0x00ff00);
				statusPhases.y = 400;
				addChild( statusPhases );
				statusPhases.startAnimation("center");
				statusPhases.addEventListener(Event.COMPLETE, function():void 
				{ 
					// Botoes
					_menu = new AnimatedTextField( 50, 160, 100, "menu", 1, "Visitor", 50, 0x00ff00);
					_menu.y = 600;
					_menu.x = 50;
					addChild( _menu );
					_menu.startAnimation("center");
					_menu.addEventListener(TouchEvent.TOUCH, onTouch_menu);
					
					_retry = new AnimatedTextField( 50, 160, 100, "retry", 1, "Visitor", 50, 0x00ff00);
					_retry.y = 600;
					_retry.x = 250;
					addChild( _retry );
					_retry.startAnimation("center");
					_retry.addEventListener(TouchEvent.TOUCH, onTouch_menu);
					
					_next = new AnimatedTextField( 50, 160, 100, "next", 1, "Visitor", 50, 0x00ff00);
					_next.y = 600;
					_next.x = 450;
					addChild( _next );
					_next.startAnimation("center");
					_next.alpha = 0.3
					//_next.addEventListener(TouchEvent.TOUCH, onTouch_menu);
				});
			});
		}
		
		
		
		
		
		private function onTouch_menu(e:TouchEvent):void 
		{
			var touch:Touch;
			touch = e.getTouch( this._menu );
			if ( touch && touch.phase == TouchPhase.BEGAN) {
				Game.INSTANCE.clean();
				Main.INSTANCE.switchState( MainMenu );
			}
			
			touch = e.getTouch( this._retry );
			if ( touch && touch.phase == TouchPhase.BEGAN) {
				Game.INSTANCE.clean();
				Main.INSTANCE.switchState( Level1 );
				//Game.INSTANCE.level
			}
			
			touch = e.getTouch( this._next );
			if ( touch && touch.phase == TouchPhase.BEGAN) {
				Settings.level++;
				Game.INSTANCE.clean();
				Main.INSTANCE.switchState( Level1 );
			}
		}
		
		
	}

}