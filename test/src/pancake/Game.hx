package pancake;

import js.Browser.document;
import js.Browser.window;
import js.Browser.navigator;

/**
 * ...
 * @author Rabia Haffar
 */

@:native("navigator.app")
extern class NavigatorApp {
    public static function exitApp(): Void;
}

@:native("navigator.device")
extern class NavigatorDevice {
    public static function exitApp(): Void;
}

class Game {
    public function new() {}
    
    public function title(title: String): Void {
        document.title = title;
    }
    
    public function restart(): Void {
        window.location.reload();
    }
    
    public function close(): Void {
	    if (NavigatorApp != null) {
		    NavigatorApp.exitApp();
		} else if (NavigatorDevice != null) {
		    NavigatorDevice.exitApp();
		} else {
            window.close();
		}
    }
}
