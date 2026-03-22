import Toybox.Test;
import Toybox.Lang;

(:test)
function testBatteryColorAtThreshold(logger as Test.Logger) as Boolean {
    // At exactly 15% battery, the alert color should be used
    return Test.assertEqualMessage(0xFF0000, batteryColorFor(15.0f, 0xFFFFFF, 0xFF0000), "15% battery should use alert color");
}

(:test)
function testBatteryColorAboveThreshold(logger as Test.Logger) as Boolean {
    // Above 15% battery, the normal color should be used
    return Test.assertEqualMessage(0xFFFFFF, batteryColorFor(16.0f, 0xFFFFFF, 0xFF0000), "16% battery should use normal color");
}

(:test)
function testSecondsZeroPad(logger as Test.Logger) as Boolean {
    // Single-digit seconds must be zero-padded to two characters
    return Test.assertEqualMessage("05", (5).format("%02d"), "single-digit seconds must be zero-padded");
}
