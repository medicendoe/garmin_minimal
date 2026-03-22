import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.WatchUi;

/**
 * Returns the display color based on battery level.
 * At or below 15% returns alertColor, otherwise normalColor.
 */
function batteryColorFor(battery as Float, normalColor as Number, alertColor as Number) as Number {
    return (battery <= 15) ? alertColor : normalColor;
}

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
        _batteryColor = _computeBatteryColor();
        var color = _batteryColor;
        var clockTime = System.getClockTime();  // single read for all layers
        var bl = _batteryLayer;
        var tl = _timeLayer;
        var sl = _secondLayer;
        var dl = _dateLayer;
        var dml = _dayMonthLayer;

        if (bl != null) { bl.setColor(color); bl.update(); }
        if (tl != null) { tl.setColor(color); tl.update(clockTime); tl.draw(dc); }
        if (sl != null) { sl.setColor(color); sl.update(clockTime); sl.draw(dc); }

        // Date and day/month change at most once per day — only update when the hour changes.
        // Time.now() is read once and shared between both Gregorian.info calls.
        if (clockTime.hour != _lastHour) {
            _lastHour = clockTime.hour;
            var now = Time.now();
            var shortInfo = Time.Gregorian.info(now, Time.FORMAT_SHORT);
            var medInfo = Time.Gregorian.info(now, Time.FORMAT_MEDIUM);
            if (dl != null) { dl.setColor(color); dl.update(shortInfo.day, shortInfo.month, shortInfo.year); dl.draw(dc); }
            if (dml != null) { dml.setColor(color); dml.update(medInfo.day_of_week, medInfo.month); dml.draw(dc); }
        } else {
            if (dl != null) { dl.setColor(color); dl.draw(dc); }
            if (dml != null) { dml.setColor(color); dml.draw(dc); }
        }

        View.onUpdate(dc);
        if (bl != null) { bl.draw(dc); }
    }

    function onPartialUpdate(dc as Dc) as Void {
        var color = _batteryColor;
        var clockTime = System.getClockTime();  // single read for sec check + layer update
        var sl = _secondLayer;
        var tl = _timeLayer;
        if (clockTime.sec == 0) {
            // At minute rollover: immediately show "00" and updated minutes, then full redraw
            if (sl != null) { sl.setColor(color); sl.update(clockTime); sl.drawPartial(dc); }
            if (tl != null) { tl.setColor(color); tl.update(clockTime); tl.drawPartial(dc); }
            WatchUi.requestUpdate();
            return;
        }
        if (sl != null) { sl.setColor(color); sl.update(clockTime); sl.drawPartial(dc); }
    }

    function onExitSleep() as Void {
        WatchUi.requestUpdate();
    }

    function onEnterSleep() as Void {
    }

    private function _computeBatteryColor() as Number {
        var normalColor = Application.Properties.getValue("NormalColor") as Number;
        var alertColor = Application.Properties.getValue("AlertColor") as Number;
        return batteryColorFor(System.getSystemStats().battery, normalColor, alertColor);
    }
}
