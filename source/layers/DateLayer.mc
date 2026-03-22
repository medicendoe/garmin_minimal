import Toybox.Graphics;
import Toybox.Time;
import Toybox.WatchUi;
import Toybox.Lang;

/**
 * Layer to display the date.
 */
class DateLayer extends Layer {
    private var _dateView as Text;
    private var _dateString as String;

    /**
     * Initializes the date layer.
     * @param view The text view to display the date
     */
    function initialize(view as Text) {
        Layer.initialize();
        _dateView = view;
        update();
    }

    /**
     * Updates the date string.
     */
    function update() as Void {
        var date = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var year = date.year % 100;
        
        _dateString = Lang.format("$1$/$2$/$3$", [
            date.day.format("%02d"),
            date.month.format("%02d"),
            year.format("%02d")
        ]);
    }

    /**
     * Draws the date string on the device context.
     * @param dc The device context
     */
    function draw(dc as Dc) as Void {
        if (!_visible || _dateView == null) {
            return;
        }

        _dateView.setText(_dateString);
        _dateView.setColor(_color);
    }
}
