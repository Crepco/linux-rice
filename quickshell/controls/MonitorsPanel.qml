import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../" as Theme

// Display settings: per-monitor orientation (transform) and, with multiple
// monitors plugged in, relative position. Applied at runtime via
// `hyprctl --batch keyword monitor` — edit hyprland.conf to persist.
ColumnLayout {
    id: root
    spacing: 10

    property var monitors: []   // [{ name, width, height, refresh, x, y, scale, transform }]
    property bool busy: false

    Component.onCompleted: refresh()

    function refresh() {
        busy = true
        listProc.running = true
    }

    Process {
        id: listProc
        command: ["hyprctl", "monitors", "all", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                let mons = []
                try {
                    for (const m of JSON.parse(text)) {
                        if (m.disabled) continue
                        mons.push({ name: m.name, width: m.width, height: m.height,
                                    refresh: m.refreshRate, x: m.x, y: m.y,
                                    scale: m.scale, transform: m.transform })
                    }
                } catch (e) {}
                mons.sort((a, b) => (a.x - b.x) || (a.y - b.y))
                root.monitors = mons
                root.busy = false
            }
        }
    }

    Process {
        id: applyProc
        onExited: refreshTimer.restart()
    }
    Timer { id: refreshTimer; interval: 400; onTriggered: root.refresh() }

    // Logical footprint after scale; 90°/270° transforms swap width/height.
    function logicalW(m) { return Math.round((m.transform % 2 ? m.height : m.width) / m.scale) }
    function logicalH(m) { return Math.round((m.transform % 2 ? m.width : m.height) / m.scale) }

    function rule(m, x, y, t) {
        return m.name + "," + m.width + "x" + m.height + "@" + m.refresh.toFixed(2)
             + "," + x + "x" + y + "," + m.scale + ",transform," + t
    }

    // entries: [{ m, x, y, t }] — shift so the layout origin is 0x0, then apply.
    function apply(entries) {
        let minX = Infinity, minY = Infinity
        for (const e of entries) { minX = Math.min(minX, e.x); minY = Math.min(minY, e.y) }
        applyProc.command = ["hyprctl", "--batch",
            entries.map(e => "keyword monitor " + rule(e.m, e.x - minX, e.y - minY, e.t)).join(" ; ")]
        applyProc.running = true
    }

    function setTransform(m, t) {
        apply(root.monitors.map(o =>
            ({ m: o, x: o.x, y: o.y, t: o.name === m.name ? t : o.transform })))
    }

    // Place monitor `m` against the bounding box of all the others.
    function place(m, side) {
        const others = root.monitors.filter(o => o.name !== m.name)
        if (others.length === 0) return
        let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity
        for (const o of others) {
            minX = Math.min(minX, o.x); minY = Math.min(minY, o.y)
            maxX = Math.max(maxX, o.x + logicalW(o)); maxY = Math.max(maxY, o.y + logicalH(o))
        }
        let x = minX, y = minY
        if (side === "left")  x = minX - logicalW(m)
        if (side === "right") x = maxX
        if (side === "above") y = minY - logicalH(m)
        if (side === "below") y = maxY
        const entries = others.map(o => ({ m: o, x: o.x, y: o.y, t: o.transform }))
        entries.push({ m: m, x: x, y: y, t: m.transform })
        apply(entries)
    }

    // ── Header ──
    RowLayout {
        Layout.fillWidth: true
        spacing: 8
        Text {
            text: "󰍹"
            color: Theme.Yoake.peach
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeLg
        }
        Text {
            text: "Displays"
            color: Theme.Yoake.fg
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
            Layout.fillWidth: true
        }
        PillButton {
            text: "󰑐"
            onTapped: root.refresh()
        }
    }

    Text {
        visible: root.monitors.length === 0
        text: root.busy ? "Loading…" : "No monitors found"
        color: Theme.Yoake.muted
        font.family: Theme.Fonts.family
        font.pixelSize: Theme.Fonts.sizeSm
    }

    // ── Per-monitor cards ──
    Repeater {
        model: root.monitors
        delegate: Rectangle {
            required property var modelData
            readonly property var mon: modelData   // unshadowed name for nested delegates
            Layout.fillWidth: true
            implicitHeight: monCol.implicitHeight + 20
            radius: 8
            color: Theme.Yoake.surfaceAlt
            border.color: Theme.Yoake.border
            border.width: 1

            ColumnLayout {
                id: monCol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 10
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Text {
                        text: mon.name
                        color: Theme.Yoake.fg
                        font.family: Theme.Fonts.family
                        font.pixelSize: Theme.Fonts.sizeMd
                        Layout.fillWidth: true
                    }
                    Text {
                        text: mon.width + "x" + mon.height + " @ "
                            + Math.round(mon.refresh) + "Hz  ·  "
                            + mon.x + "," + mon.y
                        color: Theme.Yoake.fgDim
                        font.family: Theme.Fonts.family
                        font.pixelSize: Theme.Fonts.sizeSm
                    }
                }

                // Orientation (transform 0–3)
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    Text {
                        text: "Rotate"
                        color: Theme.Yoake.muted
                        font.family: Theme.Fonts.family
                        font.pixelSize: Theme.Fonts.sizeSm
                        Layout.fillWidth: true
                    }
                    Repeater {
                        model: [{ label: "0°", t: 0 }, { label: "90°", t: 1 },
                                { label: "180°", t: 2 }, { label: "270°", t: 3 }]
                        delegate: PillButton {
                            required property var modelData
                            text: modelData.label
                            active: mon.transform === modelData.t
                            onTapped: root.setTransform(mon, modelData.t)
                        }
                    }
                }

                // Position relative to the other monitors
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    visible: root.monitors.length > 1
                    Text {
                        text: "Place"
                        color: Theme.Yoake.muted
                        font.family: Theme.Fonts.family
                        font.pixelSize: Theme.Fonts.sizeSm
                        Layout.fillWidth: true
                    }
                    Repeater {
                        model: [{ label: "←", side: "left" }, { label: "→", side: "right" },
                                { label: "↑", side: "above" }, { label: "↓", side: "below" }]
                        delegate: PillButton {
                            required property var modelData
                            text: modelData.label
                            accent: Theme.Yoake.slateBlue
                            onTapped: root.place(mon, modelData.side)
                        }
                    }
                }
            }
        }
    }

    Text {
        text: "Runtime only — edit hyprland.conf to persist"
        color: Theme.Yoake.muted
        font.family: Theme.Fonts.family
        font.pixelSize: Theme.Fonts.sizeSm
        Layout.alignment: Qt.AlignHCenter
    }
}
