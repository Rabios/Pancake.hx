package pancake;

import js.html.CanvasElement;
import js.Browser.window;
import js.Browser.document;
import pancake.Pancake;
import pancake.Native;

/**
 * ...
 * @author Rabia Haffar
 */
class Canvas {
    public static var compatible_width: Int;
    public static var compatible_height: Int;

    public function new() {
        if (Windows != null) {
            compatible_width = cast(window.innerWidth, Int);
            compatible_height = cast(window.innerHeight, Int);
        } else {
            compatible_width = cast(window.innerWidth - 20, Int);
            compatible_height = cast(window.innerHeight - 20, Int);
        }
    }
    
    public function create(width: Int, height: Int, canvas_index: Int): Void {
        Pancake.canvases[canvas_index] = document.createCanvasElement();
        Pancake.canvases[canvas_index].width = width;
        Pancake.canvases[canvas_index].height = height;
        document.body.appendChild(Pancake.canvases[canvas_index]);
    }
    
    public function resize(width: Int, height: Int, canvas_index: Int): Void {
        Pancake.canvases[canvas_index].width = width;
        Pancake.canvases[canvas_index].height = height;
    }
    
    public function setAttribute(attribute: String, value: Any, canvas_index: Int): Void {
        Pancake.canvases[canvas_index].setAttribute(attribute, value);
    }
    
    public function remove(canvas_index: Int): Void {
        Pancake.canvases[canvas_index].parentNode.removeChild(Pancake.canvases[canvas_index]);
    }
    
    public function hide(canvas_index: Int): Void {
        Pancake.canvases[canvas_index].style.visibility = "hidden";
    }
    
    public function show(canvas_index: Int): Void {
        Pancake.canvases[canvas_index].style.visibility = "visible";
    }
    
    public function set(canvas: CanvasElement, canvas_index: Int): Void {
        Pancake.canvases[canvas_index] = canvas;
    }
}
