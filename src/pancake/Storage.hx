package pancake;

import js.Browser.window;

/**
 * ...
 * @author Rabia Haffar
 */
class Storage {
    public function new() {}
    
    public function save(variable: String, value: String): Void {
        window.localStorage.setItem(variable, value);
    }
    
    public function load(variable: String): String {
        return window.localStorage.getItem(variable);
    }
    
    public function remove(variable: String): Void {
        window.localStorage.removeItem(variable);
    }
    
    public function name(index: Int): String {
        return window.localStorage.key(index);
    }
    
    public function clear(): Void {
        window.localStorage.clear();
    }
}
