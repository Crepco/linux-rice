pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Shared backlight state. sysfs doesn't emit inotify events, so consumers
// can't watch the brightness file — instead every write path calls reload()
// (panel slider, OSD ipc) and all readers share this one source of truth.
Singleton {
    id: root

    property string device: "amdgpu_bl1"   // fallback; auto-detected below
    property int curr: 0
    property int max: 1
    readonly property int percent: max > 0 ? Math.round(100 * curr / max) : 0

    function reload() { currFile.reload() }

    function setPercent(pct) {
        const p = Math.min(100, Math.max(1, Math.round(pct)))
        setProc.command = ["brightnessctl", "-d", root.device, "set", p + "%", "-q"]
        setProc.running = true
    }

    // First device under /sys/class/backlight wins (laptops have exactly one).
    Process {
        id: detectProc
        command: ["sh", "-c", "ls /sys/class/backlight/ | head -n1"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const d = text.trim()
                if (d) root.device = d
            }
        }
    }

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

    Process { id: setProc; onExited: root.reload() }
}
