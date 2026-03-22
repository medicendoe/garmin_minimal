import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class DayMonthLayer {
    private var _dayView as Text;
    private var _monthView as Text;
    private var _dayString;
    private var _monthString;
    private var _color as Number;

    function initialize(dayView as Text, monthView as Text) {
        _dayView = dayView;
        _monthView = monthView;
        _color = Graphics.COLOR_WHITE;
        var info = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        _dayString = info.day_of_week as String;
        _monthString = info.month as String;
    }

    function setColor(color as Number) as Void {
        _color = color;
    }

    function update(dayOfWeek, month) as Void {
        _dayString = dayOfWeek;
        _monthString = month;
    }

    function draw(dc as Dc) as Void {
        _dayView.setText(_dayString);
        _dayView.setColor(_color);
        _monthView.setText(_monthString);
        _monthView.setColor(_color);
    }
}
