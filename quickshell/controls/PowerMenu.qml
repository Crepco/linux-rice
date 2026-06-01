import QtQuick
import QtQuick.Layouts
import Quickshell
import "../" as Theme

// Power dropdown opened from the power button.
ColumnLayout {
    id: root
    spacing: 4

    function run(cmd) { Quickshell.execDetached(["bash", "-c", cmd]); Theme.Controls.close() }

    readonly property var actions: [
        { icon: "",  label: "Lock",     accent: Theme.Yoake.slateBlue, cmd: "qs ipc call lock activate" },
        { icon: "",  label: "Logout",   accent: Theme.Yoake.cream,     cmd: "hyprctl dispatch exit" },
        { icon: "",  label: "Suspend",  accent: Theme.Yoake.sage,      cmd: "systemctl suspend" },
        { icon: "",  label: "Reboot",   accent: Theme.Yoake.peach,     cmd: "systemctl reboot" },
        { icon: "",  label: "Shutdown", accent: Theme.Yoake.rose,      cmd: "systemctl poweroff" }
    ]

    Repeater {
        model: root.actions
        delegate: Rectangle {
            required property var modelData
            Layout.fillWidth: true
            Layout.preferredHeight: 34
            radius: 6
            color: ma.containsMouse ? Theme.Yoake.alpha(modelData.accent, 0.20) : "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 12
                Text {
                    text: modelData.icon
                    color: modelData.accent
                    font.family: Theme.Fonts.family
                    font.pixelSize: Theme.Fonts.sizeMd
                }
                Text {
                    text: modelData.label
                    color: Theme.Yoake.fg
                    font.family: Theme.Fonts.family
                    font.pixelSize: Theme.Fonts.sizeSm
                    Layout.fillWidth: true
                }
            }
            MouseArea {
                id: ma
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.run(modelData.cmd)
            }
        }
    }
}
