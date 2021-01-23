package pancake;

import js.Browser.document;
import js.Browser.window;
import js.Browser.navigator;

/**
 * ...
 * @author Rabia Haffar
 */
class Game {
    public function new() {}
    
    public function title(title: String): Void {
        document.title = title;
    }
    
    public function restart(): Void {
        window.location.reload();
    }
    
    public function close(): Void {
	    #if (navigator.app != null)
		navigator.app.exitApp();
		#elseif (navigator.device != null)
		navigator.device.exitApp();
		#else
        window.close();
		#end
    }
}
