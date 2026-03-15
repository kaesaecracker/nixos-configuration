import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData
            screen: modelData
        }
    }
}
