import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "../" as Theme

Item {
    id: root
    Layout.preferredHeight: 22
    implicitWidth: row.implicitWidth + 14

    readonly property string device: "amdgpu_bl1"
    property int curr: 0
    property int max: 1

    function pct() { return max > 0 ? Math.round(100 * curr / max) : 0 }

    FileView {
        path: "/sys/class/backlight/" + root.device + "/brightness"
        watchChanges: true
        onLoaded: root.curr = parseInt(text())
    }
    FileView {
        path: "/sys/class/backlight/" + root.device + "/max_brightness"
        watchChanges: false
        onLoaded: root.max = parseInt(text())
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 5
        Text {
            text: "\uF185"  // sun
            color: Theme.Yoake.cream
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
        }
        Text {
            text: root.pct() + "%"
            color: Theme.Yoake.cream
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeSm
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Hyprland.dispatch("exec ~/.config/quickshell/scripts/brightness-menu.sh")
    }
}
