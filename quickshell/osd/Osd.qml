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

    // State
    property string osdType: ""        // "volume" or "brightness"
    property real osdValue: 0          // 0..100
    property bool muted: false

    // Backlight reading
    property int blCurr: 0
    property int blMax: 1
    property string blDevice: "amdgpu_bl1"

    FileView { id: blCurrFile; path: "/sys/class/backlight/" + root.blDevice + "/brightness"; watchChanges: false; onLoaded: root.blCurr = parseInt(text()) }
    FileView { id: blMaxFile;  path: "/sys/class/backlight/" + root.blDevice + "/max_brightness"; watchChanges: false; onLoaded: root.blMax = parseInt(text()) }

    Timer { id: hideTimer; interval: 1500; onTriggered: root.osdType = "" }

    function show(type, val, isMuted) {
        osdType = type
        osdValue = val
        muted = isMuted || false
        hideTimer.restart()
    }

    function showVolume() {
        const sink = Pipewire.defaultAudioSink
        if (!sink) return
        const v = (sink.audio?.volume ?? 0) * 100
        const m = sink.audio?.muted ?? false
        show("volume", v, m)
    }

    function showBrightness() {
        blCurrFile.reload()
        const pct = blMax > 0 ? Math.round(100 * blCurr / blMax) : 0
        show("brightness", pct, false)
    }

    IpcHandler {
        target: "osd"
        function volume() { root.showVolume() }
        function brightness() { root.showBrightness() }
    }

    function icon() {
        if (osdType === "brightness") return ""  // sun
        if (muted || osdValue === 0)  return ""
        if (osdValue < 34)            return ""
        if (osdValue < 67)            return ""
        return ""
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
                color: Theme.Yoake.bg
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
                            text: root.muted ? "muted" : Math.round(root.osdValue) + "%"
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
                            width: parent.width * Math.min(1, Math.max(0, root.osdValue / 100))
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
