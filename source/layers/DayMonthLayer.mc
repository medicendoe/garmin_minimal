import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

/**
 * Layer to display the day and month as text.
 */
class DayMonthLayer extends Layer {
    private var _dayView as Text;
    private var _monthView as Text;
    private var _dayString as String?;
    private var _monthString as String?;

    /**
     * Initializes the day and month layer.
     * @param dayView The text view to display the day
     * @param monthView The text view to display the month
     */
    function initialize(dayView as Text, monthView as Text) {
        Layer.initialize();
        _dayView = dayView;
        _monthView = monthView;
        update();
    }

    /**
     * Updates the day and month strings.
     */
    function update() as Void {
        var dateExtend = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

        _dayString = dateExtend.day_of_week as String;
        _monthString = dateExtend.month as String;
    }

    /**
     * Draws the day and month strings on the device context.
     * @param dc The device context
     */
    function draw(dc as Dc) as Void {
        if (!_visible) {
            return;
        }

        // Draw day
        if (_dayView != null) {
            _dayView.setText(_dayString);
            _dayView.setColor(_color);
        }

        // Draw month
        if (_monthView != null) {
            _monthView.setText(_monthString);
            _monthView.setColor(_color);
        }
    }
}
