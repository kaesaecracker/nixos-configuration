import QtQuick
import QtQuick.Controls
import Quickshell

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }

    //implicitHeight: 24
    color: "transparent"

    Item {
        anchors {
            leftMargin: 8
            rightMargin: 8
            fill: parent
        }

        // left
        Pill {
            anchors.left: parent.left

            Label {
                text: "TODO: Niri Workspaces"
            }
            Label {
                text: "TODO: System Tray"
            }
            Label {
                text: "TODO: Niri Active Window"
            }
        }

        // center
        Pill {
            anchors.horizontalCenter: parent.horizontalCenter
            pillAccentColor: Theme.colors.accent0

            Clock {
                time: Time.currentTime
            }

            Label {
                text: "swaync"
            }

            Label {
                text: "Privacy"
            }
        }

        // right
        Pill {
            anchors.right: parent.right

            Label {
                text: "TODO: MPRIS"
            }
            Label {
                text: "TODO: Vol/BT/Net"
            }
            Label {
                text: "TODO: Hardware/Bat"
            }

            RoundButton {
                text: ""
                   // textColor: "red"

                    onClicked: console.log("TODO: Execute wlogout")
            }
        }
    }
}
