import Quickshell
import QtQuick.Layouts
import QtQuick

Rectangle {
    default property alias content: container.data

    property color pillAccentColor: Theme.colors.foreground
    property color backgroundColor: Theme.colors.background

    palette {
        text: pillAccentColor
        windowText: pillAccentColor
    }

    color: backgroundColor
    border.color: pillAccentColor

    border.width: 2
    radius: 15

    implicitHeight: container.implicitHeight
    implicitWidth: container.implicitWidth + 16

    RowLayout {
        id: container
        anchors.centerIn: parent
        spacing: 8
    }
}
