# Pancake.hx

<div align="center">
	<img src="Pancake.hx.png" width="256" height="256"><br>
</div><br>

Haxe port for [Pancake](https://github.com/Rabios/Pancake), HTML5 game programming library that makes game development much easier...

Currently it supports only JS target, But i have plan to rewrite port to use Lime or something else for better support!

### Getting Started

Install Pancake.hx with haxelib by following way:

```hx
haxelib install Pancake
```

Create new project anywhere, In your `build.hxml` you can include Pancake with modules needed by following way:

```
--define PANCAKE_CANVAS2D
--define PANCAKE_GRAPHICS
--define PANCAKE_GAME
--define PANCAKE_TIMERS

-L Pancake
--class-path src
--js bin/game.js
--main Main
```

Your `Main.hx` in `src` folder can be like this:

```hx
// Main.hx
package;

import pancake.*;    // Imports only included modules from build.hxml

/**
 * ...
 * @author Rabia Haffar
 */
class Main 
{
    public static function main(): Void {    
        Pancake.game.title("GAME!");
        Pancake.canvas.create(800, 600, 0);
        Pancake.context.create(0, 0);
        Pancake.graphics.useContext(0);
        Pancake.canvases[0].style.border = "1px black solid";
        
        var logo_x: Int = 280;
        var logo_y: Int = 150;
        var timer: Int = 0;
        
        function game() {
            Pancake.graphics.clear();
            Pancake.graphics.color(Pancake.graphics.random.RGBA());
            Pancake.graphics.rect(0, 0, Pancake.canvases[0].width, Pancake.canvases[0].height);
        }
        
        var gameloop: Int = Pancake.timers.timer(game, 60);
    }
}
```

### Modules

Modules are parts of Pancake that you can enable or disable them, Like Sound, Graphics, Input, etc...

You can include or remove parts of Pancake you don't need, You can also specify backend...

```
# Modules, Comment one of them to disable them...
--define PANCAKE_CANVAS2D      # Backend, Can be also WebGL via --define PANCAKE_WEBGL
--define PANCAKE_GRAPHICS
--define PANCAKE_VIDEO         # NOTE: Requires definition of PANCAKE_GRAPHICS
--define PANCAKE_SPRITE        # NOTE: Requires definition of PANCAKE_GRAPHICS
--define PANCAKE_GIF           # NOTE: Requires definition of PANCAKE_GRAPHICS
--define PANCAKE_SPRITEFONTS   # NOTE: Requires definition of PANCAKE_GRAPHICS
--define PANCAKE_AUDIO
--define PANCAKE_INPUT
--define PANCAKE_DEVICE
--define PANCAKE_OS
--define PANCAKE_REPLAY        # NOTE: Requires definition of PANCAKE_INPUT
--define PANCAKE_UTIL
--define PANCAKE_PHYSICS
--define PANCAKE_STORAGE
--define PANCAKE_TIMERS
--define PANCAKE_SCRIPT
--define PANCAKE_BROWSER
--define PANCAKE_XHR
--define PANCAKE_GAME
--define PANCAKE_CONTENT
```

### Differences of Pancake JavaScript

1. You start with `Pancake` instead of `pancake` in Haxe code, If you're loading JavaScript file then nothing changes from Pancake's JavaScript version!
2. Now you don't need Python anymore as Haxe build system replaces it...
3. Graphics modes changed to be enums, From `pancake.graphics.FILL` for example to `Mode.FILL`.

### Using JavaScript code of Pancake

As script module available, It can be used to write Pancake JS code out of box, Simply...

```hx
// Main.hx
package;

import pancake.*;

/**
 * ...
 * @author Rabia Haffar
 */
class Main 
{
    public static function main(): Void {
        Pancake.script.load("game.js");
    }
}
```

```js
// game.js
pancake.canvas.create(800, 600, 0);
pancake.context.create(0, 0);
pancake.graphic.useContext(0);
// ...
```

### API

Can be found [here](https://github.com/Rabios/Pancake/blob/master/api.md), But make sure to follow differences happen in Haxe port!

### License

```
MIT License

Copyright (c) 2021 Rabia Alhaffar

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

