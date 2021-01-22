package pancake;

import Reflect;
import pancake.Pancake;

/**
 * ...
 * @author Rabia Haffar
 */
class Replay {
    public function new() {}
    
    public function load(replay_index: Int, ?replay_start_frame: Int = 0, ?replay_end_frame: Int = null, ?replay_duration: Int = null, ?reverse: Bool = false, ?loop: Bool = false): Void {
        Pancake.replays[replay_index] = {
            start: replay_start_frame != null ? replay_start_frame : 0,
            end: replay_end_frame,
            duration: replay_duration != null ? replay_duration : 1,
            time: 0,
            reversed: reverse != null ? reverse: false,
            loop: loop != null ? loop : false,
            finished: false,
            paused: false,
            frames: []
        };
    }
    
    public function save(replay_index: Int, ?global: Dynamic): Void {
        var o: Dynamic = {};
        for (key in Reflect.fields(pancake.Input)) {
            if (!Reflect.isFunction(Reflect.field(pancake.Input, key))) {
                Reflect.setProperty(o, key, Reflect.field(pancake.Input, key));
            }
        }
        if (global != null) Reflect.setProperty(o, "global", global);
        Pancake.replays[replay_index].frames.push(o);
    }
    
    public function frames(replay_index: Int): Dynamic {
        return (Pancake.replays[replay_index].frames.length - 1);
    }
    
    public function play(replay_index: Int): Void {
        if (Pancake.replays[replay_index].end == null) Pancake.replays[replay_index].end = Pancake.replays[replay_index].frames.length - 1;
        if (!Pancake.replays[replay_index].finished) {
            if (Pancake.replays[replay_index].frames[Pancake.replays[replay_index].current] != null) {
                for (key in Reflect.fields(Pancake.replays[replay_index].frames[Pancake.replays[replay_index].current])) {
                    Reflect.setField(pancake.Input, key, Reflect.field(Pancake.replays[replay_index].frames[Pancake.replays[replay_index].current], key));
                }
                
                if (Pancake.replays[replay_index].frames[Pancake.replays[replay_index].current].global != null) {
                    for (key in Reflect.fields(Pancake.replays[replay_index].frames[Pancake.replays[replay_index].current].global)) {
                        Reflect.setField(js.Browser.window, key, Reflect.field(Pancake.replays[replay_index].frames[Pancake.replays[replay_index].current], key));
                    }
                }
                
                if (Pancake.replays[replay_index].reversed && Pancake.replays[replay_index].current <= Pancake.replays[replay_index].start && Pancake.replays[replay_index].loop) {
                    Pancake.replays[replay_index].finished = false;
                    Pancake.replays[replay_index].current = Pancake.replays[replay_index].end;
                }
                
                if (!Pancake.replays[replay_index].reversed && Pancake.replays[replay_index].current >= Pancake.replays[replay_index].end && Pancake.replays[replay_index].loop) {
                    Pancake.replays[replay_index].finished = false;
                    Pancake.replays[replay_index].current = Pancake.replays[replay_index].start;
                }
                
                if (!Pancake.replays[replay_index].paused) {
                    if (Pancake.replays[replay_index].time == Pancake.replays[replay_index].duration) {
                        if (Pancake.replays[replay_index].reversed) {
                            if (!(Pancake.replays[replay_index].current-- <= Pancake.replays[replay_index].start)) Pancake.replays[replay_index].current--;
                        } else {
                            if (!(Pancake.replays[replay_index].current++ >= Pancake.replays[replay_index].end)) Pancake.replays[replay_index].current++;
                        }
                        Pancake.replays[replay_index].time = 0;
                    } else {
                        Pancake.replays[replay_index].time++;
                    }
                } else {
                    Pancake.replays[replay_index].finished = true;
                }
            }
        }
    }
    
    public function clear(replay_index: Int): Void {
        Pancake.replays[replay_index] = null;
    }
    
    public function pause(replay_index: Int): Void {
        Pancake.replays[replay_index].paused = true;
    }
    
    public function resume(replay_index: Int): Void {
        Pancake.replays[replay_index].paused = false;
    }
}
