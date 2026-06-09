// A single notification popup card
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import "../" as Theme

Rectangle {
    id: root
    required property var notif

    Layout.preferredWidth: 360
    implicitHeight: content.implicitHeight + 24
    radius: 8
    color: Theme.Yoake.alpha(Theme.Yoake.surface, 0.92)
    border.color: critical ? Theme.Yoake.rose : Theme.Yoake.peach
    border.width: 1.5

    readonly property bool critical: notif?.urgency === NotificationUrgency.Critical

    // Fade-in animation (simpler than slide, less likely to break)
    opacity: 0
    Component.onCompleted: fadeIn.start()
    NumberAnimation { id: fadeIn; target: root; property: "opacity"; from: 0; to: 1; duration: 180 }

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

        // Header row: app icon + name + dismiss
        RowLayout {
            spacing: 6
            Layout.fillWidth: true

            Image {
                visible: source != ""
                // appIcon is a freedesktop icon *name*, not a path
                source: root.notif?.appIcon ? Quickshell.iconPath(root.notif.appIcon, true) : ""
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

        // Body row: optional notification image beside summary/body
        RowLayout {
            spacing: 10
            Layout.fillWidth: true

            Image {
                visible: source != ""
                source: root.notif?.image ?? ""
                sourceSize.width: 40
                sourceSize.height: 40
                Layout.preferredWidth: visible ? 40 : 0
                Layout.preferredHeight: visible ? 40 : 0
                Layout.alignment: Qt.AlignTop
                fillMode: Image.PreserveAspectCrop
            }

            ColumnLayout {
                spacing: 6
                Layout.fillWidth: true

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

                // Body — server advertises markup support, so render the
                // spec's <b>/<i>/<u>/<a> subset instead of showing raw tags
                Text {
                    visible: text !== ""
                    text: (root.notif?.body ?? "").replace(/\n/g, "<br/>")
                    color: Theme.Yoake.fgDim
                    font.family: Theme.Fonts.family
                    font.pixelSize: Theme.Fonts.sizeSm
                    wrapMode: Text.WordWrap
                    textFormat: Text.StyledText
                    linkColor: Theme.Yoake.slateBlue
                    onLinkActivated: link => Qt.openUrlExternally(link)
                    Layout.fillWidth: true
                    maximumLineCount: 4
                    elide: Text.ElideRight
                }
            }
        }

        // Action buttons ("Reply", "Open", media controls, …)
        RowLayout {
            visible: (root.notif?.actions?.length ?? 0) > 0
            spacing: 6
            Layout.fillWidth: true

            Repeater {
                model: root.notif?.actions ?? []
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.preferredHeight: 26
                    radius: 6
                    color: actMa.containsMouse
                        ? Theme.Yoake.alpha(Theme.Yoake.peach, 0.25)
                        : Theme.Yoake.alpha(Theme.Yoake.bg, 0.55)

                    Text {
                        anchors.centerIn: parent
                        text: modelData.text || "Open"
                        color: Theme.Yoake.peach
                        font.family: Theme.Fonts.family
                        font.pixelSize: Theme.Fonts.sizeSm
                        elide: Text.ElideRight
                        width: Math.min(implicitWidth, parent.width - 12)
                    }
                    MouseArea {
                        id: actMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: modelData.invoke()
                    }
                }
            }
        }
    }

    // Click anywhere on the card to dismiss
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: if (root.notif) root.notif.dismiss()
        z: -1
    }
}
