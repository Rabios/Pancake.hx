package pancake;

import haxe.extern.EitherType;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.webgl.RenderingContext;
import pancake.Pancake;

/**
 * ...
 * @author Rabia Haffar
 */
class Context {
    public function new() {}
    
    public function create(canvas_index: Int, context_index: Int): Void {
        #if PANCAKE_CANVAS2D
        Pancake.contexts[context_index] = Pancake.canvases[canvas_index].getContext2d();
        #elseif PANCAKE_WEBGL
        Pancake.contexts[context_index] = Pancake.canvases[canvas_index].getContextWebGL({ antialias: true, preserveDrawingBuffer: true });
        if (Pancake.canvases[canvas_index].getContextWebGL({ antialias: true, preserveDrawingBuffer: true }) == null) {
            Pancake.contexts[context_index] = Pancake.canvases[canvas_index].getContext("experimental-webgl", { antialias: true, preserveDrawingBuffer: true });
        }
        #end
    }
    
    public function use(canvas: CanvasElement, context_index: Int): Void {
        #if PANCAKE_CANVAS2D
        Pancake.contexts[context_index] = canvas.getContext2d();
        #elseif PANCAKE_WEBGL
        Pancake.contexts[context_index] = canvas.getContextWebGL({ antialias: true, preserveDrawingBuffer: true });
        if (canvas.getContextWebGL({ antialias: true, preserveDrawingBuffer: true }) == null) {
            Pancake.contexts[context_index] = canvas.getContext("experimental-webgl", { antialias: true, preserveDrawingBuffer: true });
        }
        #end
    }
    
    public function set(new_context: EitherType<CanvasRenderingContext2D, EitherType<RenderingContext, Dynamic>>, context_index: Int): Void {
        Pancake.contexts[context_index] = new_context;
    }
}
