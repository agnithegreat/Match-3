/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 09.11.13
 * Time: 21:07
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.match3.ui {
import com.agnither.match3.model.Game;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.core.Starling;
import starling.display.Button;
import starling.events.Event;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.utils.HAlign;

public class GameUI extends AbstractView {

    private var _game: Game;

    private var _time: TextField;

    private var _score: TextField;

    private var _scoreVal: int;
    public function get score():int {
        return _scoreVal;
    }
    public function set score(val: int):void {
        _scoreVal = val;
        _score.text = String(_scoreVal);
    }

    private var _btn: Button;

    public function GameUI(refs:CommonRefs, game: Game) {
        _game = game;
        _game.addEventListener(Game.INIT, handleInit);
        _game.addEventListener(Game.SCORE, handleScore);
        _game.addEventListener(Game.UPDATE, handleUpdate);
        _game.addEventListener(Game.CLEAR, handleClear);
        super(refs);
    }

    override protected function initialize():void {
        _time = new TextField(100, 80, "60", "money", BitmapFont.NATIVE_SIZE, 0xFFFFFF);
        _time.touchable = false;
        _time.batchable = true;
        addChild(_time);

        _score = new TextField(stage.stageWidth, 80, "0", "money", BitmapFont.NATIVE_SIZE, 0xFFFFFF);
        _score.touchable = false;
        _score.pivotX = _score.width/2;
        _score.pivotY = _score.height/2;
        _score.batchable = true;
        _score.hAlign = HAlign.CENTER;
        addChild(_score);

        _btn = new Button(_refs.assets.getTexture("btn.png"), "REPLAY");
        _btn.fontColor = 0xFFFFFF;
        _btn.fontName = "button_text";
        _btn.fontSize = -1;
        _btn.addEventListener(Event.TRIGGERED, handleClick);
        addChild(_btn);
        _btn.pivotX = _btn.width/2;
        _btn.pivotY = _btn.height/2;
        _btn.x = stage.stageWidth/2;
        _btn.y = 840;
        _btn.visible = false;

        visible = false;
    }

    private function handleInit(e: Event):void {
        _score.scaleX = 1;
        _score.scaleY = 1;
        _score.x = stage.stageWidth/2;
        _score.y = 40;

        _time.text = "60";
        _score.text = "0";
        _scoreVal = 0;
        visible = true;
    }

    private function handleScore(e: Event):void {
        Starling.juggler.tween(this, 0.5, {score: _game.score});
    }

    private function handleUpdate(e: Event):void {
        _time.text = String(_game.time);
    }

    private function handleClear(e: Event):void {
        _time.text = "";
        Starling.juggler.tween(_score, 0.3, {y: stage.stageHeight/2, scaleX: 2, scaleY: 2});

        _btn.visible = true;
    }

    private function handleClick(e: Event):void {
        _btn.visible = false;
        dispatchEventWith(LogoUI.CONTINUE, true);
    }
}
}
