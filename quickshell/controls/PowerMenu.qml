import QtQuick
import QtQuick.Layouts
import Quickshell
import "../" as Theme

// Power menu — horizontal wlogout-style row of big rounded icon tiles,
// shown centered on screen with a dimmed backdrop (see ControlPanels).
RowLayout {
    id: root
    spacing: 12

    function run(cmd) { Quickshell.execDetached(["bash", "-c", cmd]); Theme.Controls.close() }

    readonly property var actions: [
        { icon: "", label: "Shutdown", accent: Theme.Yoake.rose,      cmd: "systemctl poweroff" },
        { icon: "", label: "Reboot",   accent: Theme.Yoake.peach,     cmd: "systemctl reboot" },
        { icon: "", label: "Lock",     accent: Theme.Yoake.slateBlue, cmd: "qs ipc call lock activate" },
        { icon: "", label: "Suspend",  accent: Theme.Yoake.sage,      cmd: "systemctl suspend" },
        { icon: "", label: "Logout",   accent: Theme.Yoake.cream,     cmd: "hyprctl dispatch exit" },
        { icon: "", label: "Cancel",   accent: Theme.Yoake.muted,     cmd: "" }
    ]

    Repeater {
        model: root.actions
        delegate: ColumnLayout {
            id: entry
            required property var modelData
            spacing: 8

            Rectangle {
                id: tile
                Layout.preferredWidth: 84
                Layout.preferredHeight: 84
                radius: 20
                color: tileMa.containsMouse
                    ? Theme.Yoake.alpha(entry.modelData.accent, 0.22)
                    : Theme.Yoake.surfaceAlt
                border.color: tileMa.containsMouse
                    ? entry.modelData.accent
                    : Theme.Yoake.alpha(Theme.Yoake.border, 0.6)
                border.width: 1
                scale: tileMa.containsMouse ? 1.06 : 1.0

                Behavior on scale { NumberAnimation { duration: 130; easing.type: Easing.OutBack } }
                Behavior on color { ColorAnimation { duration: 130 } }

                Text {
                    anchors.centerIn: parent
                    text: entry.modelData.icon
                    color: tileMa.containsMouse ? entry.modelData.accent : Theme.Yoake.cream
                    font.family: Theme.Fonts.family
                    font.pixelSize: 30
                    Behavior on color { ColorAnimation { duration: 130 } }
                }

                MouseArea {
                    id: tileMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: entry.modelData.cmd
                        ? root.run(entry.modelData.cmd)
                        : Theme.Controls.close()
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: entry.modelData.label
                color: tileMa.containsMouse ? entry.modelData.accent : Theme.Yoake.fgDim
                font.family: Theme.Fonts.family
                font.pixelSize: Theme.Fonts.sizeSm
                Behavior on color { ColorAnimation { duration: 130 } }
            }
        }
    }
}
