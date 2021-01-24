package pancake;

import Std;
import haxe.extern.EitherType;
import js.html.VideoElement;
import js.Browser.document;
import js.html.Image;
import js.html.CanvasRenderingContext2D;
import js.html.CanvasElement;
import js.html.webgl.RenderingContext;
import js.html.webgl.GL;
import js.html.webgl.Buffer;
import js.html.webgl.Program;
import js.html.webgl.Shader;
import js.html.Float32Array;
import js.lib.Math;
import pancake.Pancake;
import pancake.Mode;

/**
 * ...
 * @author Rabia Haffar
 */
@:native("document")
extern class Document {
    public static var fullscreen: Bool;
    public static var webkitIsFullScreen: Bool;
    public static var mozFullScreen: Bool;
    public static function exitFullscreen(): Void;
    public static function mozCancelFullScreen(): Void;
    public static function webkitExitFullscreen(): Void;
    public static function webkitCancelFullScreen(): Void;
    public static function msExitFullscreen(): Void;
    public static var onmozfullscreenchange: haxe.Constraints.Function;
    public static var onmsfullscreenchange: haxe.Constraints.Function;
    public static var onwebkitfullscreenchange: haxe.Constraints.Function;
}

extern class JS_String extends String {
    @:native("String.prototype") extern public function match(reg_exp: String): Array<String>;
}

class CanvasElementExtended extends CanvasElement {
    extern public function mozRequestFullScreen(): Any;
    extern public function webkitRequestFullscreen(): Any;
    extern public function webkitRequestFullScreen(): Any;
    extern public function msRequestFullscreen(): Any;
}

class Random {
    public function new() {}
    
    public function alpha(): Float {
        return Math.random();
    }
    
    #if PANCAKE_CANVAS2D
    public function RGB(): String {
        return ("rgb(" + Std.random(255) + "," + Std.random(255) + "," + Std.random(255) + ")");
    }
    
    public function RGBA(): String {
        return ("rgba(" + Std.random(255) + "," + Std.random(255) + "," + Std.random(255) + "," + Std.random(255) + ")");
    }
    
    public function HSL(): String {
        return ("hsl(" + Std.random(361) + "," + Std.random(100) + "%," + Std.random(100) + "%)");
    }
    
    public function HSLA(): String {
        return ("hsl(" + Std.random(361) + "," + Std.random(100) + "%," + Std.random(100) + "%," + Math.random() + ")");
    }
    #elseif PANCAKE_WEBGL
    public function RGB(): Array<Float> {
        return [Math.random(), Math.random(), Math.random(), 1];
    }
    
    public function RGBA(): Array<Float> {
        return [Math.random(), Math.random(), Math.random(), Math.random()];
    }
    
    public function HSL(): Array<Float> {
        return [Std.random(361), Math.random(), Math.random(), 1];
    }
    
    public function HSLA(): Array<Float> {
        return [Std.random(361), Math.random(), Math.random(), Math.random()];
    }
    #end
}

class Graphics {
    public var FILL: Int = Mode.FILL;
    public var STROKE: Int = Mode.STROKE;
    public var BOTH: Int = Mode.BOTH;
    public var fits: Bool = false;
    public var scissor: Bool = true;
    public var random: Random = new Random();
    public var tint: EitherType<String, Array<Float>>;
    public var backend: String;
    public var context: EitherType<CanvasRenderingContext2D, js.html.webgl.RenderingContext>;
    public var canvas: CanvasElement;
    public var mode: Int;
    
    // specified variables for WebGL rendering backend (They remain null when using Canvas2D rendering backend)
    #if PANCAKE_WEBGL
    public static var ctx2d: CanvasRenderingContext2D = null;
    public static var ctx2d_enabled: Bool = null;
    private static var program: Program = null;
    private var fillColor: Array<Float> = null;
    private var strokeColor: Array<Float> = null;
    private var alpha: Float = null;
    
    private static var animation: Bool = null;
    private static var texture: Bool = null;
    private static var primitives_vertex_count: Int = null;
    private static var primitives_mode: Int = null;
    private static var texBuffer: Buffer = null;
    private static var texRect: Buffer = null;
    private static var texTex: Image = null;
    private static var vidBuffer: Buffer = null;
    private static var vidRect: Buffer = null;
    private static var vidTex: VideoElement = null;
    #end
    
