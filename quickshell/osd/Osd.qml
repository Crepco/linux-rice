// Volume + Brightness OSD popup (top-right slide-in)
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import "../" as Theme

Scope {
    id: root

    property string osdType: ""        // "volume" or "brightness"

    // Volume is read live from Pipewire; the node must be bound for its
    // properties to populate, hence the tracker.
    readonly property var sink: Pipewire.defaultAudioSink
    PwObjectTracker { objects: root.sink ? [root.sink] : [] }

    readonly property bool muted: osdType === "volume" && (sink?.audio?.muted ?? false)
    readonly property real value: osdType === "brightness"
        ? Theme.Brightness.percent
        : (sink?.audio?.volume ?? 0) * 100

    Timer { id: hideTimer; interval: 1500; onTriggered: root.osdType = "" }

    function show(type) {
        if (type === "brightness") Theme.Brightness.reload()
        osdType = type
        hideTimer.restart()
    }

    IpcHandler {
        target: "osd"
        function volume() { root.show("volume") }
        function brightness() { root.show("brightness") }
    }

    function icon() {
        if (osdType === "brightness") return ""  // sun
        if (muted || value === 0)     return ""
        if (value < 34)               return ""
        if (value < 67)               return ""
        return ""
    }

    LazyLoader {
        active: root.osdType !== ""
        PanelWindow {
            screen: Quickshell.screens[0]
            anchors { top: true; right: true }
            margins.top: 60
            margins.right: 16

            implicitWidth: 280
            implicitHeight: 70
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay

            Rectangle {
                anchors.fill: parent
                radius: 10
                color: Theme.Yoake.alpha(Theme.Yoake.bg, 0.92)
                border.color: Theme.Yoake.peach
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 8

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10
                        Text {
                            text: root.icon()
                            color: root.muted ? Theme.Yoake.muted : Theme.Yoake.peach
                            font.family: Theme.Fonts.family
                            font.pixelSize: Theme.Fonts.sizeLg
                        }
                        Text {
                            text: root.muted ? "muted" : Math.round(root.value) + "%"
                            color: Theme.Yoake.fg
                            font.family: Theme.Fonts.family
                            font.pixelSize: Theme.Fonts.sizeMd
                            Layout.fillWidth: true
                        }
                    }

                    // Progress bar
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 4
                        radius: 2
                        color: Theme.Yoake.surface

                        Rectangle {
                            width: parent.width * Math.min(1, Math.max(0, root.value / 100))
                            height: parent.height
                            radius: 2
                            color: root.muted ? Theme.Yoake.muted : Theme.Yoake.peach

                            Behavior on width {
                                NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                            }
                        }
                    }
                }
            }
        }
    }
}
