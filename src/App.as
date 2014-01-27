/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 8/23/13
 * Time: 11:17 PM
 * To change this template use File | Settings | File Templates.
 */
package {
import com.agnither.candyRush.GameController;
import com.agnither.candyRush.data.MultiplierVO;
import com.agnither.candyRush.data.Sound;
import com.agnither.utils.CommonRefs;

import flash.display.Bitmap;

import flash.filesystem.File;

import starling.display.Sprite;
import starling.utils.AssetManager;

public class App extends Sprite {

    private var _assets: AssetManager;

    private var _background: Bitmap;

    private var _refs: CommonRefs;

    private var _controller: GameController;

    public function start(background: Bitmap):void {
        _background = background;

        _assets = new AssetManager();
//        _assets.verbose = true;

        _refs = new CommonRefs(_assets, null);
        _controller = new GameController(stage, _refs);

        var file: File = File.applicationDirectory;
        _assets.enqueue(
                file.resolvePath("textures"),
                file.resolvePath("fonts"),
                file.resolvePath("sounds"),
                file.resolvePath("config")
        );
        _assets.loadQueue(handleProgress);
    }

    private function handleProgress(value: Number):void {
        if (value == 1) {
            init();
        }
    }

    private function init():void {
        _background.parent.removeChild(_background);
        _background = null;

        MultiplierVO.parse(_assets.getObject("multipliers"));

        Sound.listen(stage);
        Sound.init(_assets);

        _controller.init();
    }
}
}
