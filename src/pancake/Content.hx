package pancake;

import haxe.Json;

/**
 * ...
 * @author Rabia Haffar
 */
class Content {
    public function new() {}
    
    public function load(json_content: String): Dynamic {
        return Json.parse(json_content);
    }
}
