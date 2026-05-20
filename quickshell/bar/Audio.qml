import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
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

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 5
        Text {
            text: root.icon()
            color: root.color_()
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
        }
        Text {
            text: Math.round(root.vol * 100) + "%"
            color: root.color_()
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeSm
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: if (root.sink) root.sink.audio.muted = !root.sink.audio.muted
    }
}
