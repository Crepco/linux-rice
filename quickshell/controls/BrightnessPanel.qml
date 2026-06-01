import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../" as Theme

// Native brightness control: reads sysfs, writes via brightnessctl.
ColumnLayout {
    id: root
    spacing: 12

    readonly property string device: "amdgpu_bl1"
    property int curr: 0
    property int max: 1
    function pct() { return max > 0 ? Math.round(100 * curr / max) : 0 }

    FileView {
        id: currFile
        path: "/sys/class/backlight/" + root.device + "/brightness"
        watchChanges: true
        onLoaded: root.curr = parseInt(text())
    }
    FileView {
        path: "/sys/class/backlight/" + root.device + "/max_brightness"
        watchChanges: false
        onLoaded: root.max = parseInt(text())
    }

    Process { id: setProc; onExited: currFile.reload() }

    RowLayout {
        Layout.fillWidth: true
        spacing: 10
        Text {
            text: ""  // sun
            color: Theme.Yoake.cream
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeLg
        }
        Text {
            text: "Brightness"
            color: Theme.Yoake.fg
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
            Layout.fillWidth: true
        }
        Text {
            text: root.pct() + "%"
            color: Theme.Yoake.cream
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
        }
    }

    ValueSlider {
        Layout.fillWidth: true
        from: 1
        accent: Theme.Yoake.cream
        value: root.pct()
        onMoved: v => {
            setProc.command = ["brightnessctl", "set", Math.round(v) + "%", "-q"]
            setProc.running = true
        }
    }
}
