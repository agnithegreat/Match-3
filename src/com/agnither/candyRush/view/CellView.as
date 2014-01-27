/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 08.11.13
 * Time: 23:47
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.candyRush.view {
import com.agnither.candyRush.model.Cell;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Image;
import starling.events.Event;

public class CellView extends AbstractView {

    private var _cell: Cell;
    public function get cell():Cell {
        return _cell;
    }

    private var _image: Image;

    public function CellView(refs:CommonRefs, cell: Cell) {
        _cell = cell;
        _cell.addEventListener(Cell.SELECT, handleSelect);

        super(refs);
    }

    override protected function initialize():void {
        _image = new Image(_refs.assets.getTexture("cell.png"));
        _image.alpha = 0.8;
        addChild(_image);

        x = _cell.x * FieldView.cellWidth;
        y = _cell.y * FieldView.cellHeight;
    }

    private function handleSelect(e: Event):void {
        _image.color = _cell.selected ? 0xFF0000 : 0xFFFFFF;
    }

    override public function destroy():void {
        _cell.removeEventListener(Cell.SELECT, handleSelect);
        _cell = null;

        removeChild(_image, true);
        _image = null;

        super.destroy();
    }
}
}
