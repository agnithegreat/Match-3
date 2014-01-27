package {
import flash.desktop.NativeApplication;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display3D.Context3DProfile;
import flash.display3D.Context3DRenderMode;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.system.Capabilities;

import starling.core.Starling;
import starling.events.Event;

[SWF(frameRate="60", width="384", height="512", backgroundColor="0")]
public class Main extends Sprite {

    [Embed(source="../assets/back.jpg")]
    private static var Background:Class;

    private var _background: Bitmap;

    private var viewPort: Rectangle;

    private var _starling: Starling;

    public function Main() {
        if (stage) {
            handleAddedToStage();
        } else {
            addEventListener(flash.events.Event.ADDED_TO_STAGE, handleAddedToStage);
        }
    }

    private function handleAddedToStage(event:flash.events.Event = null):void {
        removeEventListener(flash.events.Event.ADDED_TO_STAGE, handleAddedToStage);
        init();
    }

    private function init():void {
        var mobile: Boolean = Capabilities.manufacturer.indexOf("iOS") != -1 || Capabilities.manufacturer.indexOf("Android") != -1;
        Starling.multitouchEnabled = true;
        Starling.handleLostContext = !mobile;

        var artSize: Rectangle = new Rectangle(0, 0, 768, 1024);
        var deviceSize: Rectangle = mobile ? new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight) : new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
        artSize.width = deviceSize.width*artSize.height/deviceSize.height;

        var scaleY: Number = deviceSize.height/artSize.height;
        var newW: int = artSize.width*scaleY;
        var newH: int = artSize.height*scaleY;
        viewPort = new Rectangle((deviceSize.width-newW)/2, (deviceSize.height-newH)/2, newW, newH);

        _background = new Background();
        Background = null;

        var scale: Number = deviceSize.height/_background.height;
        _background.scaleX = scale;
        _background.scaleY = scale;
        _background.x = (stage.stageWidth-_background.width)/2;
        _background.smoothing = true;
        addChild(_background);

        _starling = new Starling(App, stage, viewPort, null, Context3DRenderMode.AUTO, Context3DProfile.BASELINE_CONSTRAINED);
        _starling.antiAliasing = 16;
        _starling.stage.stageWidth = artSize.width;
        _starling.stage.stageHeight = artSize.height;
        _starling.showStats = true;
        _starling.showStatsAt("left", "top", 2/scaleY);
        _starling.simulateMultitouch = false;
        _starling.enableErrorChecking = Capabilities.isDebugger;

        _starling.addEventListener(starling.events.Event.ROOT_CREATED, handleRootCreated);

        NativeApplication.nativeApplication.addEventListener(
                flash.events.Event.ACTIVATE, function (e:*):void { _starling.start(); });

        NativeApplication.nativeApplication.addEventListener(
                flash.events.Event.DEACTIVATE, function (e:*):void { _starling.stop(); });
    }

    private function handleRootCreated(event: Object,  app: App):void {
        _starling.removeEventListener(starling.events.Event.ROOT_CREATED, handleRootCreated);
        app.start(_background);
        _starling.start();
    }
}
}
