/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 10.11.13
 * Time: 0:52
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.match3.model {

public class Bonus extends Gem {

    public static const STRAWBERRY: int = 8;
    public static const PIE: int = 9;

    public static function getBonus(amount: int):Bonus {
        switch (amount) {
            case 4:
                return new Bonus(PIE);
            default:
                return new Bonus(STRAWBERRY);
        }
        return null;
    }

    public function Bonus(type:int) {
        super(type, false);
    }
}
}
