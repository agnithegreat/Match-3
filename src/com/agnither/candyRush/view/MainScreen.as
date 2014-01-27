/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 08.11.13
 * Time: 22:17
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.candyRush.view {
import com.agnither.candyRush.GameController;
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;

public class MainScreen extends Screen {

    private var _controller: GameController;

    private var _field: FieldView;

    public function MainScreen(refs: CommonRefs, controller: GameController) {
        _controller = controller;

        super(refs, "back");
    }

    override protected function initialize():void {
        var scale: Number = stage.stageHeight/_background.height;
        _background.scaleX = scale;
        _background.scaleY = scale;
        _background.x = (stage.stageWidth-_background.width)/2;

        _field = new FieldView(_refs, _controller.game);
        addChild(_field);
    }
}
}
