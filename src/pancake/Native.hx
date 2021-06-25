package pancake;

import haxe.Constraints.Function;

/**
 * ...
 * @author Rabia Haffar
 */
@:native("window.navigator.app")
extern class NavigatorApp {
    public static function exitApp(): Void;
}

@:native("window.navigator.device")
extern class NavigatorDevice {
    public static function exitApp(): Void;
}

@:native("window.nw")
extern class NWJS {}

@:native("window.nw.Window")
extern class NWJSWindow {
    public static function get(): NWJS_Window_Props;
}

@:native("window.nw.Window.get()")
extern class NWJS_Window_Props {
    public function enterFullscreen(): Void;
    public function toggleFullscreen(): Void;
    public function leaveFullscreen(): Void;
}

@:native("window")
extern class Window {
    public static function require(module: String): Dynamic;
    public static var onmspointerup: haxe.Constraints.Function;
    public static var onmspointerdown: haxe.Constraints.Function;
    public static var onmspointermove: haxe.Constraints.Function;
}

@:native("window.require('electron').remote.getCurrentWindow()")
extern class ElectronWindow {
    public static function setFullScreen(fullscreen: Bool): Void;
    public static function setMenuBarVisibility(visible: Bool): Void;
}

@:native("window.Windows")
extern class Windows {}

@:native("window.Windows.Gaming.Input.Gamepad")
extern class UWPGamepadInput {
    public static var gamepads: Array<UWPGamepad>;
}

extern class UWPGamepad {
    public function getCurrentReading(): UWPGamepadState;
}

@:native("window.Windows.UI.ViewManagement.ApplicationView.getForCurrentView()")
extern class UWPCurrentView {
    public static var title: String;
    public static var isFullScreen: Bool;
    public static var isFullScreenMode: Bool;
    public static var fullScreenSystemOverlayMode: Int;
    public static function tryEnterFullScreenMode(): Bool;
    public static function exitFullScreenMode(): Void;
}

@:native("window.Windows.UI.ViewManagement.ApplicationViewWindowingMode")
extern class UWPWindowingModes {
    public static var fullscreen: Int;
    public static var auto: Int;
    public static var preferredLaunchViewSize: Int;
}

@:native("window.Windows.Gaming.Input.GamepadButtons")
extern class UWPGamepadButtons {
    public static var a: Int;
    public static var b: Int;
    public static var x: Int;
    public static var y: Int;
    public static var dpadUp: Int;
    public static var dpadDown: Int;
    public static var dpadLeft: Int;
    public static var dpadRight: Int;
    public static var leftShoulder: Int;
    public static var rightShoulder: Int;
    public static var view: Int;
    public static var menu: Int;
    public static var leftThumbstick: Int;
    public static var rightThumbstick: Int;
}

extern class UWPGamepadState {
    public var buttons: Int;
    public var leftThumbstickX: Float;
    public var leftThumbstickY: Float;
    public var rightThumbstickX: Float;
    public var rightThumbstickY: Float;
    public var leftTrigger: Float;
    public var rightTrigger: Float;
    public var timestamp: Float;
}

@:native("window.tizen")
extern class Tizen {}

@:native("window.tizen.application")
extern class TizenApp {
    public static function getCurrentApplication(): TizenAppObj;
}

extern class TizenAppObj {
    public function exit(): Void;
}
