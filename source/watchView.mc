import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

/**
 * Main watch face view that manages and updates layers.
 */
class watchView extends WatchUi.WatchFace {
    private var _batteryLayer as BatteryLayer?;
    private var _timeLayer as TimeLayer?;
    private var _secondLayer as SecondLayer?;
    private var _dateLayer as DateLayer?;
    private var _dayMonthLayer as DayMonthLayer?;
    private var _batteryColor as Number = Graphics.COLOR_WHITE;
    private var _lastHour as Number = -1;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        var penWidth = 6;
        dc.setPenWidth(penWidth);
        var screenWidth = dc.getWidth();
        var radius = (screenWidth / 2) - (penWidth / 2) - 2;
        _batteryLayer = new BatteryLayer(screenWidth / 2, dc.getHeight() / 2, radius);
        _timeLayer = new TimeLayer(View.findDrawableById("Time") as Text);
        _secondLayer = new SecondLayer(View.findDrawableById("Second") as Text);
        _dateLayer = new DateLayer(View.findDrawableById("Date") as Text);
        _dayMonthLayer = new DayMonthLayer(
            View.findDrawableById("Day") as Text,
            View.findDrawableById("Month") as Text
        );
    }

    function onUpdate(dc as Dc) as Void {
        var battery = System.getSystemStats().battery;
        _batteryColor = _computeBatteryColor(battery);
        var color = _batteryColor;
        var clockTime = System.getClockTime();
        var bl = _batteryLayer;
        var tl = _timeLayer;
        var sl = _secondLayer;
        var dl = _dateLayer;
        var dml = _dayMonthLayer;

        if (bl != null) { bl.setColor(color); bl.update(battery); }
        if (tl != null) { tl.setColor(color); tl.update(); tl.draw(dc); }
        if (sl != null) { sl.setColor(color); sl.update(); sl.draw(dc); }

        // Date and day/month change at most once per day — skip update() when hour is unchanged
        if (clockTime.hour != _lastHour) {
            _lastHour = clockTime.hour;
            if (dl != null) { dl.setColor(color); dl.update(); dl.draw(dc); }
            if (dml != null) { dml.setColor(color); dml.update(); dml.draw(dc); }
        } else {
            if (dl != null) { dl.setColor(color); dl.draw(dc); }
            if (dml != null) { dml.setColor(color); dml.draw(dc); }
        }

        View.onUpdate(dc);
        if (bl != null) { bl.draw(dc); }
    }

    function onPartialUpdate(dc as Dc) as Void {
        var color = _batteryColor;
        var clockTime = System.getClockTime();
        var sl = _secondLayer;
        var tl = _timeLayer;
        if (clockTime.sec == 0) {
            // At minute rollover: immediately show "00" and updated minutes, then full redraw
            if (sl != null) { sl.setColor(color); sl.update(); sl.drawPartial(dc); }
            if (tl != null) { tl.setColor(color); tl.update(); tl.drawPartial(dc); }
            WatchUi.requestUpdate();
            return;
        }
        if (sl != null) { sl.setColor(color); sl.update(); sl.drawPartial(dc); }
    }

    function onExitSleep() as Void {
        WatchUi.requestUpdate();
    }

    function onEnterSleep() as Void {
    }

    private function _computeBatteryColor(battery as Float) as Number {
        var normalColor = Application.Properties.getValue("NormalColor") as Number;
        var alertColor = Application.Properties.getValue("AlertColor") as Number;
        var threshold = Application.Properties.getValue("BatteryAlertThreshold") as Number;
        return (battery <= threshold) ? alertColor : normalColor;
    }
}
