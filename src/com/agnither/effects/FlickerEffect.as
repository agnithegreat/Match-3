/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 10/9/13
 * Time: 7:58 PM
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.effects {
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.utils.Color;

public class FlickerEffect {

    public static function createFlicker(obj: DisplayObject, color: int, time: Number, amount: int = 1):FlickerEffect {
        return new FlickerEffect(obj, color, time, amount);
    }

    public static function resetColoring(obj: DisplayObject):void {
        return setParentImageColor(obj, 0xFFFFFF);
    }

    private static function setParentImageColor(obj: DisplayObject, color: int):void {
        if (obj && obj.hasOwnProperty("color")) {
            obj["color"] = color;
        } else {
            var cont: DisplayObjectContainer = obj as DisplayObjectContainer;
            if (cont) {
                var len: int = cont.numChildren;
                for (var i:int = 0; i < len; i++) {
                    setParentImageColor(cont.getChildAt(i), color);
                }
            }
        }
    }

    private var _obj: DisplayObject;

    private var _r: int;
    private var _g: int;
    private var _b: int;

    private var _tween: Tween;

    private var _progress: Number;

    public function get ended():Boolean {
        return !_obj;
    }

    private var _time: Number;
    private var _amount: int;

    public function FlickerEffect(obj: DisplayObject, color: int, time: Number, amount: int = 1) {
        _obj = obj;

        var c: Object = hexToRGB(color);
        _r = c.red;
        _g = c.green;
        _b = c.blue;

        _time = time;
        _amount = amount;

        progress = 0;

        _tween = new Tween(this, _time);
        _tween.animate("progress", 1);
        _tween.onComplete = complete;
        Starling.juggler.add(_tween);
    }

    public function set progress(value: Number):void {
        _progress = value;
        var val: Number = _progress<0.5 ? _progress*2 : (1-_progress)*2;
        setParentImageColor(_obj, Color.rgb(255-val*(255-_r), 255-val*(255-_g), 255-val*(255-_b)));
    }

    public function get progress():Number {
        return _progress;
    }

    private function hexToRGB(hex: uint):Object {
        var rgbObj: Object = {
            red: ((hex & 0xFF0000) >> 16),
            green: ((hex & 0x00FF00) >> 8),
            blue: ((hex & 0x0000FF))
        };
        return rgbObj;
    }

    private function complete():void {
        if (_amount>0) {
            _amount--;
            if (_amount==0) {
                destroy();
                return;
            }
        }
        _tween = new Tween(this, _time);
        _tween.animate("progress", 1);
        _tween.onComplete = complete;
        Starling.juggler.add(_tween);
    }

    public function destroy():void {
        Starling.juggler.remove(_tween);
        _tween = null;

        progress = 1;

        _obj = null;
    }
}
}
