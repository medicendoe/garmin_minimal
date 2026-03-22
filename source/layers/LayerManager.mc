import Toybox.Application;
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

/**
 * Coordinates all visual layers: triggers updates, propagates the active
 * color (normal or alert based on battery level), and drives drawing.
 */
class LayerManager {
    private var _layers as Dictionary<String, Layer>;
    private var _batteryColor as Number;

    function initialize() {
        _layers = {};
        _batteryColor = Graphics.COLOR_WHITE;
    }

    /**
     * Adds a layer with an identifier.
     * @param id The identifier for the layer
     * @param layer The layer object to add
     */
    function addLayer(id as String, layer as Layer) as Void {
        _layers.put(id, layer);
    }

    /**
     * Gets a layer by its identifier.
     * @param id The identifier of the layer
     * @return The requested layer
     */
    function getLayer(id as String) as Layer {
        return _layers.get(id) as Layer;
    }

    /**
     * Updates all layers.
     */
    function updateLayers() as Void {
        updateBatteryState();
        
        var keys = _layers.keys();
        for (var i = 0; i < keys.size(); i++) {
            var layer = _layers.get(keys[i]) as Layer;
            if (layer != null && layer.isVisible()) {
                layer.setColor(_batteryColor);
                layer.update();
            }
        }
    }

    /**
     * Draws all visible layers.
     * @param dc The device context
     */
    function drawLayers(dc as Dc) as Void {
        var keys = _layers.keys();
        for (var i = 0; i < keys.size(); i++) {
            var layer = _layers.get(keys[i]) as Layer;
            if (layer != null && layer.isVisible()) {
                layer.draw(dc);
            }
        }
    }

    /**
     * Reads battery level and user color preferences to update _batteryColor.
     * Uses the alert color when battery is at or below 15%, normal color otherwise.
     */
    function updateBatteryState() as Void {
        var normalColor = Application.Properties.getValue("NormalColor") as Number;
        var alertColor = Application.Properties.getValue("AlertColor") as Number;
        var batteryPercentage = System.getSystemStats().battery;
        _batteryColor = (batteryPercentage <= 15) ? alertColor : normalColor;
    }

    function getBatteryColor() as Number {
        return _batteryColor;
    }
}
