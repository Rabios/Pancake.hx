package pancake;

import js.Browser.window;

/**
 * ...
 * @author Rabia Haffar
 */
class Timers {
    public function new() {}
    
    public var t1: Float = window.performance.now();
    public var t2: Float = 0;
    public var rdt: Float = 0;
    
    public function interval(f: haxe.Constraints.Function, ms: Float): Int {
        return window.setInterval(f, ms);
    }
    
    public function timer(f: haxe.Constraints.Function, fps: Float): Int {
        return window.setInterval(f, 1000 / fps);
    }
    
    public function animate(f: Float -> Void): Int {
        return window.requestAnimationFrame(f);
    }
    
    public function countdown(f: haxe.Constraints.Function, ms: Float): Int {
        return window.setTimeout(f, ms);
    }
    
    public function pause(t: Int): Void {
        window.clearTimeout(t);
        window.clearInterval(t);
        window.cancelAnimationFrame(t);
    }
    
    public function dt(): Float {
        t2 = window.performance.now();
        rdt = t2 - t1;
        t1 = t2;
        return rdt;
    }
    
    public function fps(): Float {
        return 1000 / dt();
    }
}
