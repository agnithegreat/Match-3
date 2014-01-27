/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 12.06.13
 * Time: 10:26
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.utils {
import starling.utils.AssetManager;

public class CommonRefs {

    private var _assets: AssetManager;
    public function get assets():AssetManager {
        return _assets;
    }

    private var _locale: ILocale;
    public function get locale():ILocale {
        return _locale;
    }

    public function CommonRefs(assets: AssetManager, locale: ILocale) {
        _assets = assets;
        _locale = locale;
    }
}
}
