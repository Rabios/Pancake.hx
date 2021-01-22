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
--std full
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

Then you can write HTML file, For example:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Title will be changed by Pancake.game.title function -->
    <meta charset="utf-8">
</head>
<body>
    <!-- NOTE: You should put JavaScript of Pancake inside body, That's to not throw errors... -->
    <script src="test.js"></script>
</body>
</html>
```

### Modules

Modules are parts of Pancake that you can enable or disable them, Like Sound, Graphics, Input, etc...

You can include or remove parts of Pancake you don't need, You can also specify backend...

```
# Modules, Comment one of them to disable them...

# [1] For including one of following modules below, You'll need to define PANCAKE_GRAPHICS with backend to include graphics
# PANCAKE_VIDEO
# PANCAKE_SPRITE
# PANCAKE_GIF
# PANCAKE_SPRITEFONT

# [2] For including replay module via defining PANCAKE_REPLAY, You'll need to define PANCAKE_INPUT to include input as replay module records input
# [3] Pancake's default graphics backend is CanvasRenderingContext2D, But you can change it to use WebGL via changing PANCAKE_CANVAS2D to PANCAKE_WEBGL
# [4] If you disabled graphics module, Some other modules that depends on graphics will be removed...

--define PANCAKE_CANVAS2D
--define PANCAKE_GRAPHICS
--define PANCAKE_VIDEO
--define PANCAKE_SPRITE
--define PANCAKE_GIF
--define PANCAKE_SPRITEFONT
--define PANCAKE_AUDIO
--define PANCAKE_INPUT
--define PANCAKE_DEVICE
--define PANCAKE_OS
--define PANCAKE_REPLAY
--define PANCAKE_UTIL
--define PANCAKE_PHYSICS
--define PANCAKE_STORAGE
--define PANCAKE_TIMERS
--define PANCAKE_SCRIPT
--define PANCAKE_BROWSER
--define PANCAKE_XHR
--define PANCAKE_GAME
--define PANCAKE_CONTENT

--class-path src
--dce std
pancake.Pancake
--js bin/Pancake.js
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

Can be found [here](https://github.com/Rabios/Pancake/blob/master/docs/api.md), But make sure to follow differences happen in Haxe port!

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
