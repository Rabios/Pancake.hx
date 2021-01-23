package pancake;

import Reflect;
import js.html.AudioElement;
import js.html.VideoElement;
import js.html.Gamepad;
import js.Browser.document;
import js.Browser.window;
import js.Browser.navigator;
import pancake.Navigator;

/**
 * ...
 * @author Rabia Haffar
 */
@:native("navigator")
extern class NavigatorGamepadsSupport {
    public static function getGamepads(): Array<Gamepad>;
    public static function webkitGetGamepads(): Array<Gamepad>;
    public static function webkitGamepads(): Array<Gamepad>;
}

class Support {
    public function new() {}
    
    private var audio_elem: AudioElement = document.createAudioElement();
    private var video_elem: VideoElement = document.createVideoElement();
    
    public function WEBGL(): Bool {
        return (!!(document.createCanvasElement().getContext("experimental-webgl") != null || document.createCanvasElement().getContextWebGL() != null));
    }
    
    public function CANVAS(): Bool {
        return (!!(document.createCanvasElement().getContext2d() != null));
    }
    
    public function MP3(): Bool {
        return audio_elem.canPlayType("audio/mp3") != ""; 
    }
    
    public function MPEG(): Bool {
        return audio_elem.canPlayType("audio/mpeg") != ""; 
    }
    
    public function WAV(): Bool {
        return audio_elem.canPlayType("audio/wav") != ""; 
    }
    
    public function OGG(): Bool {
        return audio_elem.canPlayType("audio/ogg") != ""; 
    }
    
    public function CAF(): Bool {
        return audio_elem.canPlayType("audio/x-caf") != ""; 
    }
    
    public function AAC(): Bool {
        return audio_elem.canPlayType("audio/aac") != ""; 
    }
    
    public function AACP(): Bool {
        return audio_elem.canPlayType("audio/aacp") != ""; 
    }
    
    public function FLAC(): Bool {
        return audio_elem.canPlayType("audio/flac") != ""; 
    }
    
    public function MP4(): Bool {
        return video_elem.canPlayType("video/mp4") != "";
    }
    
    public function WEBM(): Bool {
        return video_elem.canPlayType("video/webm") != "";
    }
    
    public function JAVA(): Bool {
        return navigator.javaEnabled(); 
    }
    
    public function GAMEPAD(): Bool {
        return (Navigator.getGamepads != null || Navigator.webkitGetGamepads != null || Navigator.webkitGamepads != null);
    }
}

class Browser {
    public function new() {}
    
    public static function is(s: String): Bool {
        return (navigator.userAgent.indexOf(s) > -1);
    }
    
    public function open(url: String): Void {
        window.open(url);
    }
    
    public var CHROME: Bool = is("Chrome");
    public var FIREFOX: Bool = is("Firefox");
    public var OPERA: Bool = is("OPR");
    public var OPERA_MINI: Bool = is("Opera Mini");
    public var SAFARI: Bool = is("Safari");
    public var EDGE: Bool = is("Edg");
    public var IE: Bool = is("Trident") || is("MSIE");
    public var MAXTHON: Bool = is("Maxthon");
    public var SAMSUNG_INTERNET: Bool = is("SamsungBrowser");
    public var SEAMONKEY: Bool = is("SeaMonkey");
    public var support: Support = new Support();
	public function supports(feature: String): Bool {
        return Reflect.field(support, feature)();
    }
}
