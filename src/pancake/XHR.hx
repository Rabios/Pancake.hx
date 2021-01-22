package pancake;

import js.html.XMLHttpRequest;

/**
 * ...
 * @author Rabia Haffar
 */
class XHR {
    public function new() {}
    
    public function exec (e: String, url: String, ?content: String, ?content_type: String): Any {
        var x: XMLHttpRequest = new XMLHttpRequest();
        x.open(e, url, false);
        x.setRequestHeader("Content-Type", content_type != null ? content_type : "application/x-www-form-urlencoded");
        x.send(content != null ? content : null);
        return x;
    }
    
    public function get(url: String, ?content: String): Any {
        return exec("GET", url, content);
    }
    
    public function post(url: String, content: String, content_type: String): Any {
        return exec("POST", url, content);
    }
    
    public function head(url: String, content: String): Any {
        return exec("HEAD", url, content);
    }
}
