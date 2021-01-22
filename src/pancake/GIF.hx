package pancake;

import js.html.Image;
import pancake.Pancake;
import pancake.Graphics;

/**
 * ...
 * @author Rabia Haffar
 */
class GIF {
    public function new() {}
    
    public function load(images_sources: Array<String>, duration: Int, gif_index: Int): Void {
        Pancake.gifs[gif_index] = {
            images: [],
            frame: 0,
            duration: duration,
            time: 0,
            paused: false
        };
        for (i in 0...images_sources.length) {
            Pancake.gifs[gif_index].images[i] = new Image();
            Pancake.gifs[gif_index].images[i].src = images_sources[i];
        }
    }
    
    public function draw(gif_index: Int, x: Float, y: Float, w: Float, h: Float): Void {
        if (Pancake.gifs[gif_index].images[Pancake.gifs[gif_index].frame] != null) {
            Graphics.renderImage(Pancake.gifs[gif_index].images[Pancake.gifs[gif_index].frame], 0, 0, Pancake.gifs[gif_index].images[Pancake.gifs[gif_index].frame].width, Pancake.gifs[gif_index].images[Pancake.gifs[gif_index].frame].height, x, y, w, h);
            if (!Pancake.gifs[gif_index].paused) {
                Pancake.gifs[gif_index].time++;
                if (Pancake.gifs[gif_index].time == Pancake.gifs[gif_index].duration) {
                    Pancake.gifs[gif_index].time = 0;
                    Pancake.gifs[gif_index].frame++;
                }
            }
        } else {
            Pancake.gifs[gif_index].frame = 0;
        }
    }
    
    public function pause(gif_index: Int): Void {
        Pancake.gifs[gif_index].paused = true;
    }
    
    public function resume(gif_index: Int): Void {
        Pancake.gifs[gif_index].paused = false;
    }
}
