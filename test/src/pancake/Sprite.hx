package pancake;

import Reflect;
import js.html.Image;
import pancake.Pancake;
import pancake.Graphics;

/**
 * ...
 * @author Rabia Haffar
 */
class Sprite {
    public function new() {}
    
    public function load(spritesheet_src: String, sprite_states: Dynamic, sprite_index: Int): Void {
        var img: Image = new Image();
        img.src = spritesheet_src;
        Pancake.sprites[sprite_index] = {
            src: img,
            states: sprite_states
        };
    }
    
    public function draw(sprite_index: Int, sprite_state: String, x: Float, y: Float, w: Float, h: Float): Void {
        var sp_state: Dynamic = Reflect.field(Pancake.sprites[sprite_index].states, sprite_state);
        sp_state.start = sp_state.start != null ? sp_state.start : 0;
        sp_state.end = sp_state.end != null ? sp_state.end : sp_state.info.length;
        sp_state.frame = sp_state.frame != null ? sp_state.frame : 0;
        sp_state.time = sp_state.time != null ? sp_state.time : 0;
        sp_state.paused = sp_state.paused != null ? sp_state.paused : false;
        if (sp_state.info[sp_state.frame] != null && (sp_state.frame <= sp_state.end - 1)) {
            Graphics.renderImage(Pancake.sprites[sprite_index].src, sp_state.info[sp_state.frame].x, sp_state.info[sp_state.frame].y, sp_state.info[sp_state.frame].w, sp_state.info[sp_state.frame].h, x, y, w, h);
            if (!sp_state.paused) {
                if (sp_state.time == sp_state.duration) {
                    sp_state.time = 0;
                    sp_state.frame++;
                }
                sp_state.time++;
            }
        } else sp_state.frame = sp_state.start;
    }
    
    public function pause(sprite_index: Int, sprite_state: String): Void {
        var sp_state: Dynamic = Reflect.field(Pancake.sprites[sprite_index].states, sprite_state);
        sp_state.paused = true;
    }
    
    public function resume(sprite_index: Int, sprite_state: String): Void {
        var sp_state: Dynamic = Reflect.field(Pancake.sprites[sprite_index].states, sprite_state);
        sp_state.paused = false;
    }
}
