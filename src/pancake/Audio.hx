package pancake;

import js.html.Audio;
import pancake.Pancake;

/**
 * ...
 * @author Rabia Haffar
 */
class Audio {
    public function new() {}
    
    public function play(src: String): Void {
        new js.html.Audio(src).play();
    }
    
    public function load(src: String, audio_index: Int): Void {
        Pancake.audio_files[audio_index] = new js.html.Audio(src);
        Pancake.audio_files[audio_index].loop = false;
        Pancake.audio_files[audio_index].load();
    }
    
    public function playFromIndex(audio_index: Int): Void {
        Pancake.audio_files[audio_index].play();
    }
    
    public function pause(audio_index: Int): Void {
        Pancake.audio_files[audio_index].pause();
    }
    
    public function setVolume(volume: Float, audio_index: Int): Void {
        Pancake.audio_files[audio_index].volume = volume;
    }
    
    public function setMute(mute: Bool, audio_index: Int): Void {
        Pancake.audio_files[audio_index].muted = mute;
    }
    
    public function setLoop(loop: Bool, audio_index: Int): Void {
        Pancake.audio_files[audio_index].loop = loop;
    }
    
    public function finished(audio_index: Int): Bool {
        return Pancake.audio_files[audio_index].ended;
    }
    
    public function reset(audio_index: Int): Void {
        Pancake.audio_files[audio_index].pause();
        Pancake.audio_files[audio_index].currentTime = 0;
    }
}
