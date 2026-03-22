import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;

class BatteryLayer {
    private var _centerX as Number;
    private var _centerY as Number;
    private var _radius as Number;
    private var _batteryPercentage as Float;
    private var _color as Number;

    function initialize(centerX as Number, centerY as Number, radius as Number) {
        _centerX = centerX;
        _centerY = centerY;
        _radius = radius;
        _color = Graphics.COLOR_WHITE;
        _batteryPercentage = 100.0f;
        update();
    }

    function setColor(color as Number) as Void {
        _color = color;
    }

    function update() as Void {
        _batteryPercentage = System.getSystemStats().battery;
    }

    function draw(dc as Dc) as Void {
        dc.setColor(_color, Graphics.COLOR_TRANSPARENT);
        if (_batteryPercentage <= 0.5) {
            return;
        } else if (_batteryPercentage >= 99.5) {
            dc.drawArc(_centerX, _centerY, _radius, Graphics.ARC_CLOCKWISE, 90, 90);
        } else {
            var sweepAngle = (_batteryPercentage / 100.0) * 360.0;
            dc.drawArc(_centerX, _centerY, _radius, Graphics.ARC_CLOCKWISE, 90, 90 - sweepAngle);
        }
    }
}
