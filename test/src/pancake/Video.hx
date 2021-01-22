package pancake;

import js.html.VideoElement;
import js.Browser.document;
import js.html.Image;
import pancake.Pancake;
import pancake.Graphics;

/**
 * ...
 * @author Rabia Haffar
 */
class VideoElementExtended extends VideoElement {
    public var is_paused: Bool = false;
}

class Video {
    public function new() {}
    
    public function load(video_src: String, video_index: Int): Void {
        Pancake.videos[video_index] = document.createVideoElement();
        Pancake.videos[video_index].src = video_src;
        Pancake.videos[video_index].autoplay = true;
        Pancake.videos[video_index].loop = false;
        cast(Pancake.videos[video_index], VideoElementExtended).is_paused = false;
        Pancake.videos[video_index].load();
    }
    
    public function play(video_index: Int, x: Float, y: Float, w: Float, h: Float): Void {
        if (!cast(Pancake.videos[video_index], VideoElementExtended).is_paused) {
            if (!cast(Pancake.videos[video_index], VideoElementExtended).ended) {
                Graphics.renderImage(cast(Pancake.videos[video_index], Image), 0, 0, cast(Pancake.videos[video_index], Image).width, cast(Pancake.videos[video_index], Image).height, x, y, w, h);
                Pancake.videos[video_index].play();
            }
        } else {
            Pancake.videos[video_index].pause();
        }
    }
    
    public function pause(video_index: Int): Void {
        Pancake.videos[video_index].pause();
        cast(Pancake.videos[video_index], VideoElementExtended).is_paused = true;
    }
    
    public function setVolume(volume: Int, video_index: Int): Void {
        Pancake.videos[video_index].volume = volume;
    }
    
    public function setMute(mute: Bool, video_index: Int): Void {
        Pancake.videos[video_index].muted = mute;
    }
    
    public function setLoop(loop: Bool, video_index: Int): Void {
        Pancake.videos[video_index].loop = loop;
    }
    
    public function finished(video_index: Int): Bool {
        return Pancake.videos[video_index].ended;
    }
    
    public function reset(video_index: Int): Void {
        pause(video_index);
        Pancake.videos[video_index].currentTime = 0;
    }
}
