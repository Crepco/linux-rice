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

    property string uptimeText: "..."

    function parse(secStr) {
        const s = parseFloat(secStr);
        if (isNaN(s)) return "...";
        const days = Math.floor(s / 86400);
        const hours = Math.floor((s % 86400) / 3600);
        const mins = Math.floor((s % 3600) / 60);
        if (days > 0)  return days + "d " + hours + "h";
        if (hours > 0) return hours + "h " + mins + "m";
        return mins + "m";
    }

    FileView {
        id: uptimeFile
        path: "/proc/uptime"
        watchChanges: false
        onLoaded: {
            const parts = text().split(" ");
            root.uptimeText = root.parse(parts[0]);
        }
    }

    Timer {
        interval: 60000; running: true; repeat: true
        onTriggered: uptimeFile.reload()
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 6
        Text {
            text: ""  // hourglass-half
            color: Theme.Yoake.cream
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
        }
        Text {
            text: root.uptimeText
            color: Theme.Yoake.cream
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeSm
        }
    }
}
