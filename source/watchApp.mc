import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class watchApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    /**
     * Called on application startup.
     * @param state The state dictionary
     */
    function onStart(state as Dictionary?) as Void {
    }

    /**
     * Called when the application is exiting.
     * @param state The state dictionary
     */
    function onStop(state as Dictionary?) as Void {
    }

    /**
     * Returns the initial view of the application.
     * @return The array containing the initial view
     */
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new watchView() ];
    }

    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }

}

function getApp() as watchApp {
    return Application.getApp() as watchApp;
}