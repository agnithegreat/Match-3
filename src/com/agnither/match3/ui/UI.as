/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 08.11.13
 * Time: 22:19
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.match3.ui {
import com.agnither.match3.GameController;
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;

public class UI extends Screen {

    private var _controller: GameController;

    private var _logoUI: LogoUI;
    private var _gameUI: GameUI;

    public function UI(refs:CommonRefs, controller: GameController) {
        _controller = controller;

        super(refs);
    }

    override protected function initialize():void {
        _logoUI = new LogoUI(_refs);
        addChild(_logoUI);

        _gameUI = new GameUI(_refs, _controller.game);
        addChild(_gameUI);
    }
}
}
