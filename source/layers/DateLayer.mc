import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class DateLayer {
    private var _dateView as Text;
    private var _dateString;
    private var _color as Number;

    function initialize(view as Text) {
        _dateView = view;
        _color = Graphics.COLOR_WHITE;
        update();
    }

    function setColor(color as Number) as Void {
        _color = color;
    }

    function update() as Void {
        var date = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var year = date.year % 100;
        _dateString = Lang.format("$1$/$2$/$3$", [
            date.day.format("%02d"),
            date.month.format("%02d"),
            year.format("%02d")
        ]);
    }

    function draw(dc as Dc) as Void {
        _dateView.setText(_dateString);
        _dateView.setColor(_color);
    }
}
