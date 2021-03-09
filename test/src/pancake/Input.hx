package pancake;

import js.html.MouseEvent;
import js.html.KeyboardEvent;
import js.html.Gamepad;
import js.html.TouchEvent;
import js.html.WheelEvent;
import js.Browser.window;
import js.Browser.navigator;
import js.Browser.document;
import pancake.Navigator;
import haxe.Constraints.Function;
import pancake.Native;

/**
 * ...
 * @author Rabia Haffar
 */
@:native("Accelerometer")
extern class Accelerometer {
    public function new(properties: Dynamic): Void {};
    public var onreading: haxe.Constraints.Function;
    public function start(): Any;
}

class Input {
    public var latest_key_down: Int = -1;
    public var latest_key_up: Int = -1;
    public var latest_mouse_button_down: Int = -1;
    public var latest_mouse_button_up: Int = -1;
    public var click: Bool = false;
    public var touchdown: Bool = false;
    public var tap: Bool = false;
    public var mouse_x: Int = 0;
    public var mouse_y: Int = 0;
    public var touch_x: Int = 0;
    public var touch_y: Int = 0;
    public var wheel_x: Float = 0;
    public var wheel_y: Float = 0;
    public var wheel_z: Float = 0;
    public var accel_x: Float = 0;
    public var accel_y: Float = 0;
    public var accel_z: Float = 0;
    public var wheel_up: Bool = false;
    public var wheel_down: Bool = false;
    public var wheel_left: Bool = false;
    public var wheel_right: Bool = false;
    public var swipe_start_time: Float = 0;
    public var swipe_finish_time: Float = 0;
    public var swipe_start_x: Int = 0;
    public var swipe_start_y: Int = 0;
    public var swipe_finish_x: Int = 0;
    public var swipe_finish_y: Int = 0;
    public var swipe_direction: String = "";
    public var swipe_finish_time_limit: Int = 1000;
    public var swipe_finish_x_limit: Dynamic = { from: 100, to: 300 };
    public var swipe_finish_y_limit: Dynamic = { from: 300, to: 300 };
    public var gamepad_threshold: Float = 0.1;
    public var GAMEPAD_ANALOG_UP: Float = -0.1;
    public var GAMEPAD_ANALOG_DOWN: Float = 0.1;
    public var GAMEPAD_ANALOG_LEFT: Float = 0.1;
    public var GAMEPAD_ANALOG_RIGHT: Float = -0.1;
    public var GAMEPAD_MOVE_ANALOG: Int = 1;
    public var GAMEPAD_CAMERA_ANALOG: Int = 2;
    public var accelerometer_frequency: Int = 60;
    public var gamepad_move_horizontal_direction: String = "";
    public var gamepad_move_vertical_direction: String = "";
    public var gamepad_camera_horizontal_direction: String = "";
    public var gamepad_camera_vertical_direction: String = "";
    public var accelerometer: Accelerometer = null;
    public var touches: Array<Dynamic>;
    
    public var key: Dynamic = {
        A: 65, B: 66, C: 67, D: 68, E: 69, F: 70, G: 71, H: 72, I: 73, J: 74, K: 75, L: 76, M: 77,
        N: 78, O: 79, P: 80, Q: 81, R: 82, S: 83, T: 84, U: 85, V: 86, W: 87, X: 88, Y: 89, Z: 90,
        ZERO: 48, ONE: 49, TWO: 50, THREE: 51, FOUR: 52, FIVE: 53, SIX: 54, SEVEN: 55, EIGHT: 56,
        NINE: 57, UP: 38, DOWN: 40, LEFT: 37, RIGHT: 39, SPACE: 32, TAB: 9, SHIFT: 16, CONTROL: 17, 
        ALT: 18, BACKSPACE: 8, ENTER: 13, NUMLOCK: 144, OS: 91, UNIDENTIFIED: 0, HOME: 36, PGUP: 33,
        PGDN: 34, CLEAR: 12, DELETE: 46, ESCAPE: 27, INSERT: 45
    }
    
    public var tvkey: Dynamic = {
        UP: 38, DOWN: 40, LEFT: 37, RIGHT: 39, CHANNEL_UP: 516, CHANNEL_DOWN: 517, CONTEXT: 623, RED: 588,
        GREEN: 589, YELLOW: 590, BLUE: 591, ENTER: 13, INFO: 615, ASPECT: 642, LASTVIEW: 651, ZERO: 48, ONE: 49, TWO: 50,
        THREE: 51, FOUR: 52, FIVE: 53, SIX: 54, SEVEN: 55, EIGHT: 56, NINE: 57, BACK: 8, RETURN: 8, PLAY: 250, PAUSE: 19,
        STOP: 178, RECORD: 603, FORWARD: 228, REWIND: 227, FAST_FORWARD: 176, REPLAY: 177
    }
    
