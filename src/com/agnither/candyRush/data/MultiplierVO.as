/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 10.11.13
 * Time: 0:13
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.candyRush.data {

public class MultiplierVO {

    public static var VALUES: Vector.<MultiplierVO>;
    public static function getMultiplier(value: Number):int {
        var last: int = 0;
        for (var i:int = 0; i < VALUES.length; i++) {
            var multiplier: MultiplierVO = VALUES[i];
            if (multiplier.value <= value) {
                last = multiplier.multiplier;
            } else {
                return last;
            }
        }
        return last;
    }

    public static function parse(data: Object):void {
        VALUES = new <MultiplierVO>[];

        for each (var o: Object in data) {
            var multiplier: MultiplierVO = new MultiplierVO();
            multiplier.id = o.id;
            multiplier.value = o.value;
            multiplier.multiplier = o.multiplier;
            VALUES.push(multiplier);
        }
    }

    public var id: int;
    public var value: Number;
    public var multiplier: int;
}
}
