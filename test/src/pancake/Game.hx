package pancake;

import js.Browser.document;
import js.Browser.window;

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
        window.close();
    }
}
