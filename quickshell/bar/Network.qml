import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "../" as Theme

Item {
    id: root
    Layout.preferredHeight: 22
    implicitWidth: row.implicitWidth + 14

    // States: "wifi" | "ethernet" | "disconnected" | "loading"
    property string netState: "loading"
    property string ssid: ""

    function refresh() {
        proc.running = true
    }

    Process {
        id: proc
        command: ["bash", "-c", "nmcli -t -f TYPE,STATE,CONNECTION device status 2>/dev/null | grep -E '^(wifi|ethernet):connected:' | head -1"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const line = text.trim()
                if (!line) {
                    netState = "disconnected"
                    ssid = ""
                } else {
                    const parts = line.split(":")
                    netState = parts[0]
                    ssid = parts[2] || ""
                }
            }
        }
    }

    Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: root.refresh()
    }

    function icon() {
        if (netState === "wifi")     return "\uF1EB"
        if (netState === "ethernet") return "\uF6FF"
        return "\uF6AC"  // wifi-slash
    }

    function color_() {
        if (netState === "disconnected") return Theme.Yoake.rose
        return Theme.Yoake.slateBlue
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
        onClicked: Hyprland.dispatch("exec ~/.config/quickshell/scripts/wifi-menu.sh")
    }
}
