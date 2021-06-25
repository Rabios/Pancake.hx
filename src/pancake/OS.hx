package pancake;

import js.Browser.navigator;

/**
 * ...
 * @author Rabia Haffar
 */
class OS {
    public function new() {}
    
    public static var userAgent: String = navigator.userAgent;
    public var iOS: Bool = (userAgent.indexOf("iPhone") > -1) || (userAgent.indexOf("iPad") > -1) || (userAgent.indexOf("iPod") > -1) || (userAgent.indexOf("Apple-iPhone") > -1);
    public var ANDROID: Bool = (userAgent.indexOf("Android") > -1);
    public var OSX: Bool = (userAgent.indexOf("Macintosh") > -1) || (userAgent.indexOf("Intel Mac OS X") > -1);
    public var WINDOWS: Bool = (userAgent.indexOf("Windows") > -1) || (userAgent.indexOf("Windows NT") > -1);
    public var WINDOWS_PHONE: Bool = (userAgent.indexOf("Windows Phone") > -1);
    public var LINUX: Bool = (userAgent.indexOf("Linux") > -1) || (userAgent.indexOf("X11") > -1);
    public var UBUNTU: Bool = (userAgent.indexOf("Ubuntu") > -1);
    public var PLAYSTATION: Bool = (userAgent.indexOf("Playstation") > -1);
    public var PS4: Bool = (userAgent.indexOf("Playstation 4") > -1);
    public var PSVITA: Bool = (userAgent.indexOf("Playstation Vita") > -1);
    public var XBOX: Bool = (userAgent.indexOf("Xbox") > -1) || (userAgent.indexOf("XBOX_ONE_ED") > -1);
    public var XBOX_ONE: Bool = (userAgent.indexOf("Xbox One") > -1);
    public var XBOX_ONE_S: Bool = (userAgent.indexOf("XBOX_ONE_ED") > -1);
    public var BLACKBERRY: Bool = (userAgent.indexOf("BB") > -1) || (userAgent.indexOf("Blackberry") > -1);
    public var CHROMECAST: Bool = (userAgent.indexOf("CrKey") > -1);
    public var CHROME_OS: Bool = (userAgent.indexOf("CrOS") > -1);
    public var NINTENDO: Bool = (userAgent.indexOf("Nintendo") > -1);
    public var N3DS: Bool = (userAgent.indexOf("Nintendo 3DS") > -1);
    public var WII_U: Bool = (userAgent.indexOf("Nintendo WiiU") > -1);
    public var FIRE_TV: Bool = (userAgent.indexOf("AFTS") > -1);
    public var ROKU: Bool = (userAgent.indexOf("Roku") > -1);
    public var ROKU_ULTRA: Bool = (userAgent.indexOf("Roku4640X") > -1);
    public var NEXUS_PLAYER: Bool = (userAgent.indexOf("Nexus Player") > -1);
    public var MINIX_NEO_X5: Bool = (userAgent.indexOf("NEO-X5") > -1);
    public var APPLE_TV: Bool = (userAgent.indexOf("AppleTV") > -1);
    public var KINDLE: Bool = (userAgent.indexOf("Kindle") > -1);
    public var TIZEN: Bool = (userAgent.indexOf("Tizen") > -1);

    public function is(useragent: String): Bool {
        return (userAgent.indexOf(useragent) > -1);
    }
}
