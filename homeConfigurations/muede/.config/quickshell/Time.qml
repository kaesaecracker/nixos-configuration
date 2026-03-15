pragma Singleton
import Quickshell
import QtQuick

Singleton {
    property string currentTime: {
        Qt.formatDateTime(clock.date, "ddd, dd. MMM hh:mm:ss");
    }
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