    public var button: Dynamic = {
        LEFT_MOUSE_BUTTON: 0, RIGHT_MOUSE_BUTTON: 2, MIDDLE_MOUSE_BUTTON: 1, A: 0, B: 1, XBOX_X: 2,
        Y: 3, LB: 4, RB: 5, LT: 6, RT: 7, SELECT: 8, BACK: 8, VIEW: 8, START: 9, MENU: 9, LEFT_ANALOG_STICK: 10, RIGHT_ANALOG_STICK: 11,
        UP: 12, DOWN: 13, LEFT: 14, RIGHT: 15, PLAYSTATION_X: 0, O: 1, SQUARE: 2, TRIANGLE: 3, L1: 4, R1: 5, L2: 6, R2: 7
    }
    
    public function new(): Void {
        if (Accelerometer != null) {
            accelerometer = new Accelerometer({ frequency: accelerometer_frequency });
            accelerometer.onreading = function(e) {
                accel_x = e.x;
                accel_y = e.y;
                accel_z = e.z;
            };
            accelerometer.start();
        }
        
        GAMEPAD_ANALOG_UP = -gamepad_threshold;
        GAMEPAD_ANALOG_DOWN = gamepad_threshold;
        GAMEPAD_ANALOG_LEFT = gamepad_threshold;
        GAMEPAD_ANALOG_RIGHT = -gamepad_threshold;
        
        if (Windows != null) {
            GAMEPAD_ANALOG_UP = -GAMEPAD_ANALOG_UP;
            GAMEPAD_ANALOG_DOWN = -GAMEPAD_ANALOG_DOWN;
            button.A = "a";
            button.B = "b";
            button.XBOX_X = "x";
            button.Y = "y";
            button.UP = "dpadUp";
            button.DOWN = "dpadDown";
            button.LEFT = "dpadLeft";
            button.RIGHT = "dpadRight";
            button.LB = "leftShoulder";
            button.RB = "rightShoulder";
            button.LT = "leftTrigger";
            button.RT = "rightTrigger";
            button.BACK = button.SELECT = button.VIEW = "view";
            button.START = button.MENU = "menu";
            button.LEFT_ANALOG_STICK = "leftThumbstick";
            button.RIGHT_ANALOG_STICK = "rightThumbstick";
        }
        
        window.onmousedown = Window.onmspointerdown = window.onpointerdown = function (e: MouseEvent) {
            swipe_start_x = (e.clientX != null) ? e.clientX : e.pageX;
            swipe_start_y = (e.clientY != null) ? e.clientY : e.pageY;
            swipe_start_time = window.performance.now();
            latest_mouse_button_down = e.button;
            click = false;
        };
        
        window.onmouseup = Window.onmspointerup = window.onpointerup = function(e: MouseEvent) {
            mouse_x = (e.clientX != null) ? e.clientX : e.pageX;
            mouse_y = (e.clientY != null) ? e.clientY : e.pageY;
            swipe_finish_x = mouse_x - swipe_start_x;
            swipe_finish_y = mouse_y - swipe_start_y;
            swipe_finish_time = window.performance.now() - swipe_start_time;
            if (swipe_finish_time <= swipe_finish_time_limit) {
                function f(a: Float): Float { return Math.abs(a); }
                if (f(swipe_finish_x) >= swipe_finish_x_limit.from && f(swipe_finish_y) <= swipe_finish_y_limit.to) {
                    if (swipe_finish_x < 0) swipe_direction = "LEFT";
                    else swipe_direction = "RIGHT";
                }
                else if (f(swipe_finish_y) >= swipe_finish_y_limit.from && f(swipe_finish_x) <= swipe_finish_x_limit.to) {
                    if (swipe_finish_y < 0) swipe_direction = "UP";
                    else swipe_direction = "DOWN";
                }
            }
            latest_mouse_button_up = e.button;
            click = false;
        };
        
        window.onmousemove = Window.onmspointermove = window.onpointermove = function(e: MouseEvent) {
            mouse_x = (e.clientX != null) ? e.clientX : e.pageX;
            mouse_y = (e.clientY != null) ? e.clientY : e.pageY;
        };
        
        window.ontouchstart = function(e: TouchEvent) {
            for (i in 0...e.changedTouches.length) {
                touches[i] = {
                    x: (e.changedTouches[i].clientX != null) ? e.changedTouches[i].clientX : e.changedTouches[i].pageX,
                    y: (e.changedTouches[i].clientY != null) ? e.changedTouches[i].clientY : e.changedTouches[i].pageY,
                    swipe_start_x: e.changedTouches[i].pageX,
                    swipe_start_y: e.changedTouches[i].pageY,
                    swipe_start_time: window.performance.now(),
                    swipe_direction: "",
                    tap: true,
                    touchdown: false,
                }
            }
            touch_x = touches[0].x;
            touch_y = touches[0].y;
            tap = true;
            touchdown = false;
            e.preventDefault();
        };
        
        window.ontouchend = function(e: TouchEvent) {
            for (i in 0...e.changedTouches.length) {
                touches[i].x = (e.changedTouches[i].clientX != null) ? e.changedTouches[i].clientX : e.changedTouches[i].pageX;
                touches[i].y = (e.changedTouches[i].clientY != null) ? e.changedTouches[i].clientY : e.changedTouches[i].pageY;
                touches[i].swipe_finish_x = e.changedTouches[i].pageX - touches[i].swipe_start_x;
                touches[i].swipe_finish_y = e.changedTouches[i].pageY - touches[i].swipe_start_y;
                touches[i].swipe_finish_time = window.performance.now() - touches[i].swipe_start_time;
                touches[i].tap = true;
                touches[i].touchdown = false;
                if (touches[i].swipe_finish_time <= swipe_finish_time_limit) {
                    function f(a: Float): Float { return Math.abs(a); }
                    if (f(touches[i].swipe_finish_x) >= swipe_finish_x_limit.from && f(touches[i].swipe_finish_y) <= swipe_finish_y_limit.to) {
                        if (touches[i].swipe_finish_x < 0) touches[i].swipe_direction = "LEFT";
                        else touches[i].swipe_direction = "RIGHT";
                    }
                    else if (f(touches[i].swipe_finish_y) >= swipe_finish_y_limit.from && f(touches[i].swipe_finish_x) <= swipe_finish_x_limit.to) {
                        if (touches[i].swipe_finish_y < 0) touches[i].swipe_direction = "UP";
                        else touches[i].swipe_direction = "DOWN";
                    }
                }
            }
            touch_x = touches[0].x;
            touch_y = touches[0].y;
            tap = true;
            touchdown = false;
            e.preventDefault();
        };
        
        window.ontouchcancel = function(e: TouchEvent) {
            for (i in 0...e.changedTouches.length) {
                touches[i].tap = false;
                touches[i].touchdown = false;
            }
            tap = false;
            touchdown = false;
            e.preventDefault();
        };
        
        window.ontouchmove = function(e: TouchEvent) {
            for (i in 0...e.changedTouches.length) {
                touches[i].x = (e.changedTouches[i].clientX != null) ? e.changedTouches[i].clientX : e.changedTouches[i].pageX;
                touches[i].y = (e.changedTouches[i].clientY != null) ? e.changedTouches[i].clientY : e.changedTouches[i].pageY;
                touches[i].touchdown = true;
            }
            touch_x = touches[0].x;
            touch_y = touches[0].y;
            touchdown = true;
            e.preventDefault();
        };
        
        window.onclick = function() {
            click = true;
        };
        
        window.onkeydown = function(e: KeyboardEvent) {
            latest_key_down = (e.which != null ? e.which : e.keyCode);
        };

        window.onkeyup = function(e: KeyboardEvent) {
            latest_key_up = (e.which != null ? e.which : e.keyCode);
        };
        
        window.onwheel = function(e: WheelEvent) {
            wheel_x = e.deltaX;
            wheel_y = e.deltaY;
            wheel_z = e.deltaZ;
            
            if (wheel_x > 0) {
                wheel_left = false;
                wheel_right = true;
            } else if (wheel_x < 0) {
                wheel_left = true;
                wheel_right = false;
            } else if (wheel_x == 0) {
                wheel_left = wheel_right = false;
            }
    
            if (wheel_y > 0) {
                wheel_up = false;
                wheel_down = true;
            } else if (wheel_y < 0) {
                wheel_up = true;
                wheel_down = false;
            } else if (wheel_y == 0) {
                wheel_up = wheel_down = false;
            }
        };
    }
    
