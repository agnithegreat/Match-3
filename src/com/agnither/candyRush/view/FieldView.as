/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 08.11.13
 * Time: 23:35
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.candyRush.view {
import com.agnither.candyRush.model.Game;
import com.agnither.candyRush.model.Gem;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import flash.geom.Rectangle;

import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class FieldView extends AbstractView {

    public static const SELECT_CELL: String = "select_cell_FieldView";

    public static var cellWidth: int = 80;
    public static var cellHeight: int = 80;

    private var _game: Game;

    private var _cellsContainer: Sprite;
    private var _gemsContainer: Sprite;

    private var _rollOver: CellView;

    public function FieldView(refs:CommonRefs, game: Game) {
        _game = game;
        _game.addEventListener(Game.INIT, handleInit);
        _game.addEventListener(Game.CLEAR, handleClear);

        super(refs);
    }

    override protected function initialize():void {
        _cellsContainer = new Sprite();
        _cellsContainer.x = stage.stageWidth/2;
        _cellsContainer.y = stage.stageHeight/2;
        addChild(_cellsContainer);
        _cellsContainer.addEventListener(TouchEvent.TOUCH, handleTouch);

        _gemsContainer = new Sprite();
        _gemsContainer.x = _cellsContainer.x;
        _gemsContainer.y = _cellsContainer.y;
        addChild(_gemsContainer);
        _gemsContainer.touchable = false;
        _gemsContainer.clipRect = new Rectangle(0,0,720,720);
        _gemsContainer.addEventListener(GemView.REMOVE, handleRemove);
    }

    private function handleInit(e: Event):void {
        y = -stage.stageHeight;
        Starling.juggler.tween(this, 0.3, {y: 0});

        _game.addEventListener(Game.NEW_GEM, handleNewGem);

        for (var i:int = 0; i < _game.field.length; i++) {
            var cell: CellView = new CellView(_refs, _game.field[i]);
            _cellsContainer.addChild(cell);

            var gem: GemView = new GemView(_refs, _game.field[i].gem);
            _gemsContainer.addChild(gem);
        }

        _cellsContainer.pivotX = _cellsContainer.width/2;
        _cellsContainer.pivotY = _cellsContainer.height/2;
        _gemsContainer.pivotX = _cellsContainer.pivotX;
        _gemsContainer.pivotY = _cellsContainer.pivotY;
    }

    private function handleNewGem(e: Event):void {
        var gem: GemView = new GemView(_refs, e.data as Gem);
        _gemsContainer.addChild(gem);
    }

    private function handleRemove(e: Event):void {
        var gem: GemView = e.target as GemView;
        _gemsContainer.addChild(gem);
        Starling.juggler.tween(gem, Gem.FALL_SPEED*8, {y: gem.y+cellHeight*8, alpha: 0, transition: Transitions.EASE_IN, onComplete: gem.destroy});
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(_cellsContainer);
        if (touch) {
            var test: DisplayObject = _cellsContainer.hitTest(touch.getLocation(_cellsContainer));
            if (test) {
                var cell: CellView = test.parent as CellView;
                if (cell) {
                    if (touch.phase == TouchPhase.BEGAN || touch.phase == TouchPhase.MOVED && _rollOver && _rollOver != cell) {
                        _rollOver = cell;
                        dispatchEventWith(SELECT_CELL, true, _rollOver.cell);

                        if (touch.phase != TouchPhase.BEGAN) {
                            _rollOver = null;
                        }
                    } else if (touch.phase == TouchPhase.ENDED) {
                        _rollOver = null;
                    }
                }
            }
        }
    }

    private function handleClear(e: Event):void {
        _game.removeEventListener(Game.NEW_GEM, handleNewGem);

        while (_cellsContainer.numChildren>0) {
            var cell: CellView = _cellsContainer.removeChildAt(0) as CellView;
            cell.destroy();
        }

        while (_gemsContainer.numChildren>0) {
            var gem: GemView = _gemsContainer.removeChildAt(0) as GemView;
            gem.destroy();
        }

        _rollOver = null;
    }
}
}
