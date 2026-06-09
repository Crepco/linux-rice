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

    // Bluetooth SIG company identifiers → vendor name (common ones only).
    function vendor(id) {
        switch (id) {
            case 76:  return "Apple"
            case 6:   return "Microsoft"
            case 117: return "Samsung"
            case 224: return "Google"
            case 301: return "Sony"
            case 158: return "Bose"
            case 12:  return "Logitech"
            case 135: return "Garmin"
            case 637: return "Huawei"
            case 911: return "Xiaomi"
            case 89:  return "Nordic"
            case 343: return "JBL/Harman"
            default:  return ""
        }
    }

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
            "    r=$(echo \"$i\" | grep -m1 'RSSI:' | grep -o '(-*[0-9]*)' | tr -d '()'); " +
            "    m=$(echo \"$i\" | grep -m1 'ManufacturerData.Key:' | grep -o '0x[0-9a-fA-F]*' | head -1); " +
            "    echo \"DEV:$c:$p:$r:${m:-0}:$mac:$n\"; " +
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
                        if (p.length < 12) continue
                        const connected = p[1] === "1"
                        const paired = p[2] === "1"
                        const rssi = parseInt(p[3])            // NaN if not advertising
                        const mfg = parseInt(p[4])             // BT company id (0x.. → int)
                        const mac = p.slice(5, 11).join(":")
                        const name = p.slice(11).join(":")
                        if (!mac || seen[mac]) continue
                        // Hide nameless, far-away discovered devices (random BLE addresses /
                        // neighbour noise). Keep them only if close (strong signal).
                        const isNew = !paired && !connected
                        if (isNew && !name && !(rssi >= -70)) continue
                        seen[mac] = true
                        // Devices broadcasting a friendly name use it; privacy beacons don't,
                        // so fall back to the advertised vendor, then a short MAC tag.
                        const v = root.vendor(mfg)
                        const label = name ? name
                                    : (v ? v + " device" : "Unknown device") + "  ·  " + mac.slice(-5)
                        devs.push({ mac: mac, name: label, named: !!name, rssi: rssi,
                                    connected: connected, paired: paired })
                    }
                }
                // connected → paired → discovered, then alpha
                devs.sort((a, b) =>
                    (b.connected - a.connected) || (b.paired - a.paired) ||
                    (b.named - a.named) || a.name.localeCompare(b.name))
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
    Timer {
        id: refreshTimer
        interval: 800
        onTriggered: { root.refresh(); interval = 800 }  // restore after one-off longer waits
    }
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
            text: root.powered ? "\uF293" : "\uF294"
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
            text: root.powered ? "\uF293" : "\uF294"
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
                        text: "\uF293"
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
                    // Status mark: check = connected, dot = paired (matches Wi-Fi panel)
                    Text {
                        text: modelData.connected ? "" : (modelData.paired ? "\u00B7" : "")
                        color: modelData.connected ? Theme.Yoake.slateBlue : Theme.Yoake.muted
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