    public function mousedown(button: Int): Bool {
        return (latest_mouse_button_down == button);
    }
        
    public function mouseup(button: Int): Bool {
        return (latest_mouse_button_up == button);
    }
        
    public function swipe(direction: String, ?finger: Int = 0): Bool {
        if (touches[finger] == null) {
            return (swipe_direction == direction);
        } else {
            return (touches[finger].swipe_direction == direction);
        }
    }
    
    public function keydown(key: Int): Bool {
        return (latest_key_down == key);
    }
    
    public function keyup(key: Int): Bool {
        return (latest_key_up == key);
    }
    
    private function cursorState(state: String, ?canvas_index: Int = 0): Void {
        document.body.style.height = "100%";
        document.getElementsByTagName("html")[0].style.height = "100%";
        Pancake.canvases[canvas_index != null ? canvas_index : 0].style.cursor = state;
        #if PANCAKE_WEBGL
        if (Pancake.graphics.ctx2d_enabled) Pancake.graphics.ctx2d.canvas.style.cursor = state;
        #end
        document.body.style.height = "auto";
        document.getElementsByTagName("html")[0].style.height = "auto";
    }
    
    public function hideCursor(?canvas_index: Int = 0): Void {
        cursorState("none", canvas_index);
    }
    
    public function showCursor(?canvas_index: Int = 0): Void {
        cursorState("auto", canvas_index);
    }
    