    public function new() {
        mode = FILL;
        #if PANCAKE_CANVAS2D
        backend = "CanvasRenderingContext2D";
        tint = null;
        #elseif PANCAKE_WEBGL
        backend = "WebGLRenderingContext";
        tint = [1, 1, 1, alpha];
        alpha = 1;
        fillColor = [ 0, 0, 0, alpha ];
        strokeColor = [ 0, 0, 0, alpha ];
        texture = false;
        animation = false;
        #end
        
        #if (PANCAKE_CANVAS2D || PANCAKE_WEBGL)
        js.Browser.window.console.log("Made with Pancake " + Pancake.version + "\nhttps://github.com/Rabios/Pancake\nRenderer: " + backend);
        #end
        
        #if PANCAKE_CANVAS2D
        document.onfullscreenchange = Document.onmozfullscreenchange = Document.onmsfullscreenchange = Document.onwebkitfullscreenchange = function () {
            if (fullscreen() && canvas != null) {
                canvas.width = js.Browser.window.innerWidth;
                canvas.height = js.Browser.window.innerHeight;
            }
                
            if (!fullscreen() && canvas != null) {
                if (fits) {
                    canvas.width = js.Browser.window.innerWidth;
                    canvas.height = js.Browser.window.innerHeight;
                } else {
                    canvas.width = Canvas.compatible_width;
                    canvas.height = Canvas.compatible_height;
                }
            }
        };
        
        #elseif PANCAKE_WEBGL
        document.onfullscreenchange = Document.onmozfullscreenchange = Document.onmsfullscreenchange = Document.onwebkitfullscreenchange = function () {
            if (fullscreen() && canvas != null) {
                canvas.width = js.Browser.window.innerWidth;
                canvas.height = js.Browser.window.innerHeight;
                
                if (ctx2d_enabled && ctx2d.canvas != null) {
                    ctx2d.canvas.width = js.Browser.window.innerWidth;
                    ctx2d.canvas.height = js.Browser.window.innerHeight;
                }
            }
            
            if (!fullscreen() && canvas != null) {
                if (fits) {
                    canvas.width = js.Browser.window.innerWidth;
                    canvas.height = js.Browser.window.innerHeight;
                } else {
                    canvas.width = Canvas.compatible_width;
                    canvas.height = Canvas.compatible_height;
                }
                
                if (ctx2d_enabled && canvas != null) {
                    if (fits) {
                        ctx2d.canvas.width = js.Browser.window.innerWidth;
                        ctx2d.canvas.height = js.Browser.window.innerHeight;
                    } else {
                        ctx2d.canvas.width = Canvas.compatible_width;
                        ctx2d.canvas.height = Canvas.compatible_height;
                   }
                }
            }
        };
        #end
    }
    
    #if PANCAKE_WEBGL
    private function loadWebGLProgram(vsCode: String, fsCode: String): Program {
        var ctx: RenderingContext = cast(context, RenderingContext);
        var vertex_shader: Shader = ctx.createShader(GL.VERTEX_SHADER);
        ctx.shaderSource(vertex_shader, vsCode);
        ctx.compileShader(vertex_shader);
        var fragment_shader: Shader = ctx.createShader(GL.FRAGMENT_SHADER);
        ctx.shaderSource(fragment_shader, fsCode);
        ctx.compileShader(fragment_shader);
        var program: Program = ctx.createProgram();
        ctx.attachShader(program, vertex_shader);
        ctx.attachShader(program, fragment_shader);
        ctx.linkProgram(program);
        ctx.useProgram(program);
        ctx.deleteShader(vertex_shader);
        ctx.deleteShader(fragment_shader);
        ctx.deleteProgram(program);
        return program;    
    }
    
    private function loadWebGLDefaults(): Void {
        var ctx: RenderingContext = cast(context, RenderingContext);
        ctx.uniform1i(ctx.getUniformLocation(program, "u_mode"), 1);
        ctx.vertexAttrib4fv(ctx.getAttribLocation(program, "a_color"), fillColor);
        ctx.uniform2f(ctx.getUniformLocation(program, "u_resolution"), ctx.canvas.width, ctx.canvas.height);
        ctx.uniform2f(ctx.getUniformLocation(program, "u_translation"), 0, 0);
        ctx.uniform2f(ctx.getUniformLocation(program, "u_rotation"), 0, 1);
        ctx.uniform2f(ctx.getUniformLocation(program, "u_scale"), 1, 1);
    }
    
    private static function enableVertexAttribute(attrib_loc: String, buffer: Buffer, prim_vert_count: Int): Int {
        var ctx: RenderingContext = cast(context, RenderingContext);
        ctx.bindBuffer(GL.ARRAY_BUFFER, buffer);
        var t: Int = ctx.getAttribLocation(program, attrib_loc);
        ctx.vertexAttribPointer(t, prim_vert_count, GL.FLOAT, false, 0, 0);
        ctx.enableVertexAttribArray(t);
        return t;
    }
    
    private function embedCanvas2D(): CanvasRenderingContext2D {
        if (ctx2d_enabled) {
            var can: CanvasElement = document.createCanvasElement();
            var ctx: RenderingContext = cast(context, RenderingContext);
            can.width = ctx.canvas.width;
            can.height = ctx.canvas.height;
            can.style.position = "relative";
            can.style.zIndex = "1";
            document.body.appendChild(can);
            return can.getContext2d();
        }
        return null;
    }
    
    private static function loadBuffer(buffer_content: Array<Float>): Buffer {
        var ctx: RenderingContext = cast(context, RenderingContext);
        var buf = ctx.createBuffer();
        ctx.bindBuffer(GL.ARRAY_BUFFER, buf);
        ctx.bufferData(GL.ARRAY_BUFFER, new js.lib.Float32Array(buffer_content), GL.STATIC_DRAW);
        ctx.bindBuffer(GL.ARRAY_BUFFER, null);
        return buf;
    }
    
    private function bindBuffer(buffer: Buffer): Void {
        cast(context, RenderingContext).bindBuffer(GL.ARRAY_BUFFER, buffer);
    }
    
