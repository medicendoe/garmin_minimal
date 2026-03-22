import Toybox.Graphics;
import Toybox.Lang;

/**
 * Abstract base class for all visual layers.
 */
class Layer {
    protected var _visible as Boolean;
    protected var _color as Number;

    function initialize() {
        _visible = true;
        _color = Graphics.COLOR_WHITE;
    }

    /**
     * Draws the layer onto the device context.
     * @param dc The device context
     */
    function draw(dc as Dc) as Void {}

    /**
     * Refreshes the layer's internal data from system state.
     */
    function update() as Void {}

    /**
     * Shows or hides the layer.
     * @param visible True to show, false to hide
     */
    function setVisible(visible as Boolean) as Void {
        _visible = visible;
    }

    /**
     * Sets the foreground color used when drawing.
     * @param color The color value (e.g. Graphics.COLOR_WHITE)
     */
    function setColor(color as Number) as Void {
        _color = color;
    }

    function isVisible() as Boolean {
        return _visible;
    }

    function getColor() as Number {
        return _color;
    }
}