    public function setCursor(css_style: String, ?canvas_index: Int = 0): Void {
        cursorState(css_style, canvas_index);
    }
    
    public function lockPointer(): Void {
        if (Pancake.graphics.canvas.requestPointerLock != null) Pancake.graphics.canvas.requestPointerLock();
        if ($type(document.pointerLockElement) == $type(Pancake.graphics.canvas)) Pancake.graphics.canvas.requestPointerLock();
    }
    
    public function unlockPointer(): Void {
        document.exitPointerLock();
    }
    
    private function getGamepads(): Array<Gamepad> {
        if (Navigator.getGamepads != null) {
            return Navigator.getGamepads();
        } else if (Navigator.webkitGetGamepads != null) {
            return Navigator.webkitGetGamepads();
        } else if (Navigator.webkitGamepads != null) {
            return Navigator.webkitGamepads();
        } else {
            return null;
        }
    }
    
    public function gamepadConnected(gamepad_index: Int): Bool {
        if (!(Windows != null)) {
            var gamepads: Array<Gamepad> = getGamepads();
            if (gamepads != null) {
                return gamepads[gamepad_index] != null;
            } else {
                return false;
            }
        } else {
            return (UWPGamepadInput.gamepads[gamepad_index] != null);
        }
    }
    
    public function gamepadID(gamepad_index: Int): String {
        if (!(Windows != null)) {
            var gamepads: Array<Gamepad> = getGamepads();
            if (gamepads != null) {
                if (gamepads[gamepad_index] != null) return gamepads[gamepad_index].id;
                else return null;
            }
        } else {
            return "XInput STANDARD GAMEPAD";
        }
        return null;
    }
    
    public function gamepadButtonPressed(gamepad_index: Int, gamepad_button: haxe.extern.EitherType<Int, String>): Bool {
        if (!(Windows != null)) {
            var gamepads: Array<Gamepad> = getGamepads();
            if (gamepads != null && gamepads[gamepad_index] != null) {
                return gamepads[gamepad_index].buttons[gamepad_button].pressed;
            } else {
                return false;
            }
        } else {
            if (UWPGamepadInput.gamepads[gamepad_index] != null) {
                var gamepad_state: UWPGamepadState = UWPGamepadInput.gamepads[gamepad_index].getCurrentReading();
                if (gamepad_button == "leftTrigger") return (gamepad_state.leftTrigger >= gamepad_threshold);
                if (gamepad_button == "rightTrigger") return (gamepad_state.rightTrigger >= gamepad_threshold);
                else return ((gamepad_state.buttons & Reflect.field(gamepad_state.buttons, gamepad_button)) != 0);
            }
        }
        return false;
    }
    
    public function gamepadButtonTouched(gamepad_index: Int, gamepad_button: haxe.extern.EitherType<Int, String>): Bool {
        if (!(Windows != null)) {
            var gamepads: Array<Gamepad> = getGamepads();
            if (gamepads != null && gamepads[gamepad_index] != null) {
                return gamepads[gamepad_index].buttons[gamepad_button].touched;
            } else {
                return false;
            }
        } else {
            if (UWPGamepadInput.gamepads[gamepad_index] != null) {
                var gamepad_state: UWPGamepadState = UWPGamepadInput.gamepads[gamepad_index].getCurrentReading();
                if (gamepad_button == "leftTrigger") return (gamepad_state.leftTrigger >= gamepad_threshold);
                if (gamepad_button == "rightTrigger") return (gamepad_state.rightTrigger >= gamepad_threshold);
                else return ((gamepad_state.buttons & Reflect.field(gamepad_state.buttons, gamepad_button)) != 0);
            }
        }
        return false;
    }
    
