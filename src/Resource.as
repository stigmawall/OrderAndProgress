package 
{
    public class Resource 
	{
		
		/************************************** FONT ASSETS ********************************************/
		
		[Embed(source="assets/visitor.fnt", mimeType="application/octet-stream")] public static const VISITORFONTXML:Class;
		[Embed(source = "assets/visitor_0.png")] public static const VISITORFONTTEXTURE:Class;
		[Embed(source="assets/visitor1.ttf", embedAsCFF="false", fontFamily="Visitor")] public static const VISIT:Class;
		
		
		/************************************** INTRO ASSETS ********************************************/
		
		
		[Embed(source = "assets/initial_screen.jpg")] public static const INTRO_FIREHURRICANE:Class;
		
		
		/************************************** MAIN MENU ASSETS ********************************************/
		
		
		[Embed(source = "assets/logo_game.png")] public static const LOGO_GAME:Class;
		[Embed(source = "assets/start_button.png")] public static const START_BTN:Class;
		[Embed(source = "assets/main_menu_line.png")] public static const MENU_EXTRA_LINE:Class;
		[Embed(source = "assets/main_menu_maps.png")] public static const MENU_EXTRA_MAP:Class;
		[Embed(source = "assets/main_menu_sphere.png")] public static const MENU_EXTRA_PLANET:Class;
		[Embed(source = "assets/scanline_filter.png")] public static const SCANLINE_FX:Class;
		
		[Embed(source = "assets/menu_sprite_sheet.png")] public static const MENUSPRITE:Class;
		[Embed(source = "assets/menu_sprite_sheet.xml", mimeType="application/octet-stream")] public static const MENUSPRITEXML:Class;
		
		
		/************************************** CINEMATIC ASSETS ********************************************/
		
		[Embed(source = "assets/cinematic_l1.jpg")] public static const CINEMATIC_LEVEL1:Class;
		
		
		/************************************** TUTORIAL ASSETS ********************************************/
		
		[Embed(source = "assets/Swipe_Left.png")] public static const T_SWIPE1:Class;
		[Embed(source = "assets/Swipe_Right.png")] public static const T_SWIPE2:Class;
		
		/************************************** GAME ASSETS ********************************************/
		
		
		[Embed(source = "assets/sprite_sheet.png")] public static const SPRITESHEET:Class;
		[Embed(source = "assets/sprite_sheet.xml", mimeType = "application/octet-stream")] public static const SPRITESHEETXML:Class;
		
		
		//shoot target
		[Embed(source = "assets/target.png")] public static const TARGET:Class;
		
		
		// embed configuration XML		
		[Embed(source = "assets/bg_atmosfere.png")] public static const ATMOSFERE:Class;
		[Embed(source = "assets/level1_floor.png")] public static const LEVEL1:Class;
		[Embed(source = "assets/level1_cerca.png")] public static const LEVEL1_CERCA:Class;
		
		[Embed(source = "assets/cannon.png")] public static const PHOTONCANNON:Class;
		
		[Embed(source = "assets/char1.png")] public static const CHAR_ANIM1:Class;
		[Embed(source = "assets/char2.png")] public static const CHAR_ANIM2:Class;
		
		[Embed(source = "assets/spaceship.png")] public static const SPACESHIP:Class;
		
		[Embed(source = "assets/photocannon1.png")] public static const PHOTO_CANNON1:Class;
		[Embed(source = "assets/photocannon2.png")] public static const PHOTO_CANNON2:Class;
		
		
		[Embed(source = "assets/star_empty.png")] public static const STAREMPTY:Class;
		[Embed(source = "assets/star_filled.png")] public static const STARFILLED:Class;
		[Embed(source = "assets/tvefx_filter.png")] public static const TVFX:Class;
		
		
		[Embed(source = "assets/coronelhead.png")] public static const CORONELHEAD:Class;
		[Embed(source = "assets/newbiehead.png")] public static const NEWBIEHEAD:Class;
		[Embed(source = "assets/prisonerhead.png")] public static const PRISIONERHEAD:Class;
		
		[Embed(source = "assets/modal_box.png")] public static const MODALBOX:Class;
		[Embed(source = "assets/taphere.png")] public static const TUTORIAL_TAP:Class;
		[Embed(source = "assets/swipehere.png")] public static const TUTORIAL_SWIPE:Class;
		
		
		[Embed(source = "assets/lost_signal1.gif")] public static const LOSTSIGNAL1:Class;
		[Embed(source = "assets/lost_signal2.gif")] public static const LOSTSIGNAL2:Class;
		
		
		
		[Embed(source = "assets/fireworkparticle.pex", mimeType = "application/octet-stream")] public static const FIREWORKPARTICLE:Class;
		[Embed(source = "assets/fireworktexture.png")] public static const FIREWORKTEXTURE:Class;
		
		
		[Embed(source = "assets/smokingparticle.pex", mimeType = "application/octet-stream")] public static const SMOKINGPARTICLE:Class;
		[Embed(source = "assets/explosionparticle.pex", mimeType = "application/octet-stream")] public static const EXPLODEPARTICLE:Class;
		[Embed(source = "assets/particletexture.png")] public static const PARTICLETEXTURE:Class;
		
		
		[Embed(source="assets/chipparticle.pex", mimeType="application/octet-stream")] public static const CHIPPARTICLE:Class;
		[Embed(source = "assets/chiptexture.png")] public static const CHIPTEXTURE:Class;
		
		
		[Embed(source = "assets/level1_torre.png")] public static const LEVEL1_TORRE:Class;
		
		
		
		
		[Embed(source = "assets/rocket1.png")] public static const ROCKET1:Class;
		[Embed(source = "assets/rocket2.png")] public static const ROCKET2:Class;
		
		
		
		
		/************************************** HUD ASSETS ********************************************/
		
		
		
		
		
		/************************************** MUSIC ASSETS ********************************************/
		
		
		[Embed(source = "assets/edward_shallow_cinder.mp3")] public static const SOUNDTRACK_INTRO:Class;
		[Embed(source = "assets/soundtrack.mp3")] public static const SOUNDTRACK_SFX:Class;
		
		
		/************************************** SOUND FX ASSETS ********************************************/
		
		[Embed(source = "assets/broca_normal.mp3")] public static const BROCA_NORMAL_SFX:Class;
		[Embed(source = "assets/broca_furando.mp3")] public static const BROCA_FURANDO_SFX:Class;
		[Embed(source = "assets/cannon1.mp3")] public static const CANNON1_SFX:Class;
		[Embed(source = "assets/explosion1.mp3")] public static const EXPLOSION1_SFX:Class;
		[Embed(source = "assets/flying.mp3")] public static const STARSHIP_FLYING:Class;
    }
}