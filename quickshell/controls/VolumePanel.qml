import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import "../" as Theme

// Native volume control: slider + mute toggle, driven directly by Pipewire.
ColumnLayout {
    id: root
    spacing: 12

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real vol: (sink?.audio?.volume ?? 0) * 100
    readonly property bool muted: sink?.audio?.muted ?? false

    PwObjectTracker { objects: root.sink ? [root.sink] : [] }

    function icon() {
        if (muted || vol === 0) return ""
        if (vol < 50)           return ""
        return ""
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 10

        Text {
            text: root.icon()
            color: root.muted ? Theme.Yoake.muted : Theme.Yoake.teal
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeLg
        }
        Text {
            text: "Volume"
            color: Theme.Yoake.fg
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
            Layout.fillWidth: true
        }
        Text {
            text: root.muted ? "muted" : Math.round(root.vol) + "%"
            color: root.muted ? Theme.Yoake.muted : Theme.Yoake.teal
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
        }
    }

    ValueSlider {
        Layout.fillWidth: true
        accent: Theme.Yoake.teal
        value: root.vol
        onMoved: v => { if (root.sink) root.sink.audio.volume = v / 100 }
    }

    // Mute toggle
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 30
        radius: 6
        color: muteMa.containsMouse ? Theme.Yoake.surface : Theme.Yoake.surfaceAlt
        Text {
            anchors.centerIn: parent
            text: root.muted ? "  Unmute" : "  Mute"
            color: root.muted ? Theme.Yoake.teal : Theme.Yoake.fgDim
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeSm
        }
        MouseArea {
            id: muteMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: { if (root.sink) root.sink.audio.muted = !root.sink.audio.muted }
        }
    }
}
