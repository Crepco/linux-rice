import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../" as Theme

Rectangle {
    id: root
    Layout.preferredHeight: 22
    implicitWidth: row.implicitWidth + 16
    radius: 6
    color: Theme.Yoake.bg
    border.color: Theme.Yoake.alpha(Theme.Yoake.peach, 0.18)
    border.width: 1

    property real cpuPercent: 0
    property real lastIdle: 0
    property real lastTotal: 0

    function readStat(textData) {
        const firstLine = textData.split("\n")[0];
        const parts = firstLine.split(/\s+/).slice(1).map(parseFloat);
        const idle = parts[3];
        const total = parts.reduce((a, b) => a + b, 0);
        if (lastTotal > 0) {
            const dIdle = idle - lastIdle;
            const dTotal = total - lastTotal;
            cpuPercent = dTotal > 0 ? Math.max(0, Math.min(100, 100 * (1 - dIdle / dTotal))) : 0;
        }
        lastIdle = idle;
        lastTotal = total;
    }

    FileView {
        id: statFile
        path: "/proc/stat"
        watchChanges: false
        onLoaded: root.readStat(text())
    }

    Timer {
        interval: 2000; running: true; repeat: true
        onTriggered: statFile.reload()
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 6
        Text {
            text: "\uF2DB"  // microchip
            color: Theme.Yoake.fg
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
        }
        Text {
            text: Math.round(root.cpuPercent) + "%"
            color: Theme.Yoake.fg
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeSm
        }
    }
}
