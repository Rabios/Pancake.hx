package pancake;

import Reflect;
import Math;
import pancake.Pancake;

/**
 * ...
 * @author Rabia Haffar
 */
class Physics {
    public function new() {}
    
    public function checkCollisionRecs(x1: Float, y1: Float, w1: Float, h1: Float, x2: Float, y2: Float, w2: Float, h2: Float): Bool {
        return (x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2);
    }
    
    public function checkCollisionCircles(x1: Float, y1: Float, r1: Float, x2: Float, y2: Float, r2: Float): Bool {
        function f(a: Float, b: Float): Float { return Math.pow(a, b); }
        return (Math.sqrt(f(x1 - x2, 2) + f(y1 - y2, 2)) <= r1 + r2);
    }
    
    public function checkCollisionCircleRect(x1: Float, y1: Float, r: Float, x2: Float, y2: Float, w: Float, h: Float): Bool {
        function f(a: Float): Float { return Math.abs(a); }
        function o(a: Float, b: Float): Float { return Math.pow(a, b); }
        var v: Float = f(x1 - x2 - w / 2);
        var q: Float = f(y1 - y2 - h / 2);
        if (v > (w / 2 + r) || q > (h / 2 + r)) { return false; }
        if (v <= (w / 2) || q <= (h / 2)) { return true; }
        return (o(v - w / 2, 2) + o(q - h / 2, 2) <= o(r, 2));
    }
    
    public function checkCollisionCircleLine(x: Float, y: Float, r: Float, fx: Float, fy: Float, tx: Float, ty: Float): Bool {
        var dist: Float;
        function f(a: Float, b: Float): Float { return Math.pow(a, b); }
        var q: Float = ((x - fx) * (tx - fx) + (y - fy) * (ty - fy)) / (f(ty - fy, 2) + f(tx - fx, 2));
        if (q >= 0 && q <= 1) dist = f((fx + (tx - fx) * q - x), 2) + f((fy + (ty - fy) * q - y), 2);
        else {
            if (q < 0) dist = f((fx - x), 2) + f((fy - y), 2);
            else dist = f((tx - x), 2) + f((ty - y), 2);
        }
        return (dist < f(r, 2));
    }
    
    public function checkCollisionLines(fx1: Float, fy1: Float, tx1: Float, ty1: Float, fx2: Float, fy2: Float, tx2: Float, ty2: Float): Bool {
        var v: Float = ((tx2 - fx2) * (fy1 - fy2) - (ty2 - fy2) * (fx1 - fx2)) / ((ty2 - fy2) * (tx1 - fx1) - (tx2 - fx2) * (ty1 - fy1));
        var q: Float = ((tx1 - fx1) * (fy1 - fy2) - (ty1 - fy1) * (fx1 - fx2)) / ((ty2 - fy2) * (tx1 - fx1) - (tx2 - fx2) * (ty1 - fy1));
        return (v >= 0 && v <= 1 && q >= 0 && q <= 1);
    }
    
    public function checkCollisionRectLine(x: Float, y: Float, w: Float, h: Float, x1: Float, y1: Float, x2: Float, y2: Float): Bool {
        var v: Bool = checkCollisionLines(x1, y1, x2, y2, x, y, x, y + h);
        var f: Bool = checkCollisionLines(x1, y1, x2, y2, x + w, y, x + w, y + h);
        var q: Bool = checkCollisionLines(x1, y1, x2, y2, x, y, x + w, y);
        var o: Bool = checkCollisionLines(x1, y1, x2, y2, x, y + h, x + w, y + h);
        return (v || f || q || o);
    }
    
    public function checkCollisionPoints(p1x: Float, p1y: Float, p2x: Float, p2y: Float): Bool {
        return (p1x == p2x && p1y == p2y);
    }
    
    public function checkCollisionRectPoint(x: Float, y: Float, w: Float, h: Float, px: Float, py: Float): Bool {
        return (px >= x && px <= x + w && py >= y && py <= y + h);
    }
    
    public function checkCollisionCirclePoint(x: Float, y: Float, r: Float, px: Float, py: Float): Bool {
        var q: Float = px - x;
        var f: Float = py - y;
        var v: Float = Math.sqrt((q * q) + (f * f));
        return (v <= r);
    }
    
