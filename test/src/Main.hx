package;

import pancake.*;

/**
 * ...
 * @author Rabia Haffar
 */
class Main 
{
    public static function main(): Void {
        Pancake.graphics.loadImage("pancake.png", 0);
        Pancake.graphics.loadImage("haxe.png", 1);
		
        Pancake.canvas.create(800, 600, 0);
        Pancake.context.create(0, 0);
        Pancake.graphics.useContext(0);
        Pancake.canvases[0].style.border = "1px black solid";
		
        var logo_x: Int = 280;
        var logo_y: Int = 150;
        var timer: Int = 0;
        
        function game() {
            Pancake.graphics.clear();
            Pancake.graphics.imageFromIndex(0, logo_x, logo_y, 256, 256);
            Pancake.graphics.imageFromIndex(1, logo_x + 63, logo_y + 80, 128, 128);
            if (timer++ == 20) {
                Pancake.graphics.setBackgroundColor(Pancake.graphics.random.RGBA());
                timer = 0;
            }
        }
        
        var gameloop: Int = Pancake.timers.timer(game, 60);
    }
}
