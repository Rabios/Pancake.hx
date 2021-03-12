# CHANGELOG

### v1.0.5 (Pancake v0.0.15)

> Haxelib version: 1.0.16

1. Fixed gamepad input on UWP platform, As done with Pancake v0.0.15!
2. Fixed alpha setting for `pancake.graphics.random.RGBA` and `pancake.graphics.RGBA` for `CanvasRenderingContext2D` backend!
3. Removed `Mode` enum, Use `pancake.graphics.<Mode>` as same in JavaScript version!

### v1.0.3 (Pancake v0.0.14)

> Haxelib version: 1.0.14

1. Update to Pancake v0.0.14!
2. Added input constants, And stuff related to what added in Pancake v0.0.14!
3. Added gamepad input support for UWP and WinJS, In addition to more stuff!
4. Now Pancake is able to work with Phonegap, Cordova, NWJS, Electron, UWP, WinJS at same time!
5. Improved working with native layers (As of haxelib version 1.0.14), Now they should work %100!

### v1.0.2 (Pancake v0.0.13)

> Haxelib version: 1.0.11

1. Improvements on design on port!
2. Reverted additions of `Pancake.graphics.setMode` and `Pancake.graphics.disableTint` and `Pancake.graphics.setTint`

> By mean to use tint you change value of `Pancake.graphics.tint`, To disable tint by setting `Pancake.graphics.tint` to `null`, And to set drawing mode change value of `Pancake.graphics.mode` to one of types in `Mode` enum!

3. Added some compatibility!
4. Fixed `Pancake.timers.dt()` and added `Pancake.timers.fps()`!

### v1.0.1 (Pancake v0.0.13)

> Haxelib version: 1.0.7

1. Now if your are using Pancake with Cordova or Phonegap it's possible to close game natively instead of close window...
2. Fixed fullscreen functionality!
3. Improved gamepad functionality!

### v1.0.0 (Pancake v0.0.13)

First release, Looking for bugs to smash it!

> Fixed problem with including WebGL backend, Thanks [@AlexHaxe](https://github.com/AlexHaxe)!
