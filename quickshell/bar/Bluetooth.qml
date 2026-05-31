import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../" as Theme

Item {
    id: root
    Layout.preferredHeight: 22
    implicitWidth: row.implicitWidth + 14

    // States: "on" | "off" | "connected"
    property string btState: "off"
    property int connectedCount: 0

    function refresh() { proc.running = true }

    Process {
        id: proc
        command: ["bash", "-c",
                  "P=$(bluetoothctl show 2>/dev/null | grep -c 'Powered: yes'); " +
                  "C=$(bluetoothctl devices Connected 2>/dev/null | wc -l); " +
                  "echo \"$P $C\""]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = text.trim().split(/\s+/)
                const powered = parts[0] === "1"
                connectedCount = parseInt(parts[1]) || 0
                if (!powered) btState = "off"
                else if (connectedCount > 0) btState = "connected"
                else btState = "on"
            }
        }
    }

    Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: root.refresh()
    }

    function icon() {
        if (btState === "off") return ""  // bluetooth-slash
        return ""  // bluetooth-b
    }

    function color_() {
        if (btState === "off") return Theme.Yoake.alpha(Theme.Yoake.fg, 0.4)
        if (btState === "connected") return Theme.Yoake.slateBlue
        return Theme.Yoake.cream
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
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Theme.Controls.toggle("bluetooth")
    }
}
