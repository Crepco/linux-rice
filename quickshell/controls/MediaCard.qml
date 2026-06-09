import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import "../" as Theme

// Now-playing card: album art + track info + audio visualizer + controls.
// Prefers Spotify, falls back to any MPRIS player (browser, mpv, …).
ColumnLayout {
    id: root
    spacing: 10

    readonly property var player: {
        const ps = Mpris.players.values
        return ps.find(p => (p.desktopEntry || p.identity || "").toLowerCase().includes("spotify"))
            ?? ps.find(p => p.canControl)
            ?? ps[0] ?? null
    }
    readonly property bool playing: player?.isPlaying ?? false

    // Real audio levels from the default sink drive the visualizer
    readonly property var sink: Pipewire.defaultAudioSink
    PwObjectTracker { objects: root.sink ? [root.sink] : [] }
    PwNodePeakMonitor {
        id: peakMon
        node: root.sink
        enabled: root.visible
    }

    // ── Track info row ──
    RowLayout {
        spacing: 10
        Layout.fillWidth: true

        ClippingRectangle {
            Layout.preferredWidth: 56
            Layout.preferredHeight: 56
            radius: 8
            color: Theme.Yoake.surfaceAlt

            Image {
                anchors.fill: parent
                source: root.player?.trackArtUrl ?? ""
                fillMode: Image.PreserveAspectCrop
                visible: status === Image.Ready
            }
            Text {
                anchors.centerIn: parent
                text: ""  // music note placeholder
                visible: !root.player || (root.player.trackArtUrl ?? "") === ""
                color: Theme.Yoake.muted
                font.family: Theme.Fonts.family
                font.pixelSize: Theme.Fonts.sizeLg
            }
        }

        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true
            Text {
                text: root.player?.trackTitle || "Nothing playing"
                color: Theme.Yoake.fg
                font.family: Theme.Fonts.family
                font.pixelSize: Theme.Fonts.sizeMd
                font.weight: Font.DemiBold
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
            Text {
                text: root.player?.trackArtist || (root.player ? (root.player.identity ?? "") : "open a player to begin")
                color: Theme.Yoake.muted
                font.family: Theme.Fonts.family
                font.pixelSize: Theme.Fonts.sizeSm
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }
    }

    // ── Visualizer — bars dance with the actual output level ──
    Item {
        id: viz
        Layout.fillWidth: true
        Layout.preferredHeight: 34

        readonly property int barCount: 16
        property var mults: []

        // Per-bar multipliers resample on a quick timer; peak scales them all,
        // so silence falls flat and loud passages jump.
        Timer {
            interval: 110
            running: root.visible && root.playing
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                const m = []
                for (let i = 0; i < viz.barCount; i++) m.push(0.25 + Math.random() * 0.75)
                viz.mults = m
            }
        }

        function mix(a, b, t) {
            return Qt.rgba(a.r + (b.r - a.r) * t, a.g + (b.g - a.g) * t,
                           a.b + (b.b - a.b) * t, 1)
        }

        Row {
            anchors.fill: parent
            spacing: 3

            Repeater {
                model: viz.barCount
                Item {
                    required property int index
                    width: (viz.width - (viz.barCount - 1) * 3) / viz.barCount
                    height: viz.height

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        radius: width / 2
                        // dawn gradient across the bars: peach → slate
                        color: viz.mix(Theme.Yoake.peach, Theme.Yoake.slateBlue,
                                       parent.index / (viz.barCount - 1))
                        height: {
                            const amp = Math.min(1, (peakMon.peak ?? 0) * 1.7)
                            const m = root.playing ? (viz.mults[parent.index] ?? 0.5) : 0
                            return 3 + amp * m * (viz.height - 3)
                        }
                        Behavior on height {
                            NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                        }
                    }
                }
            }
        }
    }

    // ── Transport controls ──
    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 18

        component MediaButton: Text {
            id: btn
            property string glyph: ""
            property bool enabled_: true
            signal tapped()
            text: glyph
            color: !enabled_ ? Theme.Yoake.alpha(Theme.Yoake.muted, 0.4)
                 : bma.containsMouse ? Theme.Yoake.peachHi : Theme.Yoake.peach
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeLg
            MouseArea {
                id: bma
                anchors.fill: parent
                anchors.margins: -6
                hoverEnabled: true
                cursorShape: btn.enabled_ ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: if (btn.enabled_) btn.tapped()
            }
        }

        MediaButton {
            glyph: ""  // prev
            enabled_: root.player?.canGoPrevious ?? false
            onTapped: root.player.previous()
        }
        MediaButton {
            glyph: root.playing ? "" : ""  // pause / play
            enabled_: root.player?.canTogglePlaying ?? false
            font.pixelSize: Theme.Fonts.sizeXl
            onTapped: root.player.togglePlaying()
        }
        MediaButton {
            glyph: ""  // next
            enabled_: root.player?.canGoNext ?? false
            onTapped: root.player.next()
        }
    }
}
