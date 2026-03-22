import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

/**
 * Main watch face view that manages and updates layers.
 */
class watchView extends WatchUi.WatchFace {
    private var _layerManager as LayerManager;
    private var _secondLayer as SecondLayer?;

    function initialize() {
        WatchFace.initialize();
        _layerManager = new LayerManager();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));

        var screenWidth = dc.getWidth();
        var penWidth = 6;
        dc.setPenWidth(penWidth);
        var radius = (screenWidth / 2) - (penWidth / 2) - 2;
        var centerX = screenWidth / 2;
        var centerY = dc.getHeight() / 2;

        var batteryLayer = new BatteryLayer(centerX, centerY, radius);
        var timeLayer = new TimeLayer(View.findDrawableById("Time") as Text);
        _secondLayer = new SecondLayer(View.findDrawableById("Second") as Text);
        var dateLayer = new DateLayer(View.findDrawableById("Date") as Text);
        var dayMonthLayer = new DayMonthLayer(
            View.findDrawableById("Day") as Text,
            View.findDrawableById("Month") as Text
        );

        _layerManager.addLayer("battery", batteryLayer);
        _layerManager.addLayer("time", timeLayer);
        _layerManager.addLayer("second", _secondLayer);
        _layerManager.addLayer("date", dateLayer);
        _layerManager.addLayer("dayMonth", dayMonthLayer);
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        _layerManager.updateLayers();
        _layerManager.drawLayers(dc);
    }

    function onPartialUpdate(dc as Dc) as Void {
        // At the minute boundary, request a full update so TimeLayer stays in sync
        if (System.getClockTime().sec == 0) {
            WatchUi.requestUpdate();
            return;
        }
        var secondLayer = _secondLayer;
        if (secondLayer != null) {
            secondLayer.setColor(_layerManager.getBatteryColor());
            secondLayer.update();
            secondLayer.drawPartial(dc);
        }
    }

    function onExitSleep() as Void {
        _layerManager.updateLayers();
        WatchUi.requestUpdate();
    }

    function onEnterSleep() as Void {
        _layerManager.updateLayers();
    }
}
