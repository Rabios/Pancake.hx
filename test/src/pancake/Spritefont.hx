package pancake;

import haxe.extern.EitherType;
import js.Browser.document;
import js.html.Image;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import pancake.Pancake;

/**
 * ...
 * @author Rabia Haffar
 */
class Spritefont {
    public function new() {}
    
    public function load(spritefont_image_src: String, spritefont_chars_info: Dynamic, spritefont_index: Int): Void {
        var img: Image = new Image();
        img.src = spritefont_image_src;
        Pancake.fonts[spritefont_index] = {
            image: img,
            chars: spritefont_chars_info
        };    
    }
    
    public function draw(spritefont_index: Int, text: String, x: Float, y: Float, font_size: Float, spacing: Float, color: EitherType<String, Array<Float>>, ?color_tint_alpha: Float): Void {
        var spc: Float = spacing;
        var old_tint: Array<Float> = Pancake.graphics.tint != null ? Pancake.graphics.tint : null;
        for (i in 0...text.length) {
            if (i == 0) spacing = 0; else spacing = spc;
            var char_rect: Dynamic = Reflect.field(Pancake.fonts[spritefont_index].chars, text.charAt(i));
            #if PANCAKE_WEBGL
            old_tint[3] = color_tint_alpha != null ? color_tint_alpha : old_tint[3] != null ? old_tint[3] : 1;
            Pancake.graphics.tint = color != null ? color : Pancake.graphics.tint;
            if (char_rect != null) Pancake.graphics.drawImage(Pancake.fonts[spritefont_index].image, char_rect.x, char_rect.y, char_rect.w, char_rect.h, x + (i * (font_size + spc)), y, font_size, font_size);
            #elseif PANCAKE_CANVAS2D
            var char_img_context: CanvasRenderingContext2D = document.createCanvasElement().getContext2d();
            char_img_context.canvas.width = Pancake.fonts[spritefont_index].image.width;
            char_img_context.canvas.height = Pancake.fonts[spritefont_index].image.height;
            char_img_context.save();
            char_img_context.fillStyle = cast(color, js.html.CanvasPattern);
            char_img_context.globalAlpha = color_tint_alpha != null ? color_tint_alpha : 0.8;
            char_img_context.fillRect(0, 0, char_img_context.canvas.width, char_img_context.canvas.height);
            char_img_context.globalCompositeOperation = "destination-atop";
            char_img_context.globalAlpha = 1;
            char_img_context.drawImage(Pancake.fonts[spritefont_index].image, 0, 0);
            char_img_context.restore();
            if (char_rect != null) Pancake.graphics.drawImage(cast(char_img_context.canvas, Image), char_rect.x, char_rect.y, char_rect.w, char_rect.h, x + (i * (font_size + spc)), y, font_size, font_size);
            #end
        }
        #if PANCAKE_WEBGL
        Pancake.graphics.tint = old_tint;
        #end
    }
}
