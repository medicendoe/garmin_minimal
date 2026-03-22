import Toybox.Graphics;
import Toybox.System;

/**
 * Layer to display the battery indicator.
 */
class BatteryLayer extends Layer {
    private var _centerX as Number;
    private var _centerY as Number;
    private var _radius as Number;
    private var _batteryPercentage as Float;

    /**
     * Initializes the battery layer.
     * @param centerX The x coordinate of the center
     * @param centerY The y coordinate of the center
     * @param radius The radius of the battery arc
     */
    function initialize(centerX as Number, centerY as Number, radius as Number) {
        Layer.initialize();
        _centerX = centerX;
        _centerY = centerY;
        _radius = radius;
        _batteryPercentage = 100.0f;
        update();
    }

    /**
     * Updates the battery percentage.
     */
    function update() as Void {
        if (!_visible) {
            return;
        }
        var systemStats = System.getSystemStats();
        _batteryPercentage = systemStats.battery;
    }

    /**
     * Draws the battery indicator on the device context.
     * @param dc The device context
     */
    function draw(dc as Dc) as Void {
        if (!_visible) {
            return;
        }

        dc.setColor(_color, Graphics.COLOR_TRANSPARENT);

        var angleStart = 90;
        var angleEnd;

        if (_batteryPercentage <= 0.5) {
            return;
        } else if (_batteryPercentage >= 99.5) {
            // Full circle
            angleEnd = angleStart;
            dc.drawArc(_centerX, _centerY, _radius, Graphics.ARC_CLOCKWISE, angleStart, angleEnd);
        } else {
            // Partial arc based on battery percentage
            var sweepAngle = (_batteryPercentage / 100.0) * 360.0;
            angleEnd = angleStart - sweepAngle;
            dc.drawArc(_centerX, _centerY, _radius, Graphics.ARC_CLOCKWISE, angleStart, angleEnd);
        }
    }
}
