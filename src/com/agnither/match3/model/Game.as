/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 08.11.13
 * Time: 21:03
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.match3.model {
import com.agnither.match3.data.MultiplierVO;
import com.agnither.match3.data.Sound;

import flash.geom.Point;

import starling.core.Starling;
import starling.events.EventDispatcher;

public class Game extends EventDispatcher {

    public static const INIT: String = "init_Game";
    public static const NEW_GEM: String = "new_gem_Game";
    public static const SCORE: String = "score_Game";
    public static const UPDATE: String = "update_Game";
    public static const END_TIME: String = "end_time_Game";
    public static const CLEAR: String = "clear_Game";

    public static var levelTime: int = 60;
    public static var baseScore: int = 50;
    public static var multiplierIncrease: Number = 0.5;
    public static var multiplierDecrease: Number = 0.7;

    private var _width: int;
    private var _height: int;

    private var _fieldObj: Object;
    private var _field: Vector.<Cell>;
    public function get field():Vector.<Cell> {
        return _field;
    }

    private var _availableMoves: Vector.<Move>;
    private var _matches: Vector.<Match>;

    private var _selectedCell: Cell;

    private var _score: int;
    public function get score():int {
        return _score;
    }

    private var _multiplier: Number;
    public function get multiplier():int {
        return MultiplierVO.getMultiplier(_multiplier);
    }

    private var _time: Number;
    public function get time():int {
        return Math.ceil(_time);
    }

    private var _init: Boolean;

    private var _delayedCalls: int;

    public function Game() {
        Sound.play(Sound.MUSIC, 1000);
    }

    public function init(width: int, height: int):void {
        _width = width;
        _height = height;

        _score = 0;
        _multiplier = 0;
        _time = levelTime;
        _delayedCalls = 0;

        createField();
        refillGems();

        findMatches();
        while (_matches.length>0) {
            fixMatches();
            findMatches();
        }
        findMoves();

        dispatchEventWith(INIT);
        _init = true;
    }

    public function clear():void {
        _init = false;

        dispatchEventWith(CLEAR);

        _fieldObj = null;

        while (_field.length>0) {
            var cell: Cell = _field.pop();
            cell.clear();
        }
        _field = null;

        _availableMoves = null;
        _matches = null;
        _selectedCell = null;
        _score = 0;
        _multiplier = 0;
        _time = 0;
    }

    private function delayedCall(call: Function, delay: Number):void {
        _delayedCalls++;
        Starling.juggler.delayCall(delayedCallFinal, delay, call);
    }

    private function delayedCallFinal(call: Function):void {
        _delayedCalls--;
        call();
    }

    private function addScore(value: int, direct: Boolean = false):void {
        if (!direct) {
            _multiplier += multiplierIncrease * value;
        }
        _score += direct ? value : baseScore * multiplier * value;
        dispatchEventWith(SCORE);
    }

    private function createField():void {
        _field = new <Cell>[];
        _fieldObj = {};
        for (var j:int = 0; j < _height; j++) {
            for (var i:int = 0; i < _width; i++) {
                var slot: Cell = new Cell(i, j);
                _field.push(slot);
                _fieldObj[i+"."+j] = slot;
            }
        }
    }

    private function findMoves():void {
        _availableMoves = new <Move>[];
        for (var i:int = 0; i < _field.length; i++) {
            var cell: Cell = _field[i];
            if (cell.x < _width-2) {
                _availableMoves = _availableMoves.concat(checkTriple([cell, getCell(cell.x+1, cell.y), getCell(cell.x+2, cell.y)]));
            }
            if (cell.y < _height-2) {
                _availableMoves = _availableMoves.concat(checkTriple([cell, getCell(cell.x, cell.y+1), getCell(cell.x, cell.y+2)]));
            }
        }
    }

    private function checkTriple(cells: Array):Vector.<Move> {
        cells.sortOn("type", Array.NUMERIC);

        var excess: Cell;
        if (cells[0].type != cells[1].type) {
            excess = cells[0];
        }
        if (cells[1].type != cells[2].type) {
            if (!excess) {
                excess = cells[2];
            } else {
                excess = null;
            }
        }

        var moves: Vector.<Move> = new <Move>[];
        if (excess) {
            var neighbours: Vector.<Cell> = getNeighbours(excess);
            for (var i:int = 0; i < neighbours.length; i++) {
                var neighbour: Cell = neighbours[i];
                if (cells.indexOf(neighbour)<0 && cells[1].type==neighbour.type) {
                    moves.push(new Move(excess, neighbour));
                }
            }
        }
        return moves;
    }

    public function selectCell(cell: Cell):void {
        if (_time == 0) {
            return;
        }

        if (cell.gem is Bonus) {
            addScore(cell.gem.type == Bonus.PIE ? 3000 : 5000, true);
            cell.clear();

            delayedCall(fallGems, Gem.KILL_SPEED);
            delayedCall(refillGems, Gem.KILL_SPEED);
            delayedCall(checkField, Gem.KILL_SPEED+Gem.FALL_SPEED*8);
            return;
        }

        if (_selectedCell) {
            _selectedCell.select(false);

            var distance: Number = Point.distance(_selectedCell.position, cell.position);
            if (distance > 1) {
                _selectedCell = cell;
                _selectedCell.select(true);
            } else if (distance == 1) {
                checkSwap(_selectedCell, cell);
                _selectedCell = null;
            } else {
                _selectedCell = null;
            }
        } else {
            _selectedCell = cell;
            _selectedCell.select(true);
        }
    }

    private function checkSwap(cell1: Cell, cell2: Cell):void {
        for (var i:int = 0; i < _availableMoves.length; i++) {
            var move: Move = _availableMoves[i];
            if (move.check(cell1, cell2)) {
                cell1.swap(cell2);
                Sound.play(Sound.SWAP);
                delayedCall(checkField, Gem.SWAP_SPEED);
                return;
            }
        }
        // TODO: feedback of wrong move
    }

    private function checkField():void {
        if (!_init) {
            return;
        }

        findMatches();
        if (_matches.length>0) {
            removeMatches();

            delayedCall(fallGems, Gem.KILL_SPEED);
            delayedCall(refillGems, Gem.KILL_SPEED);
            delayedCall(checkField, Gem.KILL_SPEED+Gem.FALL_SPEED*8);
        }
    }

    private function findMatches():void {
        _matches = new <Match>[];

        // check vertical matches
        var match: Match;
        for (var i:int = 0; i < _width; i++) {
            for (var j:int = 0; j < _height; j++) {
                var cell: Cell = getCell(i, j);
                if (match && !match.addCell(cell)) {
                    if (match.amount >= 3) {
                        _matches.push(match);
                    }
                    match = null;
                }
                if (!match) {
                    match = new Match();
                    match.addCell(cell);
                }
            }
            if (match.amount >= 3) {
                _matches.push(match);
            }
            match = null;
        }

        // check horizontal matches
        for (j = 0; j < _height; j++) {
            for (i = 0; i < _width; i++) {
                cell = getCell(i, j);
                if (match && !match.addCell(cell)) {
                    if (match.amount >= 3) {
                        _matches.push(match);
                    }
                    match = null;
                }
                if (!match) {
                    match = new Match();
                    match.addCell(cell);
                }
            }
            if (match.amount >= 3) {
                _matches.push(match);
            }
            match = null;
        }
    }

    private function fixMatches():void {
        for (var i:int = 0; i < _matches.length; i++) {
            var match: Match = _matches[i];
            match.cells[1].setGem(Gem.getRandom(false));
        }
    }

    private function removeMatches():void {
        var clear: Vector.<Cell> = new <Cell>[];
        while (_matches.length>0) {
            var match: Match = _matches.pop();
            for (var j:int = 0; j < match.cells.length; j++) {
                var matchCell: Cell = match.cells[j];
                if (clear.indexOf(matchCell) < 0) {
                    clear.push(matchCell);
                    matchCell.clear();
                }
            }

            if (match.amount>3) {
                var bonus: Bonus = Bonus.getBonus(match.amount);
                match.cells[2].setGem(bonus);
                dispatchEventWith(NEW_GEM, false, bonus)
            }

            addScore(match.multiplier);
        }

        findMoves();
    }

    private function fallGems():void {
        if (!_field) {
            return;
        }

        for (var i:int = 0; i < _width; i++) {
            for (var j:int = 0; j < _height; j++) {
                var cell: Cell = getCell(i, (_height-1)-j);
                var upper: Cell = cell;
                if (!cell.gem) {
                    while (upper && !upper.gem) {
                        upper = getCell(upper.x, upper.y-1);
                    }
                    if (upper) {
                        cell.swap(upper);
                    }
                }
            }
        }

        findMoves();

        Starling.juggler.delayCall(Sound.play, Gem.FALL_SPEED, Sound.CRACK);
    }

    private function refillGems():void {
        if (!_field) {
            return;
        }

        for (var i:int = 0; i < _width; i++) {
            for (var j:int = 0; j < _height; j++) {
                var cell: Cell = getCell(i, (_height-1)-j);
                if (!cell.gem) {
                    var gem: Gem = Gem.getRandom(_init);
                    cell.setGem(gem);
                    dispatchEventWith(NEW_GEM, false, gem);
                }
            }
        }

        findMoves();

        if (_availableMoves.length==0) {
            delayedCall(resetField, Gem.FALL_SPEED);
        }
    }

    private function resetField():void {
        for (var i:int = 0; i < _field.length; i++) {
            var cell: Cell = _field[i];
            cell.clear();
        }

        delayedCall(refillGems, Gem.KILL_SPEED);
    }

    private function getCell(x: int, y: int):Cell {
        return _fieldObj[x+"."+y];
    }

    private function getNeighbours(cell: Cell):Vector.<Cell> {
        var neighbours: Vector.<Cell> = new <Cell>[];
        for (var i:int = -1; i <= 1; i++) {
            for (var j:int = -1; j <= 1; j++) {
                if (Math.abs(i)+Math.abs(j)==1) {
                    var neighbour: Cell = getCell(cell.x+i, cell.y+j);
                    if (neighbour) {
                        neighbours.push(neighbour);
                    }
                }
            }
        }
        return neighbours;
    }

    public function step(delta: Number):void {
        if (!_init) {
            return;
        }

        _time -= delta;
        _time = Math.max(0, _time);

        _multiplier -= multiplierDecrease * delta;
        _multiplier = Math.max(0, _multiplier);

        dispatchEventWith(UPDATE);

        if (_time == 0 && _delayedCalls==0) {
            dispatchEventWith(END_TIME);
        }
    }
}
}
