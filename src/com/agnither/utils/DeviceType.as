/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 05.06.13
 * Time: 14:49
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.utils {
import flash.geom.Rectangle;

public class DeviceType {

    public static const iPad: DeviceType = new DeviceType(1024,768);

    public var size: Rectangle;

    public function DeviceType(w: int, h: int) {
        this.size = new Rectangle(0, 0, w, h);
    }
}
}
