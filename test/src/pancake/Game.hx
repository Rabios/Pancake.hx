package pancake;

import js.Browser.document;
import js.Browser.window;
import js.Browser.navigator;
import pancake.Native;

/**
 * ...
 * @author Rabia Haffar
 */

class Game {
    public function new() {}
    
    public function title(title: String): Void {
        if (Windows != null) UWPCurrentView.title = title;
        else document.title = title;
    }
    
    public function restart(): Void {
        window.location.reload();
    }
    
    public function close(): Void {
        if (NavigatorApp != null) {
            NavigatorApp.exitApp();
        } else if (NavigatorDevice != null) {
            NavigatorDevice.exitApp();
        } else if (Tizen != null) {
            var app: TizenAppObj = TizenApp.getCurrentApplication();
            if (app != null) {
                app.exit();
            }
        } else {
            window.close();
        }
    }
}
