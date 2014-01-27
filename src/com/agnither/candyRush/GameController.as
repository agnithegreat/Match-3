/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 08.11.13
 * Time: 20:53
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.candyRush {
import com.agnither.candyRush.model.Cell;
import com.agnither.candyRush.model.Game;
import com.agnither.candyRush.ui.LogoUI;
import com.agnither.candyRush.ui.UI;
import com.agnither.candyRush.view.FieldView;
import com.agnither.candyRush.view.MainScreen;
import com.agnither.utils.CommonRefs;

import starling.display.Stage;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.events.EventDispatcher;

public class GameController extends EventDispatcher {

    public static const INIT: String = "init_GameController";

    private var _stage: Stage;
    private var _refs: CommonRefs;

    private var _view: MainScreen;
    private var _ui: UI;

    private var _game: Game;
    public function get game():Game {
        return _game;
    }

    public function GameController(stage: Stage, refs: CommonRefs) {
        _stage = stage;
        _refs = refs;
    }

    public function init():void {
        initModel();
        initView();

        dispatchEventWith(INIT);
    }

    private function initModel():void {
        _game = new Game();
        _game.addEventListener(Game.END_TIME, handleEndTime);
    }

    private function initView():void {
        _view = new MainScreen(_refs, this);
        _stage.addEventListener(FieldView.SELECT_CELL, handleSelectCell);
        _stage.addChildAt(_view, 0);

        _ui = new UI(_refs, this);
        _stage.addEventListener(LogoUI.CONTINUE, handleContinue);
        _stage.addChildAt(_ui, 1);

        _stage.addEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);
    }

    public function startGame():void {
        _game.init(7, 8);
    }

    private function handleEnterFrame(e: EnterFrameEvent):void {
        _game.step(e.passedTime);
    }

    private function handleEndTime(e: Event):void {
        _game.clear();
    }

    private function handleContinue(e: Event):void {
        startGame();
    }

    private function handleSelectCell(e: Event):void {
        _game.selectCell(e.data as Cell);
    }
}
}