    private function loadRectBuffer(x: Float, y: Float, w: Float, h: Float): Array<Float> {
        texture = false;
        animation = false;
        primitives_vertex_count = 4;
        primitives_mode = (mode == FILL) ? GL.TRIANGLE_FAN : GL.LINE_LOOP;
        return [
            x, y,
            x + w, y,
            x + w, y + h,
            x, y + h
        ];
    }
    
    private function loadLineBuffer(x1: Float, y1: Float, x2: Float, y2: Float): Array<Float> {
        texture = false;
        animation = false;
        primitives_vertex_count = 2;
        primitives_mode = GL.LINES;
        return [ x1, y1, x2, y2 ];
    }
    
    private function loadTriangleBuffer(x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float): Array<Float> {
        texture = false;
        animation = false;
        primitives_vertex_count = 3;
        primitives_mode = (mode == FILL) ? GL.TRIANGLES : GL.LINE_LOOP;
        return [ x1, y1, x2, y2, x3, y3 ];
    }
    
    private function loadPointBuffer(x: Float, y: Float): Array<Float> {
        texture = false;
        animation = false;
        primitives_vertex_count = 1;
        primitives_mode = GL.POINTS;
        return [ x, y ];
    }
    
    private static function loadImageBuffer(sx: Float, sy: Float, sw: Float, sh: Float, dx: Float, dy: Float, dw: Float, dh: Float): Void {
        texture = true;
        animation = false;
        primitives_vertex_count = 6;
        primitives_mode = GL.TRIANGLES;
    
        var sx: Float = sx != null ? sx : 0;
        var sy: Float = sy != null ? sy : 0;
        var sw: Float = sw != null ? sw : texTex.width;
        var sh: Float = sh != null ? sh : texTex.height;
    
        var x1: Float = (dx != null ? dx : sx);
        var x2: Float = x1 + (dw != null ? dw : sw);
        var y1: Float = (dy != null ? dy : sy);
        var y2: Float = y1 + (dh != null ? dh : sh);
    
        var w: Int = texTex.width;
        var h: Int = texTex.height;
    
        var ix1: Float = sx / w;
        var ix2: Float = (sx + sw) / w;
        var iy1: Float = sy / h;
        var iy2: Float = (sy + sh) / h;
    
        texBuffer = loadBuffer([
            ix1, iy1,
            ix2, iy1,
            ix1, iy2,
            ix1, iy2,
            ix2, iy1,
            ix2, iy2,
        ]);
    
        texRect = loadBuffer([
            x1, y1,
            x2, y1,
            x1, y2,
            x1, y2,
            x2, y1,
            x2, y2,
        ]);
    }
    
    private function loadVideoBuffer(sx: Float, sy: Float, sw: Float, sh: Float, dx: Float, dy: Float, dw: Float, dh: Float): Void {
        texture = false;
        animation = true;
        primitives_vertex_count = 6;
        primitives_mode = GL.TRIANGLES;
    
        var sx: Float = sx != null ? sx : 0;
        var sy: Float = sy != null ? sy : 0;
        var sw: Float = sw != null ? sw : cast(vidTex, Image).width;
        var sh: Float = sh != null ? sh : cast(vidTex, Image).height;
    
        var x1: Float = (dx != null ? dx : sx);
        var x2: Float = x1 + (dw != null ? dw : sw);
        var y1: Float = (dy != null ? dy : sy);
        var y2: Float = y1 + (dh != null ? dh : sh);
    
        var w: Int = cast(vidTex, Image).width;
        var h: Int = cast(vidTex, Image).height;
    
        var ix1: Float = sx / w;
        var ix2: Float = (sx + sw) / w;
        var iy1: Float = sy / h;
        var iy2: Float = (sy + sh) / h;
    
        vidBuffer = loadBuffer([
            ix1, iy1,
            ix2, iy1,
            ix1, iy2,
            ix1, iy2,
            ix2, iy1,
            ix2, iy2,
        ]);
    
        vidRect = loadBuffer([
            x1, y1,
            x2, y1,
            x1, y2,
            x1, y2,
            x2, y1,
            x2, y2,
        ]);
    }
    
    // https://convertingcolors.com/blog/article/convert_hex_to_rgb_with_javascript.html
    private function HEX2RGB(hex: String): Array<Float> {
        if (hex.length != 6){
            return [ 0, 0, 0, 0 ];
        }
        var aRgbHex: Array<String> = cast(hex, JS_String).match("/.{1,2}/g");
        var aRgb: Array<Float> = [
            js.Lib.parseInt(aRgbHex[0], 16),
            js.Lib.parseInt(aRgbHex[1], 16),
            js.Lib.parseInt(aRgbHex[2], 16),
            alpha
        ];
        
        return aRgb;
    }
    
    private function HUE2RGB(h: Float, u: Float, e: Float): Float {
        if (e < 0) e += 1;
        if (e > 1) e -= 1;
        if (e < 1/6) return h + (u - h) * 6 * e;
        if (e < 1/2) return u;
        if (e < 2/3) return h + (u - h) * (2/3 - e) * 6;
        return h;
    }

