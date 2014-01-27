/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 09.11.13
 * Time: 0:37
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.candyRush.model {

public class Match {

    private var _cells: Vector.<Cell>;
    public function get cells():Vector.<Cell> {
        return _cells;
    }

    public function get amount():int {
        return _cells.length;
    }

    public function get multiplier():Number {
        return Math.pow(_cells.length-2, 1.3);
    }

    public function get type():int {
        return _cells.length>0 ? _cells[0].type : 0;
    }

    public function Match() {
        _cells = new <Cell>[];
    }

    public function addCell(cell: Cell):Boolean {
        if (cell.type && (!type || cell.type==type)) {
            _cells.push(cell);
            return true;
        }
        return false;
    }
}
}
