import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../" as Theme

// Native Bluetooth control via bluetoothctl. Inline: power toggle, list paired
// devices, connect/disconnect. New pairing → blueman-manager.
ColumnLayout {
    id: root
    spacing: 10

    property bool powered: false
    property var devices: []     // [{ mac, name, connected }]
    property bool busy: false

    Component.onCompleted: refresh()

    function refresh() { busy = true; scanProc.running = true }

    Process {
        id: scanProc
        command: ["bash", "-c",
            "P=$(bluetoothctl show 2>/dev/null | grep -c 'Powered: yes'); echo \"POWERED:$P\"; " +
            "if [ \"$P\" -gt 0 ]; then " +
            "  while read -r _ mac name; do " +
            "    c=$(bluetoothctl info \"$mac\" 2>/dev/null | grep -c 'Connected: yes'); " +
            "    echo \"DEV:$c:$mac:$name\"; " +
            "  done < <(bluetoothctl devices 2>/dev/null); " +
            "fi"]
        stdout: StdioCollector {
            onStreamFinished: {
                const devs = []
                for (const raw of text.split("\n")) {
                    if (raw.startsWith("POWERED:")) { root.powered = raw.substring(8).trim() !== "0"; continue }
                    if (raw.startsWith("DEV:")) {
                        const p = raw.split(":")
                        // DEV:<connected>:<mac>:<name...>  (mac itself contains ':')
                        const connected = p[1] === "1"
                        const mac = p.slice(2, 8).join(":")
                        const name = p.slice(8).join(":")
                        if (mac) devs.push({ mac: mac, name: name || mac, connected: connected })
                    }
                }
                devs.sort((a, b) => (b.connected - a.connected) || a.name.localeCompare(b.name))
                root.devices = devs
                root.busy = false
            }
        }
    }

    Process { id: actionProc; onExited: refreshTimer.restart() }
    Timer { id: refreshTimer; interval: 800; onTriggered: root.refresh() }

    function run(cmd)    { actionProc.command = ["bash", "-c", cmd]; actionProc.running = true }
    function launch(cmd) { Quickshell.execDetached(["bash", "-c", cmd]) }

    function onDeviceClicked(d) {
        run("bluetoothctl " + (d.connected ? "disconnect " : "connect ") + d.mac)
        refreshTimer.interval = 2500; refreshTimer.restart()
    }

    // ── Header ──
    RowLayout {
        Layout.fillWidth: true
        spacing: 8
        Text {
            text: root.powered ? "" : ""
            color: root.powered ? Theme.Yoake.slateBlue : Theme.Yoake.muted
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeLg
        }
        Text {
            text: "Bluetooth"
            color: Theme.Yoake.fg
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
            Layout.fillWidth: true
        }
        PillButton {
            text: root.powered ? "On" : "Off"
            accent: root.powered ? Theme.Yoake.slateBlue : Theme.Yoake.muted
            onTapped: root.run("bluetoothctl power " + (root.powered ? "off" : "on"))
        }
    }

    // ── Device list ──
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 4
        visible: root.powered

        Text {
            visible: root.devices.length === 0
            text: root.busy ? "Loading…" : "No paired devices"
            color: Theme.Yoake.muted
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeSm
            Layout.topMargin: 4
        }

        Repeater {
            model: root.devices
            delegate: Rectangle {
                required property var modelData
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                radius: 6
                color: devMa.containsMouse ? Theme.Yoake.surface
                     : modelData.connected ? Theme.Yoake.alpha(Theme.Yoake.slateBlue, 0.18)
                     : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 8
                    Text {
                        text: modelData.connected ? "" : ""
                        color: modelData.connected ? Theme.Yoake.slateBlue : Theme.Yoake.fgDim
                        font.family: Theme.Fonts.family
                        font.pixelSize: Theme.Fonts.sizeMd
                    }
                    Text {
                        text: modelData.name
                        color: modelData.connected ? Theme.Yoake.slateBlue : Theme.Yoake.fg
                        font.family: Theme.Fonts.family
                        font.pixelSize: Theme.Fonts.sizeSm
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    Text {
                        text: modelData.connected ? "connected" : ""
                        color: Theme.Yoake.muted
                        font.family: Theme.Fonts.family
                        font.pixelSize: Theme.Fonts.sizeSm
                    }
                }
                MouseArea {
                    id: devMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.onDeviceClicked(modelData)
                }
            }
        }
    }

    // ── Footer ──
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 28
        radius: 6
        color: mgrMa.containsMouse ? Theme.Yoake.surface : Theme.Yoake.surfaceAlt
        Text {
            anchors.centerIn: parent
            text: "󰂴  Pair new device"
            color: Theme.Yoake.fgDim
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeSm
        }
        MouseArea {
            id: mgrMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: { root.launch("blueman-manager"); Theme.Controls.close() }
        }
    }
}