    // DEV NOTES: This works like pointer function for storing gamepad info in it's variables...
    private function gamepadMovement(gamepad_index: Int, gamepad_analog: Int, analog_direction: Float): Void {
        if (!(Windows != null)) {
            var gamepad: Gamepad = getGamepads()[gamepad_index];
            if (gamepad != null) {
                if (gamepad_analog == GAMEPAD_MOVE_ANALOG) {
                    if (gamepad.axes[1] <= analog_direction) gamepad_move_vertical_direction = "UP";
                    if (gamepad.axes[1] >= analog_direction) gamepad_move_vertical_direction = "DOWN";
                    if (gamepad.axes[0] <= analog_direction) gamepad_move_horizontal_direction = "LEFT";
                    if (gamepad.axes[0] >= analog_direction) gamepad_move_horizontal_direction = "RIGHT";
                }
            
                if (gamepad_analog == GAMEPAD_CAMERA_ANALOG) {
                    if (gamepad.axes[3] <= analog_direction) gamepad_camera_vertical_direction = "UP";
                    if (gamepad.axes[3] >= analog_direction) gamepad_camera_vertical_direction = "DOWN";
                    if (gamepad.axes[2] <= analog_direction) gamepad_camera_horizontal_direction = "LEFT";
                    if (gamepad.axes[2] >= analog_direction) gamepad_camera_horizontal_direction = "RIGHT";
                }
            }
        } else {
            var gamepad: UWPGamepad = UWPGamepadInput.gamepads[gamepad_index];
            if (gamepad != null) {
                var gamepad_state: UWPGamepadState = gamepad.getCurrentReading();
                if (gamepad_analog == GAMEPAD_MOVE_ANALOG) {
                    if (gamepad_state.leftThumbstickY >= analog_direction) gamepad_move_vertical_direction = "UP";
                    if (gamepad_state.leftThumbstickY <= analog_direction) gamepad_move_vertical_direction = "DOWN";
                    if (gamepad_state.leftThumbstickX <= analog_direction) gamepad_move_horizontal_direction = "LEFT";
                    if (gamepad_state.leftThumbstickX >= analog_direction) gamepad_move_horizontal_direction = "RIGHT";
                }

                if (gamepad_analog == GAMEPAD_CAMERA_ANALOG) {
                    if (gamepad_state.rightThumbstickY >= analog_direction) gamepad_camera_vertical_direction = "UP";
                    if (gamepad_state.rightThumbstickY <= analog_direction) gamepad_camera_vertical_direction = "DOWN";
                    if (gamepad_state.rightThumbstickX <= analog_direction) gamepad_camera_horizontal_direction = "LEFT";
                    if (gamepad_state.rightThumbstickX >= analog_direction) gamepad_camera_horizontal_direction = "RIGHT";
                }
            }
        }
    }
    
    public function gamepadAnalogMoved(gamepad_index: Int, gamepad_analog: Int, analog_direction: String): Bool {
        var gamepad_analog_direction: Float = 0.0;
        if (analog_direction == "UP") gamepad_analog_direction = GAMEPAD_ANALOG_UP;
        if (analog_direction == "DOWN") gamepad_analog_direction = GAMEPAD_ANALOG_DOWN;
        if (analog_direction == "LEFT") gamepad_analog_direction = GAMEPAD_ANALOG_LEFT;
        if (analog_direction == "RIGHT") gamepad_analog_direction = GAMEPAD_ANALOG_RIGHT;
        gamepadMovement(gamepad_index, gamepad_analog, gamepad_analog_direction);
        if (gamepad_analog == GAMEPAD_MOVE_ANALOG) {
            return (gamepad_move_horizontal_direction == analog_direction || gamepad_move_vertical_direction == analog_direction);
        } else if (gamepad_analog == GAMEPAD_CAMERA_ANALOG) {
            return (gamepad_camera_horizontal_direction == analog_direction || gamepad_camera_vertical_direction == analog_direction);
        } else {
            return false;
        }
    }
    
    public function preventLoop(): Void {
        latest_key_down = -1;
        latest_key_up = -1;
        latest_mouse_button_down = -1;
        latest_mouse_button_up = -1;
        click = false;
        tap = false;
        touchdown = false;
        wheel_up = false;
        wheel_down = false;
        wheel_left = false;
        wheel_right = false;
        swipe_direction = "";
        if (touches.length > 0) {
            for (i in 0...touches.length) {
                touches[i].swipe_direction = "";
            }
        }
        gamepad_move_horizontal_direction = "";
        gamepad_move_vertical_direction = "";
        gamepad_camera_horizontal_direction = "";
        gamepad_camera_vertical_direction = "";
    }
}
