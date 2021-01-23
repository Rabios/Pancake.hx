package pancake;

import js.html.XMLHttpRequest;

/**
 * ...
 * @author Rabia Haffar
 */
class XHR {
    public function new() {}
    
    public function exec(e: String, url: String, ?content: String, ?content_type: String): Any {
        var request: XMLHttpRequest = new XMLHttpRequest();
        request.open(e, url, false);
        request.setRequestHeader("Content-Type", content_type != null ? content_type : "application/x-www-form-urlencoded");
        request.send(content != null ? content : null);
        return request;
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
