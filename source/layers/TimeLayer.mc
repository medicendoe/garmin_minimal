import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class TimeLayer {
    private var _timeView;
    private var _timeString;
    private var _color as Number;

    function initialize(view as Text) {
        _timeView = view;
        _color = Graphics.COLOR_WHITE;
        var ct = System.getClockTime();
        _timeString = Lang.format("$1$$2$", [ct.hour.format("%02d"), ct.min.format("%02d")]);
    }

    function setColor(color as Number) as Void {
        _color = color;
    }

    function update(clockTime) as Void {
        _timeString = Lang.format("$1$$2$", [
            clockTime.hour.format("%02d"),
            clockTime.min.format("%02d")
        ]);
    }

    function draw(dc as Dc) as Void {
        _timeView.setText(_timeString);
        _timeView.setColor(_color);
    }

    function drawPartial(dc as Dc) as Void {
        var locX = _timeView.locX;
        var locY = _timeView.locY;
        dc.setClip(locX, locY, _timeView.width, _timeView.height);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(_color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(locX, locY, Graphics.FONT_NUMBER_THAI_HOT, _timeString, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.clearClip();
    }
}
