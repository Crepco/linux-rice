import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Hyprland
import "../" as Theme

Item {
    id: root
    Layout.preferredHeight: 22
    implicitWidth: row.implicitWidth + 14

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real vol: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    PwObjectTracker { objects: sink ? [sink] : [] }

    function icon() {
        if (muted || vol === 0) return "\uF026"  // volume-off
        if (vol < 0.34) return "\uF026"
        if (vol < 0.67) return "\uF027"  // volume-down
        return "\uF028"  // volume-up
    }

    function color_() {
        if (muted) return Theme.Yoake.alpha(Theme.Yoake.fg, 0.4)
        return Theme.Yoake.teal
    }

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 3
        anchors.bottomMargin: 3
        radius: 4
        color: Theme.Yoake.alpha(Theme.Yoake.teal, 0.5)
        opacity: ma.containsMouse ? 0.18 : 0
        Behavior on opacity { Anim {} }
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 5
        Text {
            text: root.icon()
            color: root.color_()
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
            Behavior on color { ColorAnimation { duration: 250 } }
            scale: root.muted ? 0.85 : 1
            Behavior on scale { Anim {} }
        }
        Text {
            text: Math.round(root.vol * 100) + "%"
            color: root.color_()
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeSm
            Behavior on color { ColorAnimation { duration: 250 } }
        }
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                if (root.sink) root.sink.audio.muted = !root.sink.audio.muted
            } else {
                Hyprland.dispatch("exec ~/.config/quickshell/scripts/volume-menu.sh")
            }
        }
    }
}