    // https://gist.github.com/mjackson/5311256#file-color-conversion-algorithms-js-L36
    private function HSL2RGB(h: Float, s: Float, l: Float): Array<Int> {
        var r: Float;
        var g: Float;
        var b: Float;
        if (s == 0) {
            r = g = b = l; // achromatic
        } else {
            var q: Float = l < 0.5 ? l * (1 + s) : l + s - l * s;
            var p: Float = 2 * l - q;
            
            r = HUE2RGB(p, q, h + 1/3);
            g = HUE2RGB(p, q, h);
            b = HUE2RGB(p, q, h - 1/3);
        }
  
        return [ cast(r * 255, Int), cast(g * 255, Int), cast(b * 255, Int), 255 ];
    }

    private function HSLA2RGBA(h: Float, s: Float, l: Float, a: Float): Array<Int> {
        var r: Float;
        var g: Float;
        var b: Float;
  
        if (s == 0) {
            r = g = b = a = l; // achromatic
        } else {
            var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
            var p = 2 * l - q;
  
            r = HUE2RGB(p, q, h + 1/3);
            g = HUE2RGB(p, q, h);
            b = HUE2RGB(p, q, h - 1/3);
        }
  
        return [ cast(r * 255, Int), cast(g * 255, Int), cast(b * 255, Int), (a >= 0 && a <= 1) ? cast(a * 255, Int) : 255 ];
    }

    // Converts RGBA color from WebGL context to canvas2d context RGBA color from array!
    private static function convertColorToCanvas2D(rgba_arr: Array<Float>): String {
        if (ctx2d_enabled) return "rgba(" + (rgba_arr[0] * 255) + "," + (rgba_arr[1] * 255) + "," + (rgba_arr[2] * 255) + "," + (rgba_arr[3] * 255) + ")";
        return null;
    }
    
    private function useColor(color: Array<Float>): Void {
        var ctx: RenderingContext = cast(context, RenderingContext);
        ctx.uniform4f(ctx.getUniformLocation(program, "u_color"), color[0], color[1], color[2], color[3]);
    }
    #end
    
