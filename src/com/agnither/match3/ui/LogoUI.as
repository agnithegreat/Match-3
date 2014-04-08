/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 10.11.13
 * Time: 10:55
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.match3.ui {
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;

import starling.display.Button;
import starling.display.Image;
import starling.events.Event;
import starling.text.BitmapFont;

public class LogoUI extends Screen {

    public static const CONTINUE: String = "continue_LogoUI";

    private var _logo: Image;

    private var _btn: Button;

    public function LogoUI(refs:CommonRefs) {
        super(refs);
    }

    override protected function initialize():void {
        _logo = new Image(_refs.assets.getTexture("logo.png"));
        _logo.pivotX = _logo.width/2;
        addChild(_logo);

        _logo.x = stage.stageWidth/2;
        _logo.y = 280;

        _btn = new Button(_refs.assets.getTexture("btn.png"), "PLAY");
        _btn.fontColor = 0xFFFFFF;
        _btn.fontName = "button_text";
        _btn.fontSize = -1;
        _btn.addEventListener(Event.TRIGGERED, handleClick);
        addChild(_btn);
        _btn.pivotX = _btn.width/2;
        _btn.pivotY = _btn.height/2;
        _btn.x = stage.stageWidth/2;
        _btn.y = 840;
    }

    private function handleClick(e: Event):void {
        visible = false;
        dispatchEventWith(CONTINUE, true);
    }
}
}
