/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 08.11.13
 * Time: 23:31
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.match3.view {
import com.agnither.match3.model.Gem;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.Image;
import starling.events.Event;

public class GemView extends AbstractView {

    public static const REMOVE: String = "remove_GemView";

    private var _gem: Gem;

    private var _image: Image;

    public function GemView(refs:CommonRefs, gem: Gem) {
        _gem = gem;
        _gem.addEventListener(Gem.UPDATE, handleUpdate);
        _gem.addEventListener(Gem.KILL, handleKill);

        super(refs);
    }

    override protected function initialize():void {
        _image = new Image(_refs.assets.getTexture(_gem.type+".png"));
        _image.pivotX = _image.width/2;
        _image.pivotY = _image.height/2;
        _image.x = FieldView.cellWidth/2;
        _image.y = FieldView.cellWidth/2;
        addChild(_image);

        x = _gem.cell.x * FieldView.cellWidth;
        y = _gem.fall ? (_gem.cell.y-8) * FieldView.cellHeight : _gem.cell.y * FieldView.cellHeight;

        if (_gem.fall) {
            handleUpdate();
        }
    }

    private function handleUpdate(e: Event = null):void {
        var newX: int = _gem.cell.x * FieldView.cellWidth;
        var newY: int = _gem.cell.y * FieldView.cellHeight;
        if (e && e.data) {
            Starling.juggler.tween(this, Gem.SWAP_SPEED, {x: newX, y: newY});
        } else {
            var delta: int = Math.abs(newY-y)/FieldView.cellWidth;
            Starling.juggler.tween(this, Gem.FALL_SPEED*delta, {y: newY, transition: Transitions.EASE_OUT});
        }
    }

    private function handleKill(e: Event):void {
        remove();
    }

    private function remove():void {
        dispatchEventWith(REMOVE, true);
    }

    override public function destroy():void {
        _gem.removeEventListener(Gem.UPDATE, handleUpdate);
        _gem.removeEventListener(Gem.KILL, handleKill);
        _gem = null;

        removeChild(_image, true);
        _image = null;

        removeFromParent(true);

        super.destroy();
    }
}
}
