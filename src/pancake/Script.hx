package pancake;

import Reflect.fields;
import Reflect.field;
import js.html.ScriptElement;
import js.Browser.document;

/**
 * ...
 * @author Rabia Haffar
 */
class Script {
    public function new() {}
    
    public function create(script_properties: Dynamic): Void {
        var script: ScriptElement = document.createScriptElement();
        for (key in Reflect.fields(script_properties)) script.setAttribute(key, Reflect.field(script_properties, key));
        document.body.appendChild(script);
    }
    
    public function loadSource(script_src: String): Void {
        create({
            src: script_src,
            type: "text/javascript",
            defer: true
        });
    }
}
