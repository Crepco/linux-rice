import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "../" as Theme

Rectangle {
    id: root
    Layout.preferredHeight: 22
    implicitWidth: row.implicitWidth + 8
    color: "transparent"

    property real memPercent: 0

    function readMeminfo(textData) {
        const total = parseFloat(textData.match(/MemTotal:\s+(\d+)/)?.[1] ?? "0");
        const avail = parseFloat(textData.match(/MemAvailable:\s+(\d+)/)?.[1] ?? "0");
        if (total > 0) memPercent = Math.max(0, Math.min(100, 100 * (1 - avail / total)));
    }

    FileView {
        id: meminfoFile
        path: "/proc/meminfo"
        watchChanges: false
        onLoaded: root.readMeminfo(text())
    }

    Timer {
        interval: 2000; running: true; repeat: true
        onTriggered: meminfoFile.reload()
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 6
        Text {
            text: ""  // memory
            color: Theme.Yoake.sage
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
        }
        Text {
            text: Math.round(root.memPercent) + "%"
            color: Theme.Yoake.sage
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeSm
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Hyprland.dispatch("exec kitty -e btop")
    }
}
