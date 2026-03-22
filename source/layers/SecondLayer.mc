import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SecondLayer {
    private var _secondView;
    private var _secondString;
    private var _color as Number;
    private var _hasBurnInProtection as Boolean;

    function initialize(view as Text) {
        _hasBurnInProtection = System.getDeviceSettings().requiresBurnInProtection;
        _secondView = view;
        _color = Graphics.COLOR_WHITE;
        update();
    }

    function setColor(color as Number) as Void {
        _color = color;
    }

    function update() as Void {
        _secondString = System.getClockTime().sec.format("%02d");
    }

    function draw(dc as Dc) as Void {
        _secondView.setText(_secondString);
        _secondView.setColor(_color);
    }

    function drawPartial(dc as Dc) as Void {
        if (_hasBurnInProtection) {
            return;
        }
        var locX = _secondView.locX;
        var locY = _secondView.locY;
        dc.setClip(locX, locY, _secondView.width, _secondView.height);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(_color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(locX, locY, Graphics.FONT_LARGE, _secondString, Graphics.TEXT_JUSTIFY_LEFT);
        dc.clearClip();
    }
}
