package pancake;

import haxe.Json;
import haxe.extern.EitherType;
import js.Browser.window;
import js.Browser.navigator;
import js.html.XMLHttpRequest;

/**
 * ...
 * @author Rabia Haffar
 */
class Device {
    public function new() {}
    
    public var screen_width: Int = window.screen.width;
    public var screen_height: Int = window.screen.height;
    public var language: String = navigator.language;
    
    public function vibrate(pattern: EitherType<Int, Array<Int>>): Bool {
        return navigator.vibrate(pattern);
    }
    
    public function stopVibrating(): Bool {
        return navigator.vibrate(0);
    }
    
    public function online(): Bool {
        try {
            var request: XMLHttpRequest = new XMLHttpRequest();
            request.open("GET", "https://ipinfo.io/json", false);
            request.send(null);
            var f: Int = request.status;
            return (f >= 200 && (f < 300 || f == 304));
        } catch (e) {
            return false;
        }
    }
    
    public function geoInfo(): Dynamic {
        var request: XMLHttpRequest = new XMLHttpRequest();
        request.open("GET", "https://ipinfo.io/json", false);
        request.send(null);
        var f: Int = request.status;
        if (f >= 200 && (f < 300 || f == 304)) {
            return Json.parse(request.responseText);
        }
        return null;
    }
}
