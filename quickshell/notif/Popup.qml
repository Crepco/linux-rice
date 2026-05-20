// A single notification popup card
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import "../" as Theme

Rectangle {
    id: root
    required property Notification notif

    Layout.preferredWidth: 360
    implicitHeight: content.implicitHeight + 24
    radius: 8
    color: Theme.Yoake.surface
    border.color: critical ? Theme.Yoake.rose : Theme.Yoake.peach
    border.width: 1.5

    readonly property bool critical: notif?.urgency === NotificationUrgency.Critical

    // Slide-in animation
    transform: Translate { id: t; x: 380 }
    Component.onCompleted: slideIn.start()
    NumberAnimation { id: slideIn; target: t; property: "x"; from: 380; to: 0; duration: 220; easing.type: Easing.OutCubic }

    // Auto-dismiss after timeout
    Timer {
        interval: root.critical ? 0 : 6000  // critical stays
        running: !root.critical
        repeat: false
        onTriggered: if (root.notif) root.notif.dismiss()
    }

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 12
        spacing: 6

        // Header row: app name + dismiss
        RowLayout {
            spacing: 6
            Layout.fillWidth: true

            Image {
                visible: source != ""
                source: root.notif?.appIcon ?? ""
                sourceSize.width: 16
                sourceSize.height: 16
                Layout.preferredWidth: 16
                Layout.preferredHeight: 16
                fillMode: Image.PreserveAspectFit
            }
            Text {
                text: root.notif?.appName ?? ""
                color: Theme.Yoake.muted
                font.family: Theme.Fonts.family
                font.pixelSize: Theme.Fonts.sizeSm
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
            // Dismiss button
            Text {
                text: "✕"
                color: Theme.Yoake.muted
                font.family: Theme.Fonts.family
                font.pixelSize: Theme.Fonts.sizeMd
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: if (root.notif) root.notif.dismiss()
                    onEntered: parent.color = Theme.Yoake.peach
                    onExited: parent.color = Theme.Yoake.muted
                    hoverEnabled: true
                }
            }
        }

        // Summary
        Text {
            text: root.notif?.summary ?? ""
            color: Theme.Yoake.fg
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
            font.weight: Font.DemiBold
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        // Body
        Text {
            visible: text !== ""
            text: root.notif?.body ?? ""
            color: Theme.Yoake.fgDim
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeSm
            wrapMode: Text.WordWrap
            textFormat: Text.PlainText
            Layout.fillWidth: true
            maximumLineCount: 4
            elide: Text.ElideRight
        }
    }

    // Click anywhere on the card to invoke default action / dismiss
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: if (root.notif) root.notif.dismiss()
        z: -1
    }
}