    public function checkCollisionLinePoint(x1: Float, y1: Float, x2: Float, y2: Float, px: Float, py: Float): Bool {
        function z(x1: Float, y1: Float, x2: Float, y2: Float): Float { return js.lib.Math.hypot(x2 - x1, y2 - y1); }
        var q: Float = z(px, py, x1, y1);
        var v: Float = z(px, py, x2, y2);
        var f: Float = z(x1, y1, x2, y2);
        return (q + v >= f - 0.1 && q + v <= f + 0.1);
    }
    
    public function checkCollisionTriangles(t1x1: Float, t1y1: Float, t1x2: Float, t1y2: Float, t1x3: Float, t1y3: Float, t2x1: Float, t2y1: Float, t2x2: Float, t2y2: Float, t2x3: Float, t2y3: Float): Bool {
        return (checkCollisionTriangleLine(t1x1, t1y1, t1x2, t1y2, t1x3, t1y3, t2x1, t2y1, t2x2, t2y2) ||
                checkCollisionTriangleLine(t1x1, t1y1, t1x2, t1y2, t1x3, t1y3, t2x2, t2y2, t2x3, t2y3) ||
                checkCollisionTriangleLine(t1x1, t1y1, t1x2, t1y2, t1x3, t1y3, t2x3, t2y3, t2x1, t2y1));
    }
    
    public function checkCollisionTriangleRect(x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float, x: Float, y: Float, w: Float, h: Float): Bool {
        return (checkCollisionTriangleLine(x1, y1, x2, y2, x3, y3, x, y, x + w, y + h) || checkCollisionTrianglePoint(x1, y1, x2, y2, x3, y3, x, y));
    }
    
    public function checkCollisionTriangleLine(tx1: Float, ty1: Float, tx2: Float, ty2: Float, tx3: Float, ty3: Float, x1: Float, y1: Float, x2: Float, y2: Float): Bool {
        return (checkCollisionLines(x1, y1, x2, y2, tx1, ty1, tx2, ty2) ||
                checkCollisionLines(x1, y1, x2, y2, tx2, ty2, tx3, ty3) ||
                checkCollisionLines(x1, y1, x2, y2, tx3, ty3, tx1, ty1));
    }
    
    public function checkCollisionTrianglePoint(x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float, px: Float, py: Float): Bool {
        function z(a: Float): Float { return Math.abs(a); }
        var v: Float = z((x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1));
        var f: Float = z((x1 - px) * (y2 - py) - (x2 - px) * (y1 - py));
        var q: Float = z((x2 - px) * (y3 - py) - (x3 - px) * (y2 - py));
        var o: Float = z((x3 - px) * (y1 - py) - (x1 - px) * (y3 - py));
        return (f + q + o == v);
    }
    
    public function checkCollisionTriangleCircle(x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float, cx: Float, cy: Float, r: Float): Bool {
        return (checkCollisionTrianglePoint(x1, y1, x2, y2, x3, y3, cx, cy) ||
                checkCollisionCircleLine(cx, cy, r, x1, y1, x2, y2) ||
                checkCollisionCircleLine(cx, cy, r, x2, y2, x3, y3) ||
                checkCollisionCircleLine(cx, cy, r, x3, y3, x1, y1));
    }
    
    public function checkCollisionPolygonPoint(points: Array<Dynamic>, x: Float, y: Float): Bool {
        var v: Bool = false;
        var f: Int = 0;
        for (i in 0...points.length) {
            f = i+1;
            if (f == points.length) f = 0;
            var q: Dynamic = points[i];
            var z: Dynamic = points[f];
            v = (((q.y >= y && z.y < y) || (q.y < y && z.y >= y)) && (x < (z.x - q.x) * (y - q.y) / (z.y - q.y) + q.x));
        }
        return v;
    }
    
