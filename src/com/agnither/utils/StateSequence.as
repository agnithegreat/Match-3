/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 8/26/13
 * Time: 11:36 AM
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.utils {
import com.agnither.game.model.personages.Personage;

import starling.events.EventDispatcher;

public class StateSequence extends EventDispatcher {

    public static const START_STATE: String = "start_state_StateSequence";

    private var _states: Vector.<String>;
    public function get currentState():String {
        return _states.length>0 ? _states[0] : null;
    }

    private var _defaultStates: Array = [];

    public function StateSequence() {
        _states = new <String>[];
    }

    public function addDefaultState(state: String):void {
        _defaultStates.push(state);
    }

    public function addState(name: String):void {
        var state: String = currentState;
        if (state==name) {
            return;
        }
        _states.push(name);

        if (!state) {
            startState();
        } else if (_defaultStates.indexOf(state)>=0) {
            nextState();
        }
    }

    public function nextState():void {
        endState();
        startState();
    }

    private function startState():void {
        if (currentState) {
            dispatchEventWith(START_STATE, false, currentState);
        }
    }

    private function endState():void {
        if (_states.length>0) {
            _states.shift();
        }
    }

    public function destroy():void {
        _states = null;
    }
}
}
