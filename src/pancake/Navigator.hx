package pancake;

import js.html.Gamepad;

/**
 * ...
 * @author Rabia Haffar
 */
@:native("navigator")
extern class Navigator {
    public static function getGamepads(): Array<Gamepad>;
    public static function webkitGetGamepads(): Array<Gamepad>;
    public static function webkitGamepads(): Array<Gamepad>;
}
