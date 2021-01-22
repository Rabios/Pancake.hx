package pancake;

/**
 * @author Rabia Haffar
 */
@:enum abstract Mode(Int) from Int to Int {
    public static var FILL: Int = 1;
    public static var STROKE: Int = 2;
    public static var BOTH: Int = 3;
}
