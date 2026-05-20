import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../" as Theme

Rectangle {
    Layout.preferredHeight: 22
    implicitWidth: row.implicitWidth + 8
    radius: 6
    color: Theme.Yoake.bg
    border.color: Theme.Yoake.alpha(Theme.Yoake.peach, 0.18)
    border.width: 1

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 2

        Repeater {
            model: 10  // workspaces 1..10

            Rectangle {
                required property int index
                readonly property int wsId: index + 1
                readonly property bool active: Hyprland.focusedWorkspace?.id === wsId

                Layout.preferredHeight: 18
                Layout.preferredWidth: 22
                radius: 4
                color: active
                    ? Theme.Yoake.alpha(Theme.Yoake.peach, 0.14)
                    : "transparent"
                border.color: active
                    ? Theme.Yoake.alpha(Theme.Yoake.peach, 0.40)
                    : "transparent"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: parent.wsId
                    color: parent.active
                        ? Theme.Yoake.peach
                        : Theme.Yoake.alpha(Theme.Yoake.fg, 0.4)
                    font.family: Theme.Fonts.family
                    font.pixelSize: Theme.Fonts.sizeSm
                    font.weight: parent.active ? Font.DemiBold : Font.Normal
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: Hyprland.dispatch("workspace " + parent.wsId)
                    onEntered: if (!parent.active) parent.color = Theme.Yoake.surface
                    onExited:  if (!parent.active) parent.color = "transparent"
                }
            }
        }
    }
}