    private function render(?buffer: Buffer = null): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        if (mode == FILL) ctx.fill();
        if (mode == STROKE) ctx.stroke();
        if (mode == BOTH) {
            ctx.fill();
            ctx.stroke();
        }
        #elseif PANCAKE_WEBGL
        if (buffer != null) {
            var ctx: RenderingContext = cast(context, RenderingContext);
            ctx.uniform1i(ctx.getUniformLocation(program, "u_mode"), 1);
            enableVertexAttribute("a_position", buffer, 2);
            if (texture) {
                ctx.uniform1i(ctx.getUniformLocation(program, "u_mode"), 2);
                enableVertexAttribute("a_texCoord", texBuffer, 2);
            }
            if (animation) {
                ctx.uniform1i(ctx.getUniformLocation(program, "u_mode"), 2);
                enableVertexAttribute("a_texCoord", vidBuffer, 2);
            }
            ctx.drawArrays(primitives_mode, 0, primitives_vertex_count);
            ctx.uniform1i(ctx.getUniformLocation(program, "u_mode"), 1);
        }
        #end
    }
    
    public function fit(): Void {
        canvas.style.position = "absolute";
        canvas.style.left = canvas.style.top = "0px";
        canvas.width = cast(Canvas.compatible_width + 20, Int);
        canvas.height = cast(Canvas.compatible_height + 20, Int);
        #if PANCAKE_WEBGL
        if (ctx2d_enabled) {
            ctx2d.canvas.style.position = "absolute";
            ctx2d.canvas.style.left = ctx2d.canvas.style.top = "0px";
            ctx2d.canvas.width = cast(Canvas.compatible_width + 20, Int);
            ctx2d.canvas.height = cast(Canvas.compatible_height + 20, Int);
        }
        #end
        fits = true;
    }
    
    public function fullscreen(): Bool {
        return (Document.fullscreen || Document.webkitIsFullScreen || Document.mozFullScreen);
    }
    
    public function toggleFullscreen(): Void {
        if (canvas.requestFullscreen != null) canvas.requestFullscreen();
        var can: CanvasElementExtended = cast(canvas, CanvasElementExtended);
        if (can.mozRequestFullScreen != null) can.mozRequestFullScreen();
        if (can.webkitRequestFullscreen != null) can.webkitRequestFullscreen();
        if (can.webkitRequestFullScreen != null) can.webkitRequestFullScreen();
        if (can.msRequestFullscreen != null) can.msRequestFullscreen();
    }
    
    public function exitFullscreen(): Void {
        if (Document.exitFullscreen != null) Document.exitFullscreen();
        if (Document.mozCancelFullScreen != null) Document.mozCancelFullScreen();
        if (Document.webkitCancelFullScreen != null) Document.webkitCancelFullScreen();
        if (Document.webkitExitFullscreen != null) Document.webkitExitFullscreen();
        if (Document.msExitFullscreen != null) Document.msExitFullscreen();
    }
    
    public function useContext(context_index: Int): Void {
        #if PANCAKE_CANVAS2D
        context = cast(Pancake.contexts[context_index], CanvasRenderingContext2D);
        canvas = Pancake.contexts[context_index].canvas;
        #elseif PANCAKE_WEBGL
        context = cast(Pancake.contexts[context_index], RenderingContext);
        canvas = Pancake.contexts[context_index].canvas;
        canvas.style.position = "absolute";
        canvas.style.zIndex = "0px";
        program = loadWebGLProgram("precision lowp float;\nattribute vec2 a_position;\nattribute vec2 a_texCoord;\nvarying vec2 v_texCoord;\nuniform vec2 u_resolution;\nuniform vec2 u_translation;\nuniform vec2 u_rotation; \nuniform vec2 u_scale;\nattribute vec4 a_color;\nvarying vec4 v_color;\nvoid main() {\n\t v_color = a_color;\n    vec2 scaledPosition = a_position * u_scale;\n    vec2 rotatedPosition = vec2(scaledPosition.x * u_rotation.y + scaledPosition.y * u_rotation.x, scaledPosition.y * u_rotation.y - scaledPosition.x * u_rotation.x);\n    vec2 position = rotatedPosition + u_translation;\n    vec2 zeroToOne = position / u_resolution;\n    vec2 zeroToTwo = zeroToOne * 2.0;\n    vec2 clipSpace = zeroToTwo - 1.0;\n    gl_PointSize = 2.0;\n    gl_Position = vec4(clipSpace * vec2(1, -1), 0, 1);\n    v_texCoord = a_texCoord;\n}\n", "precision lowp float;\nvarying vec4 v_color;\nuniform int u_mode;\nuniform sampler2D u_image;\nvarying vec2 v_texCoord;\nvoid main(void) {\n    if (u_mode == 1) { gl_FragColor = v_color; }\n    if (u_mode == 2) { gl_FragColor = texture2D(u_image, v_texCoord) * v_color; }\n}\n");
        if (ctx2d_enabled) {
            ctx2d = embedCanvas2D();
        }
        loadWebGLDefaults();
        clear();
        #end
    }
    
    public function setContext(_context: Dynamic, context_index: Int): Void {
        context = _context;
        canvas = _context.canvas;
        #if PANCAKE_WEBGL
        canvas.style.zIndex = "0";
        #end
        Pancake.contexts[context_index] = _context;
    }
    
    public function setAlpha(a: Float): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        ctx.globalAlpha = a;
        #elseif PANCAKE_WEBGL
        alpha = a;
        #end
    }
    
    public function RGB(r: Int, g: Int, b: Int): EitherType<String, Array<Float>> {
        #if PANCAKE_CANVAS2D
        return "rgb(" + r + "," + g + "," + b + ")";
        #elseif PANCAKE_WEBGL
        return [r / 255, g / 255, b / 255, 1];
        #end
        return null;
    }
    
    public function RGBA(r: Int, g: Int, b: Int, a: Int): EitherType<String, Array<Float>> {
        #if PANCAKE_CANVAS2D
        return "rgb(" + r + "," + g + "," + b + "," + a + ")";
        #elseif PANCAKE_WEBGL
        return [r / 255, g / 255, b / 255, a / 255];
        #end
        return null;
    }
    
    public function HSL(h: Float, s: Float, l: Float): EitherType<String, Array<Float>> {
        #if PANCAKE_CANVAS2D
        return "hsl(" + h + "," + s + "%," + l + "%)";
        #elseif PANCAKE_WEBGL
        return RGB(HSL2RGB(h / 360, s, l)[0], HSL2RGB(h / 360, s, l)[1], HSL2RGB(h / 360, s, l)[2]);
        #end
        return null;
    }
    
    public function HSLA(h: Int, s: Float, l: Float, a: Float): EitherType<String, Array<Float>> {
        #if PANCAKE_CANVAS2D
        return "hsla(" + h + "," + s + "%," + l + "%," + a + ")";
        #elseif PANCAKE_WEBGL
        return RGBA(HSLA2RGBA(h / 360, s, l, a)[0], HSLA2RGBA(h / 360, s, l, a)[1], HSLA2RGBA(h / 360, s, l, a)[2], HSLA2RGBA(h / 360, s, l, a)[3]);
        #end
        return null;
    }
    
    public function HEX(hex: String): EitherType<String, Array<Float>> {
        #if PANCAKE_CANVAS2D
        return "#" + hex;
        #elseif PANCAKE_WEBGL
        return RGB(cast(HEX2RGB(hex)[0] * 255, Int), cast(HEX2RGB(hex)[1] * 255, Int), cast(HEX2RGB(hex)[2] * 255, Int));
        #end
        return null;
    }
    
    public function color(fill: EitherType<String, Array<Float>>, ?stroke: EitherType<String, Array<Float>>): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        ctx.fillStyle = cast(fill, String);
        ctx.strokeStyle = cast(stroke, String);
        #elseif PANCAKE_WEBGL
        fill[3] = fill[3] != null ? fill[3] : alpha;
        fillColor = [fill[0], fill[1], fill[2], fill[3]];
        if (ctx2d_enabled) ctx2d.fillStyle = convertColorToCanvas2D(fillColor);
        if (stroke != null) {
            stroke[3] = stroke[3] != null ? stroke[3] : alpha;
            strokeColor = [stroke[0], stroke[1], stroke[2], stroke[3]];
            if (ctx2d_enabled) ctx2d.strokeStyle = convertColorToCanvas2D(strokeColor);
        } else {
            strokeColor = [0, 0, 0, alpha];
            if (ctx2d_enabled) ctx2d.strokeStyle = convertColorToCanvas2D(strokeColor);
        }
        #end
    }
    
    public function setBackgroundColor(color: String): Void {
        canvas.style.backgroundColor = color;
        canvas.style.backgroundSize = (canvas.width + "px " + canvas.height + "px");
    }
    
    public function setBackgroundImage(src: String): Void {
        canvas.style.backgroundImage = "url(" + src + ")";
        canvas.style.backgroundSize = (canvas.width + "px " + canvas.height + "px");
    }
    
    public function setBackground(background: Any): Void {
        canvas.style.background = background;
        canvas.style.backgroundSize = (canvas.width + "px " + canvas.height + "px");
    }
    
    public function setFont(font_name: String, font_size: Int): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        ctx.font = (font_size + "px " + font_name);
        #elseif PANCAKE_WEBGL
        if (ctx2d_enabled) ctx2d.font = (font_size + "px " + font_name);
        #end
    }
    
    public function clearRect(x: Int, y: Int, w: Int, h: Int): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        ctx.clearRect(x, y, w, h);
        #elseif PANCAKE_WEBGL
        var ctx: RenderingContext = cast(context, RenderingContext);
        ctx.enable(GL.SCISSOR_TEST);
        ctx.scissor(x, y, w, h);
        ctx.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
        ctx.disable(GL.SCISSOR_TEST);
        if (ctx2d_enabled) ctx2d.clearRect(x, y, w, h);
        #end
    }
    
    public function clear(): Void {
        #if PANCAKE_CANVAS2D
        clearRect(0, 0, canvas.width, canvas.height);
        #elseif PANCAKE_WEBGL
        var ctx: RenderingContext = cast(context, RenderingContext);
        ctx.viewport(0, 0, canvas.width, canvas.height);
        var width  : Int = canvas.clientWidth  * 1 | 0;
        var height : Int = canvas.clientHeight * 1 | 0;
        if (canvas.width != width || canvas.height != height) {
            canvas.width  = width;
            canvas.height = height;
        }
        ctx.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
        if (ctx2d_enabled) ctx2d.clearRect(0, 0, ctx2d.canvas.width, ctx2d.canvas.height);
        #end
    }
    
    public function text(txt: String, x: Float, y: Float): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        if (mode == FILL) ctx.fillText(txt, x, y);
        if (mode == STROKE) ctx.strokeText(txt, x, y);
        if (mode == BOTH) {
            ctx.fillText(txt, x, y);
            ctx.strokeText(txt, x, y);
        }
        #elseif PANCAKE_WEBGL
        var ctx: RenderingContext = cast(context, RenderingContext);
        if (ctx2d_enabled) {
            if (mode == FILL) ctx2d.fillText(txt, x, y);
            if (mode == STROKE) ctx2d.strokeText(txt, x, y);
            if (mode == BOTH) {
                ctx2d.fillText(txt, x, y);
                ctx2d.strokeText(txt, x, y);
            }
        }
        #end
    }
    
    public function rect(x: Float, y: Float, w: Float, h: Float): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        ctx.beginPath();
        ctx.rect(x, y, w, h);
        ctx.closePath();
        render();
        #elseif PANCAKE_WEBGL
        if (mode == BOTH) {
            mode = FILL;
            useColor(fillColor);
            render(loadBuffer(loadRectBuffer(x, y, w, h)));
            mode = STROKE;
            useColor(strokeColor);
            render(loadBuffer(loadRectBuffer(x, y, w, h)));
            mode = BOTH;
            return;
        }
        if (mode == FILL) useColor(fillColor);
        if (mode == STROKE) useColor(strokeColor);
        render(loadBuffer(loadRectBuffer(x, y, w, h)));
        #end
    }
    
    public function roundedRect(x: Float, y: Float, w: Float, h: Float, r: Float): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        ctx.beginPath();
        ctx.moveTo(x + r, y);
        ctx.lineTo(x + w - r, y);
        ctx.quadraticCurveTo(x + w, y, x + w, y + r);
        ctx.lineTo(x + w, y + h - r);
        ctx.quadraticCurveTo(x + w, y + h, x + w - r, y + h);
        ctx.lineTo(x + r, y + h);
        ctx.quadraticCurveTo(x, y + h, x, y + h - r);
        ctx.lineTo(x, y + r);
        ctx.quadraticCurveTo(x, y, x + r, y);
        ctx.closePath();
        render();
        #elseif PANCAKE_WEBGL
        if (ctx2d_enabled) {
            ctx2d.beginPath();
            ctx2d.moveTo(x + r, y);
            ctx2d.lineTo(x + w - r, y);
            ctx2d.quadraticCurveTo(x + w, y, x + w, y + r);
            ctx2d.lineTo(x + w, y + h - r);
            ctx2d.quadraticCurveTo(x + w, y + h, x + w - r, y + h);
            ctx2d.lineTo(x + r, y + h);
            ctx2d.quadraticCurveTo(x, y + h, x, y + h - r);
            ctx2d.lineTo(x, y + r);
            ctx2d.quadraticCurveTo(x, y, x + r, y);
            ctx2d.closePath();
            if (mode == FILL) ctx2d.fill();
            if (mode == STROKE) ctx2d.stroke();
            if (mode == BOTH) {
                ctx2d.fill();
                ctx2d.stroke();
            }
        }
        #end
    }
    
    public function circle(x: Float, y: Float, r: Float): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        ctx.beginPath();
        ctx.arc(x, y, r, 90, 180 * Math.PI);
        ctx.closePath();
        render();
        #elseif PANCAKE_WEBGL
        polygon(x, y, r, cast(r * 2, Int));
        #end
    }
    
    public function line(x1: Float, y1: Float, x2: Float, y2: Float): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        ctx.beginPath();
        ctx.moveTo(x1, y1);
        ctx.lineTo(x2, y2);
        ctx.closePath();
        ctx.stroke();
        #elseif PANCAKE_WEBGL
        render(loadBuffer(loadLineBuffer(x1, y1, x2, y2)));
        #end
    }
    
    public function triangle(x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        ctx.beginPath();
        ctx.moveTo(x1, y1);
        ctx.lineTo(x2, y2);
        ctx.lineTo(x3, y3);
        ctx.lineTo(x1, y1);
        ctx.closePath();
        render();
        #elseif PANCAKE_WEBGL
        if (mode == BOTH) {
            mode = FILL;
            useColor(fillColor);
            render(loadBuffer(loadTriangleBuffer(x1, y1, x2, y2, x3, y3)));
            mode = STROKE;
            useColor(strokeColor);
            render(loadBuffer(loadTriangleBuffer(x1, y1, x2, y2, x3, y3)));
            mode = BOTH;
            return;
        }
        if (mode == FILL) useColor(fillColor);
        if (mode == STROKE) useColor(strokeColor);
        render(loadBuffer(loadTriangleBuffer(x1, y1, x2, y2, x3, y3)));
        #end
    }
    
    public function polygon(x: Float, y: Float, size: Float, sides: Int): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        var points: Array<Array<Float>> = [];
        points.push([x + size * Math.cos(0), y + size * Math.sin(0) ]);
        ctx.beginPath();
        ctx.moveTo(points[0][0], points[0][1]);
        for (i in 0...points.length) ctx.lineTo(points[i][0], points[i][1]);
        ctx.closePath();
        render();
        #elseif PANCAKE_WEBGL
        var points: Array<Float> = [];
        points.push(x + size * Math.cos(0));
        points.push(y + size * Math.sin(0));
        for (i in 1...sides + 1) {
            points.push(x + sides * Math.cos(2 * i * Math.PI / sides));
            points.push(y + size * Math.sin(2 * i * Math.PI / sides));
        }
        primitives_vertex_count = sides;
        if (mode == BOTH) {
            useColor(fillColor);
            primitives_mode = GL.TRIANGLE_FAN;
            render(loadBuffer(points));
            useColor(strokeColor);
            primitives_mode = GL.LINE_LOOP;
            render(loadBuffer(points));
        }
        if (mode == FILL) {
            useColor(fillColor);
            primitives_mode = GL.TRIANGLE_FAN;
            render(loadBuffer(points));
        }
        if (mode == STROKE) {
            useColor(strokeColor);
            primitives_mode = GL.LINE_LOOP;
            render(loadBuffer(points));
        }
        #end
    }
    
    public function loadImage(src: String, image_index: Int): Void {
        Pancake.images[image_index] = new Image();
        Pancake.images[image_index].src = src;
    }
    
    public function loadImageFromDocument(element: Any, image_index: Int): Void {
        Pancake.images[image_index] = element;
    }
    
    public function drawImage(image: Image, sx: Float, sy: Float, sw: Float, sh: Float, dx: Float, dy: Float, dw: Float, dh: Float): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        ctx.imageSmoothingEnabled = false;
        var img: CanvasRenderingContext2D = document.createCanvasElement().getContext("2d");
        img.canvas.width = image.width;
        img.canvas.height = image.height;
        img.save();
        if (tint != null) {
            img.fillStyle = cast(tint, String);
            img.globalAlpha = 0.7;
            img.fillRect(0, 0, img.canvas.width, img.canvas.height);
            img.globalCompositeOperation = "destination-atop";
            img.globalAlpha = 1;
        }
        img.drawImage(image, 0, 0, image.width, image.height);
        img.restore();
        ctx.drawImage(img.canvas, sx, sy, sw, sh, dx, dy, dw, dh);
        #elseif PANCAKE_WEBGL
        var ctx: RenderingContext = cast(context, RenderingContext);
        ctx.enable(GL.BLEND);
        texTex = image;
        if (tint != null) ctx.vertexAttrib4fv(ctx.getAttribLocation(program, "a_color"), tint);
        loadImageBuffer(sx, sy, sw, sh, dx, dy, dw, dh);
        var tex = ctx.createTexture();
        ctx.bindTexture(GL.TEXTURE_2D, tex);
        ctx.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
        ctx.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
        ctx.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
        ctx.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
        ctx.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, texTex);
        ctx.blendFunc(GL.ONE, GL.ONE_MINUS_DST_ALPHA);
        ctx.blendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
        render(texRect);
        ctx.deleteTexture(tex);
        ctx.disable(GL.BLEND);
        #end
    }
    
    public function drawImageFromIndex(image_index: Int, sx: Float, sy: Float, sw: Float, sh: Float, dx: Float, dy: Float, dw: Float, dh: Float): Void {
        drawImage(Pancake.images[image_index], sx, sy, sw, sh, dx, dy, dw, dh);
    }
    
    public function image(im: Image, x: Float, y: Float, w: Float, h: Float): Void {
        drawImage(im, 0, 0, im.width, im.height, x, y, w, h);
    }
    
    public function imageFromIndex(image_index: Int, x: Float, y: Float, w: Float, h: Float): Void {
        drawImage(Pancake.images[image_index], 0, 0, Pancake.images[image_index].width, Pancake.images[image_index].height, x, y, w, h);
    }
    
    public function useFilters(filters: Array<String>, filters_values: Array<String>): Void {
        if (filters.length == filters_values.length) {
            for (i in 0...filters.length) canvas.style.filter += (" " + filters[i] + "(" + filters_values[i] + ") ");
        }
    }
    
    public function addFilter(filter: String, filter_value: String): Void {
        canvas.style.filter += (" " + filter + "(" + filter_value + ") ");
    }
    
    public function clearFilters(): Void {
        canvas.style.filter = "none";
    }
    
    public function canvasToImage(canvas_index: Int): String {
        return Pancake.canvases[canvas_index].toDataURL();
    }
    
    public function screenshot(canvas_index: Int): Void {
        js.Browser.window.open(canvasToImage(canvas_index));
    }
    
    public function square(x: Float, y: Float, size: Float): Void {
        rect(x, y, size, size);
    }
    
    public function pixel(x: Float, y: Float): Void {
        #if PANCAKE_CANVAS2D
        square(x, y, 1);
        #elseif PANCAKE_WEBGL
        render(loadBuffer(loadPointBuffer(x, y)));
        #end
    }
    
    public function point(x: Float, y: Float): Void {
        #if PANCAKE_CANVAS2D
        circle(x, y, 1);
        #elseif PANCAKE_WEBGL
        render(loadBuffer(loadPointBuffer(x, y)));
        #end
    }
    
    public function grid(size: Float): Void {
        var diff_w: Int = cast(canvas.width / size, Int);
        var diff_h: Int = cast(canvas.height / size, Int);
        var x: Float = 0;
        var y: Float = 0;
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        for (i in 0...diff_h) {
            for (j in 0...diff_w) {
                ctx.strokeRect(x, y, size, size);
                ctx.strokeRect(x + size, y, size, size);
                x += size;
            }
            x = 0;
            y += size;
        }
        #elseif PANCAKE_WEBGL
        var previous_mode: Int = mode;
        mode = STROKE;
        for (i in 0...diff_h) {
            for (j in 0...diff_w) {
                rect(x, y, size, size);
                rect(x + size, y, size, size);
                x = x + size;
            }
            x = 0;
            y = y + size;
        }
        mode = previous_mode;
        #end
    }
    
    public function translate(x: Float, y: Float): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        ctx.translate(x, y);
        #elseif PANCAKE_WEBGL
        var ctx: RenderingContext = cast(context, RenderingContext);
        ctx.uniform2f(ctx.getUniformLocation(program, "u_translation"), x, y);
        if (ctx2d_enabled) ctx2d.translate(x, y);
        #end
    }
    
    public function rotate(x: Float, ?y: Float): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        ctx.rotate(x);
        #elseif PANCAKE_WEBGL
        var ctx: RenderingContext = cast(context, RenderingContext);
        ctx.uniform2f(ctx.getUniformLocation(program, "u_rotation"), x, y);
        if (ctx2d_enabled) ctx2d.rotate(x);
        #end
    }
    
    public function scale(x: Float, y: Float): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        ctx.scale(x, y);
        #elseif PANCAKE_WEBGL
        var ctx: RenderingContext = cast(context, RenderingContext);
        ctx.uniform2f(ctx.getUniformLocation(program, "u_scale"), x, y);
        if (ctx2d_enabled) ctx2d.scale(x, y);
        #end
    }
    
    public function save(): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        ctx.save();
        #elseif PANCAKE_WEBGL
        if (ctx2d_enabled) ctx2d.save();
        #end
    }
    
    public function restore(): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        ctx.restore();
        #elseif PANCAKE_WEBGL
        if (ctx2d_enabled) ctx2d.restore();
        #end
    }
    
    public function beginScissor(x: Int, y: Int, w: Int, h: Int): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        ctx.restore();
        ctx.save();
        ctx.beginPath();
        if (scissor) {
            ctx.rect(x, y, w, h);
        } else {
            ctx.rect(0, 0, canvas.width, canvas.height);
        }
        ctx.clip();
        #elseif PANCAKE_WEBGL
        var ctx: RenderingContext = cast(context, RenderingContext);
        if (scissor) {
            ctx.enable(GL.SCISSOR_TEST);
            ctx.scissor(x, y, w, h);
        }
        #end
    }
    
    public function endScissor(): Void {
        #if PANCAKE_CANVAS2D
        var ctx: CanvasRenderingContext2D = cast(context, CanvasRenderingContext2D);
        ctx.closePath();
        ctx.globalCompositeOperation = "source-over";
        #elseif PANCAKE_WEBGL
        var ctx: RenderingContext = cast(context, RenderingContext);
        if (scissor) ctx.disable(GL.SCISSOR_TEST);
        #end
    }
}
