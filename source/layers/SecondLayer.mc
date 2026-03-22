import Toybox.Graphics;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Lang;

/**
 * Layer to display the seconds.
 */
class SecondLayer extends Layer {
    private var _secondView;
    private var _secondString;
    private var _hasBurnInProtection;

    /**
     * Initializes the seconds layer.
     * @param view The text view to display the seconds
     */
    function initialize(view as Text) {
        Layer.initialize();
        _hasBurnInProtection = System.getDeviceSettings().requiresBurnInProtection;
        _secondView = view;
        update();
    }

    /**
     * Updates the seconds string.
     */
    function update() as Void {
        _secondString = System.getClockTime().sec.format("%02d");
    }

    /**
     * Draws the seconds string on the device context.
     * @param dc The device context
     */
    function draw(dc as Dc) as Void {
        if (!_visible || _secondView == null) {
            return;
        }

        _secondView.setText(_secondString);
        _secondView.setColor(_color);
    }

    /**
     * Special method for partial update of the seconds.
     * @param dc The device context
     */
    function drawPartial(dc as Dc) as Void {
        if (_hasBurnInProtection || _secondView == null) {
            return;
        }

        var clockTime = System.getClockTime();
        var locX = _secondView.locX;
        var locY = _secondView.locY;
        var width = _secondView.width;
        var height = _secondView.height;
        
        // Configure the clip region to update only the seconds area
        dc.setClip(locX, locY, width, height);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(_color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(locX, locY, Graphics.FONT_LARGE, clockTime.sec.format("%02d"), Graphics.TEXT_JUSTIFY_LEFT);
        dc.clearClip();
    }

    function hasBurnInProtection() as Boolean {
        return _hasBurnInProtection;
    }
}
