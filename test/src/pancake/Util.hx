package pancake;

import Math;

/**
 * ...
 * @author Rabia Haffar
 */
class Util {
    public function new() {}
    
    public static function random(n: Int): Int {
        return Math.floor(Math.random() * n);
    }
    
    public function randomBetween(a: Int, b: Int): Int {
        return random(b - a) + a;
    }
    
    public function quote(str: String): String {
        return ("\"" + str + "\"");
    }
}
