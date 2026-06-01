import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../" as Theme

// Native Bluetooth control via bluetoothctl. Fully inline: power toggle, scan for
// nearby devices, and pair / connect / disconnect straight from the list.
ColumnLayout {
    id: root
    spacing: 10

    property bool powered: false
    property bool scanning: false
    property var devices: []     // [{ mac, name, connected, paired }]
    property bool busy: false

    Component.onCompleted: refresh()
    Component.onDestruction: stopScan()

    function refresh() { busy = true; listProc.running = true }

    // ── Build the device list (paired + currently-discovered) ──
    Process {
        id: listProc
        command: ["bash", "-c",
            "P=$(bluetoothctl show 2>/dev/null | grep -c 'Powered: yes'); echo \"POWERED:$P\"; " +
            "if [ \"$P\" -gt 0 ]; then " +
            "  bluetoothctl devices 2>/dev/null | while read -r _ mac _; do " +
            "    i=$(bluetoothctl info \"$mac\" 2>/dev/null); " +
            "    c=$(echo \"$i\" | grep -c 'Connected: yes'); " +
            "    p=$(echo \"$i\" | grep -c 'Paired: yes'); " +
            "    n=$(echo \"$i\" | grep -m1 'Name:' | cut -d' ' -f2-); " +
            "    echo \"DEV:$c:$p:$mac:$n\"; " +
            "  done; " +
            "fi"]
        stdout: StdioCollector {
            onStreamFinished: {
                const devs = []
                const seen = {}
                for (const raw of text.split("\n")) {
                    if (raw.startsWith("POWERED:")) { root.powered = raw.substring(8).trim() !== "0"; continue }
                    if (raw.startsWith("DEV:")) {
                        const p = raw.split(":")
                        if (p.length < 10) continue
                        const connected = p[1] === "1"
                        const paired = p[2] === "1"
                        const mac = p.slice(3, 9).join(":")
                        const name = p.slice(9).join(":")
                        if (!mac || seen[mac]) continue
                        // Skip nameless discovered devices (random BLE addresses /
                        // beacons that never advertise a friendly name — just MAC noise).
                        if (!paired && !connected && !name) continue
                        seen[mac] = true
                        devs.push({ mac: mac, name: name || mac, connected: connected, paired: paired })
                    }
                }
                // connected → paired → discovered, then alpha
                devs.sort((a, b) =>
                    (b.connected - a.connected) || (b.paired - a.paired) || a.name.localeCompare(b.name))
                root.devices = devs
                root.busy = false
            }
        }
    }

    // ── Long-running scan; lists discovered devices while open ──
    Process {
        id: scanProc
        command: ["bash", "-c", "bluetoothctl --timeout 30 scan on"]
        onExited: root.scanning = false
    }
    function startScan() {
        if (!powered) return
        scanning = true
        scanProc.running = true
        pollTimer.start()
    }
    function stopScan() {
        scanning = false
        scanProc.running = false
        pollTimer.stop()
    }

    // Poll the list faster while scanning, so newly-found devices appear
    Timer {
        id: pollTimer
        interval: 2000; repeat: true
        onTriggered: root.refresh()
    }

    // Fire-and-forget actions, then refresh
    Process { id: actionProc; onExited: refreshTimer.restart() }
    Timer { id: refreshTimer; interval: 800; onTriggered: root.refresh() }
    function run(cmd) { actionProc.command = ["bash", "-c", cmd]; actionProc.running = true }

    function onDeviceClicked(d) {
        if (d.connected) {
            run("bluetoothctl disconnect " + d.mac)
        } else if (d.paired) {
            run("bluetoothctl connect " + d.mac)
        } else {
            // new device: pair, trust, then connect
            run("bluetoothctl pair " + d.mac + " && bluetoothctl trust " + d.mac +
                " && bluetoothctl connect " + d.mac)
        }
        refreshTimer.interval = 3000; refreshTimer.restart()
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
            text: root.scanning ? "Scanning…" : "󰂰  Scan"
            visible: root.powered
            accent: root.scanning ? Theme.Yoake.peach : Theme.Yoake.fgDim
            onTapped: root.scanning ? root.stopScan() : root.startScan()
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
            text: root.scanning ? "Searching for devices…" : (root.busy ? "Loading…" : "No devices — tap Scan")
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
                        text: modelData.connected ? "" : (modelData.paired ? "" : "󰂰")
                        color: modelData.connected ? Theme.Yoake.slateBlue
                             : modelData.paired ? Theme.Yoake.fgDim : Theme.Yoake.muted
                        font.family: Theme.Fonts.family
                        font.pixelSize: Theme.Fonts.sizeMd
                    }
                    Text {
                        text: modelData.name
                        color: modelData.connected ? Theme.Yoake.slateBlue
                             : modelData.paired ? Theme.Yoake.fg : Theme.Yoake.fgDim
                        font.family: Theme.Fonts.family
                        font.pixelSize: Theme.Fonts.sizeSm
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    Text {
                        text: modelData.connected ? "connected" : (modelData.paired ? "" : "pair")
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
}
