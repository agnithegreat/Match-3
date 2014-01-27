/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 05.06.13
 * Time: 14:46
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.ui {
import com.agnither.utils.CommonRefs;
import com.agnither.utils.DeviceType;

import starling.display.Sprite;
import starling.events.Event;

public class AbstractView extends Sprite {

    protected var _refs: CommonRefs;

    public function AbstractView(refs: CommonRefs) {
        _refs = refs;

        addEventListener(Event.ADDED_TO_STAGE, handleAdded);
    }

    protected function initialize():void {
    }

    private function handleAdded(event: Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, handleAdded);

        initialize();
    }

    public function destroy():void {
        _refs = null;
    }
}
}