    public function checkCollisionPolygonLine(points: Array<Dynamic>, x1: Float, y1: Float, x2: Float, y2: Float): Bool {
        var f: Int = 0;
        var v: Bool = false;
        for (i in 0...points.length) {
            f = i+1;
            if (f == points.length) f = 0;
            var q: Dynamic = points[i];
            var z: Dynamic = points[f];
            v = checkCollisionLines(x1, y1, x2, y2, q.x, q.y, z.x, z.y);
        }
        return v;
    }
    
    public function checkCollisionPolygonRect(points: Array<Dynamic>, x: Float, y: Float, w: Float, h: Float): Bool {
        var f: Int = 0;
        var v: Bool = false;
        for (i in 0...points.length) {
            f = i+1;
            if (f == points.length) f = 0;
            var q: Dynamic = points[i];
            var z: Dynamic = points[f];
            v = (checkCollisionRectLine(q.x, q.y, z.x, z.y, x, y, w, h) || checkCollisionPolygonPoint(points, x, y));
        }
        return v;
    }
    
    public function checkCollisionPolygons(p1_points: Array<Dynamic>, p2_points: Array<Dynamic>): Bool {
        var f: Int = 0;
        var v: Bool = false;
        for (i in 0...p1_points.length) {
            f = i+1;
            if (f == p1_points.length) f = 0;
            var q: Dynamic = p1_points[i];
            var z: Dynamic = p1_points[f];
            return (checkCollisionPolygonLine(p2_points, q.x, q.y, z.x, z.y) || checkCollisionPolygonPoint(p1_points, p2_points[0].x, p2_points[0].y));
        }
        return v;
    }
    
    public function checkCollisionPolygonCircle(points: Array<Dynamic>, x: Float, y: Float, r: Float): Bool {
        var f: Int = 0;
        var v: Bool = false;
        for (i in 0...points.length) {
            f = i+1;
            if (f == points.length) f = 0;
            var q: Dynamic = points[i];
            var z: Dynamic = points[f];
            v = (checkCollisionCircleLine(x, y, r, q.x, q.y, z.x, z.y) || checkCollisionPolygonPoint(points, x, y));
        }
        return v;
    }
    
    public function checkCollisionPolygonTriangle(points: Array<Dynamic>, x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float): Bool {
        return checkCollisionPolygons(points, [ { x: x1, y: y1 }, { x: x2, y: y2 }, { x: x3, y: y3 } ]);
    }
    
    public function checkCollisionLeftCanvas(s: Dynamic): Bool {
        var v: Bool = false;
        if (Reflect.hasField(s, "w")) {
            v = (s.x <= s.w / 2);
        }
        if (Reflect.hasField(s, "r")) {
            v = (s.x + s.vx < s.r);
        }
        return v;
    }
    
    public function checkCollisionRightCanvas(s: Dynamic, canvas_index: Int = 0): Bool {
        var v: Bool = false;
        if (Reflect.hasField(s, "w")) {
            v = (s.x + s.w >= Pancake.canvases[canvas_index].width + s.w / 2);
        }
        if (Reflect.hasField(s, "r")) {
            v = (s.x + s.vx > Pancake.canvases[canvas_index].width - s.r);
        }
        return v;
    }
    
    public function checkCollisionTopCanvas(s: Dynamic): Bool {
        var v: Bool = false;
        if (Reflect.hasField(s, "h")) {
            v = (s.y <= s.h / 2);
        }
        if (Reflect.hasField(s, "r")) {
            v = (s.y + s.vy < s.r);
        }
        return v;
    }
    
    public function checkCollisionBottomCanvas(s: Dynamic, canvas_index: Int = 0): Bool {
        var v: Bool = false;
        if (Reflect.hasField(s, "h")) {
            v = (s.y + s.h >= Pancake.canvases[canvas_index].height + s.h / 2);
        }
        if (Reflect.hasField(s, "r")) {
            v = (s.y + s.vy > Pancake.canvases[canvas_index].height - s.r);
        }
        return v;
    }
    
    public function distanceBetween(x1: Float, y1: Float, x2: Float, y2: Float): Float {
        return js.lib.Math.hypot(x2 - x1, y2 - y1);
    }
    
    public function getDistance(x1: Float, y1: Float, x2: Float, y2: Float): Dynamic {
        return { x: x2 - x1, y: y2 - y1 };
    }
}
