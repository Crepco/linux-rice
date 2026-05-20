// Stacked notification popups, anchored top-right of each screen
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import "../" as Theme

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                right: true
            }
            margins.top: 40   // leave room for the bar
            margins.right: 12

            implicitWidth: 380
            implicitHeight: stack.implicitHeight + 20
            color: "transparent"

            exclusionMode: ExclusionMode.Ignore  // float over windows

            ColumnLayout {
                id: stack
                anchors.top: parent.top
                anchors.right: parent.right
                spacing: 8
                width: 360

                Repeater {
                    model: server.trackedNotifications
                    delegate: Popup {
                        required property Notification modelData
                        notif: modelData
                    }
                }
            }
        }
    }

    NotificationServer { id: server }
}
