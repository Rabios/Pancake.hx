// Written by Rabia Alhaffar in 24/December/2020
// Pancake port for Haxe, https://github.com/Rabios/Pancake
// Latest Version: 28/January/2021
/*
All thanks to everyone in Haxe discord server, Including:
    - @Gama11
    - @semmi
    - @Fat Leech
    - @IanHarrigan
    - @jeremyfa
    - @BlackGoku36
    - @Zeta
    - @SunDaw
    - @Nanjizal
    - @Nakato
	- @AlexHaxe
*/
/*

MIT License

Copyright (c) 2020 - 2021 Rabia Alhaffar

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/
package pancake;

#if PANCAKE_AUDIO
import js.html.Audio;
import pancake.Audio;
#end

#if PANCAKE_GRAPHICS
import js.html.Image;
import js.html.CanvasElement;
import pancake.Canvas;
import pancake.Context;
import pancake.Graphics;
import pancake.Mode;

#if PANCAKE_VIDEO
import js.html.VideoElement;
import pancake.Video;
#end

#if PANCAKE_SPRITEFONT
import pancake.Spritefont;
#end

#if PANCAKE_GIF
import pancake.GIF;
#end

#if PANCAKE_SPRITE
import pancake.Sprite;
#end

#end

#if PANCAKE_INPUT
import pancake.Input;

#if PANCAKE_REPLAY
import pancake.Replay;
#end

#end

#if PANCAKE_DEVICE
import pancake.Device;
#end

#if PANCAKE_OS
import pancake.OS;
#end

#if PANCAKE_PHYSICS
import pancake.Physics;
#end

#if PANCAKE_STORAGE
import pancake.Storage;
#end

#if PANCAKE_TIMERS
import pancake.Timers;
#end

#if PANCAKE_SCRIPT
import pancake.Script;
#end

#if PANCAKE_UTIL
import pancake.Util;
#end

#if PANCAKE_BROWSER
import pancake.Browser;
#end

#if PANCAKE_CONTENT
import pancake.Content;
#end

#if PANCAKE_XHR
import pancake.XHR;
#end

#if PANCAKE_GAME
import pancake.Game;
#end

/**
 * ...
 * @author Rabia Haffar
 */
@:expose("pancake")
class Pancake {
    public static var version: String = "v0.0.14";
    
    #if PANCAKE_GRAPHICS
    public static var canvases: Array<CanvasElement> = [];
    public static var contexts: Array<Dynamic> = [];
	public static var images: Array<Image> = [];
    
    public static var canvas: Canvas = new Canvas();
    public static var context: Context = new Context();
    public static var graphics: Graphics = new Graphics();
    
	#if PANCAKE_VIDEO
    public static var videos: Array<VideoElement> = [];
	public static var video: Video = new Video();
    #end
	
    #if PANCAKE_SPRITE
    public static var sprites: Array<Dynamic> = [];
    public static var sprite: Sprite = new Sprite();
    #end
    
    #if PANCAKE_GIF
    public static var gifs: Array<Dynamic> = [];
    public static var gif: GIF = new GIF();
    #end
    
    #if PANCAKE_SPRITEFONT
    public static var fonts: Array<Dynamic> = [];
    public static var spritefont: Spritefont = new Spritefont();
    #end
    
    #end
    
    #if PANCAKE_AUDIO
    public static var audio_files: Array<js.html.Audio> = [];
	public static var audio: Audio = new Audio();
    #end
    
    #if PANCAKE_INPUT
    public static var input: Input = new Input();
	
	#if PANCAKE_REPLAY
    public static var replays: Array<Dynamic> = [];
    public static var replay: Replay = new Replay();
    #end
	
	#end
	
	#if PANCAKE_DEVICE
    public static var device: Device = new Device();
	#end
	
	#if PANCAKE_OS
    public static var os: OS = new OS();
	#end
	
	#if PANCAKE_PHYSICS
    public static var physics: Physics = new Physics();
	#end
	
	#if PANCAKE_STORAGE
    public static var storage: Storage = new Storage();
	#end
	
	#if PANCAKE_TIMERS
    public static var timers: Timers = new Timers();
	#end
	
	#if PANCAKE_SCRIPT
    public static var script: Script = new Script();
	#end
	
	#if PANCAKE_UTIL
    public static var util: Util = new Util();
	#end
	
	#if PANCAKE_BROWSER
    public static var browser: Browser = new Browser();
    #end
	
	#if PANCAKE_CONTENT
    public static var content: Content = new Content();
	#end
	
	#if PANCAKE_XHR
    public static var xhr: XHR = new XHR();
    #end
	
	#if PANCAKE_GAME
    public static var game: Game = new Game();
	#end
}
