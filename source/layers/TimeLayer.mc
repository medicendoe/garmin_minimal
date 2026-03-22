import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;

/**
 * Layer to display the main time (hours and minutes).
 */
class TimeLayer extends Layer {
    private var _timeView;
    private var _timeString;

    /**
     * Initializes the time layer.
     * @param view The text view to display the time
     */
    function initialize(view as Text) {
        Layer.initialize();
        _timeView = view;
        update();
    }

    /**
     * Updates the time string.
     */
    function update() as Void {
        var clockTime = System.getClockTime();
        _timeString = Lang.format("$1$$2$", [
            clockTime.hour.format("%02d"),
            clockTime.min.format("%02d")
        ]);
    }

    /**
     * Draws the time string on the device context.
     * @param dc The device context
     */
    function draw(dc as Dc) as Void {
        if (!_visible || _timeView == null) {
            return;
        }

        _timeView.setText(_timeString);
        _timeView.setColor(_color);
    }

    /**
     * Partial update: clips to the time region and redraws only HH:MM.
     * @param dc The device context
     */
    function drawPartial(dc as Dc) as Void {
        if (_timeView == null) {
            return;
        }
        var locX = _timeView.locX;
        var locY = _timeView.locY;
        var width = _timeView.width;
        var height = _timeView.height;
        dc.setClip(locX, locY, width, height);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(_color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(locX, locY, Graphics.FONT_NUMBER_THAI_HOT, _timeString, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.clearClip();
    }
}
