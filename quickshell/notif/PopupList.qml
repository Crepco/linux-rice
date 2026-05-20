// Stacked notification popups, anchored top-right
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import "../" as Theme

Scope {
    id: root

    NotificationServer {
        id: server
        keepOnReload: false
        bodySupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        imageSupported: true
        actionsSupported: true
        persistenceSupported: true
        onNotification: (notif) => { notif.tracked = true }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors { top: true; right: true }
            margins.top: 40
            margins.right: 12

            // Fixed-size, transparent area where popups stack
            implicitWidth: 380
            implicitHeight: 600
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            mask: Region {}  // pass clicks through outside popup area

            ColumnLayout {
                id: stack
                anchors.top: parent.top
                anchors.right: parent.right
                spacing: 8
                width: 360

                Repeater {
                    model: server.trackedNotifications.values

                    delegate: Popup {
                        required property var modelData
                        notif: modelData
                    }
                }
            }
        }
    }
}
