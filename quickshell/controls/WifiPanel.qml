import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../" as Theme

// Native WiFi control via nmcli. Inline: toggle radio, rescan, list, connect to
// known/open networks, disconnect. New secured networks → nm-connection-editor.
ColumnLayout {
    id: root
    spacing: 10

    property bool radioOn: true
    property var networks: []          // [{ ssid, signal, security, active, known }]
    property bool busy: false

    Component.onCompleted: refresh()

    function refresh() {
        busy = true
        scanProc.running = true
    }

    // ── Read radio state + saved connections + visible networks in one shot ──
    Process {
        id: scanProc
        command: ["bash", "-c",
            "echo \"RADIO:$(nmcli radio wifi)\"; " +
            "echo SAVED_START; nmcli -t -f NAME connection show 2>/dev/null; echo SAVED_END; " +
            "echo NETS_START; nmcli -t -f ACTIVE,SSID,SIGNAL,SECURITY dev wifi list 2>/dev/null; echo NETS_END"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.split("\n")
                const saved = {}
                const nets = []
                let section = ""
                for (const raw of lines) {
                    if (raw.startsWith("RADIO:")) { root.radioOn = raw.substring(6) === "enabled"; continue }
                    if (raw === "SAVED_START") { section = "saved"; continue }
                    if (raw === "SAVED_END")   { section = ""; continue }
                    if (raw === "NETS_START")  { section = "nets"; continue }
                    if (raw === "NETS_END")    { section = ""; continue }
                    if (!raw) continue
                    if (section === "saved") { saved[raw] = true; continue }
                    if (section === "nets") {
                        const p = raw.split(":")
                        if (p.length < 4) continue
                        const active = p[0] === "yes"
                        const security = p[p.length - 1]
                        const signal = parseInt(p[p.length - 2]) || 0
                        const ssid = p.slice(1, p.length - 2).join(":")
                        if (!ssid) continue
                        if (nets.some(n => n.ssid === ssid)) continue   // dedupe
                        const secured = security !== "" && security !== "--"
                        nets.push({ ssid: ssid, signal: signal, security: security,
                                    active: active, known: !!saved[ssid], secured: secured })
                    }
                }
                nets.sort((a, b) => (b.active - a.active) || (b.signal - a.signal))
                root.networks = nets
                root.busy = false
            }
        }
    }

    // Fire-and-forget actions, then refresh
    Process {
        id: actionProc
        onExited: refreshTimer.restart()
    }
    Timer {
        id: refreshTimer
        interval: 600
        onTriggered: { root.refresh(); interval = 600 }  // restore after one-off longer waits
    }

    function run(cmd)        { actionProc.command = ["bash", "-c", cmd]; actionProc.running = true }
    function launch(cmd)     { Quickshell.execDetached(["bash", "-c", cmd]) }

    function signalIcon(s) {
        if (s > 75) return "󰤨"
        if (s > 50) return "󰤥"
        if (s > 25) return "󰤢"
        return "󰤟"
    }

    function onNetworkClicked(n) {
        if (n.active) {
            run("nmcli connection down id '" + n.ssid.replace(/'/g, "") + "' 2>/dev/null || " +
                "nmcli device disconnect \"$(nmcli -t -f DEVICE,TYPE device | grep ':wifi' | cut -d: -f1 | head -1)\"")
        } else if (!n.secured || n.known) {
            run("nmcli dev wifi connect '" + n.ssid.replace(/'/g, "") + "'")
        } else {
            launch("nm-connection-editor")   // new secured network → GUI for password
            Theme.Controls.close()
        }
    }

    // ── Header ──
    RowLayout {
        Layout.fillWidth: true
        spacing: 8
        Text {
            text: root.radioOn ? "󰤨" : "󰤭"
            color: root.radioOn ? Theme.Yoake.slateBlue : Theme.Yoake.muted
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeLg
        }
        Text {
            text: "Wi-Fi"
            color: Theme.Yoake.fg
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
            Layout.fillWidth: true
        }
        // Rescan
        PillButton {
            text: "󰑐"
            visible: root.radioOn
            onTapped: { root.run("nmcli dev wifi rescan"); refreshTimer.interval = 2500; refreshTimer.restart() }
        }
        // Radio toggle
        PillButton {
            text: root.radioOn ? "On" : "Off"
            accent: root.radioOn ? Theme.Yoake.slateBlue : Theme.Yoake.muted
            onTapped: root.run("nmcli radio wifi " + (root.radioOn ? "off" : "on"))
        }
    }

    // ── Network list ──
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 4
        visible: root.radioOn

        Text {
            visible: root.networks.length === 0
            text: root.busy ? "Scanning…" : "No networks found"
            color: Theme.Yoake.muted
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeSm
            Layout.topMargin: 4
        }

        Repeater {
            model: root.networks
            delegate: Rectangle {
                required property var modelData
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                radius: 6
                color: rowMa.containsMouse ? Theme.Yoake.surface
                     : modelData.active ? Theme.Yoake.alpha(Theme.Yoake.slateBlue, 0.18)
                     : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 8
                    Text {
                        text: root.signalIcon(modelData.signal)
                        color: modelData.active ? Theme.Yoake.slateBlue : Theme.Yoake.fgDim
                        font.family: Theme.Fonts.family
                        font.pixelSize: Theme.Fonts.sizeMd
                    }
                    Text {
                        text: modelData.ssid
                        color: modelData.active ? Theme.Yoake.slateBlue : Theme.Yoake.fg
                        font.family: Theme.Fonts.family
                        font.pixelSize: Theme.Fonts.sizeSm
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    Text {
                        text: modelData.secured ? "󰌾" : ""
                        color: Theme.Yoake.muted
                        font.family: Theme.Fonts.family
                        font.pixelSize: Theme.Fonts.sizeSm
                    }
                    Text {
                        text: modelData.active ? "" : ""
                        color: Theme.Yoake.slateBlue
                        font.family: Theme.Fonts.family
                        font.pixelSize: Theme.Fonts.sizeSm
                    }
                }
                MouseArea {
                    id: rowMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.onNetworkClicked(modelData)
                }
            }
        }
    }

    // ── Footer ──
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 28
        radius: 6
        color: settingsMa.containsMouse ? Theme.Yoake.surface : Theme.Yoake.surfaceAlt
        Text {
            anchors.centerIn: parent
            text: "  Network settings"
            color: Theme.Yoake.fgDim
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeSm
        }
        MouseArea {
            id: settingsMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: { root.launch("nm-connection-editor"); Theme.Controls.close() }
        }
    }
}
