/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 27.05.13
 * Time: 21:23
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.match3.data {
import flash.media.AudioPlaybackMode;
import flash.media.SoundMixer;
import flash.net.SharedObject;

import starling.display.Stage;
import starling.events.Event;
import starling.utils.AssetManager;

public class Sound {

    public static const SOUND: String = "sound_Sound";

    public static const CRACK: String = "crack";
    public static const SWAP: String = "swap";
    public static const MUSIC: String = "CANDYRUSH";

    private static var _data: SharedObject;
    public static function set mute(value: Boolean):void {
        _data.data.mute = value;
        try {
            _data.flush();
        }
        catch (e: Error) {
            trace("SharedObject is blocked");
        }
    }
    public static function get mute():Boolean {
        return _data.data.mute;
    }

    private static var _assets: AssetManager;

    public static function init(assets: AssetManager):void {
        SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
        _data = SharedObject.getLocal("data");
        _assets = assets;
    }

    public static function listen(stage: Stage):void {
        stage.addEventListener(SOUND, handlePlaySound);
    }

    private static function handlePlaySound(event: Event):void {
        play(event.data as String);
    }

    public static function play(sound: String, loops: int = 0):void {
        if (!mute) {
            _assets.playSound(sound, 0, loops);
        }
    }
}
}
