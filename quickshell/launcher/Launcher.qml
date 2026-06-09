// Fullscreen launcher overlay using Quickshell's built-in DesktopEntries singleton
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "../" as Theme

Scope {
    id: root

    property bool visible_: false
    property var filtered: []
    property int activeIndex: 0

    function buildFiltered(query) {
        const q = (query || "").toLowerCase().trim()
        const all = DesktopEntries.applications.values
        const out = []
        for (const e of all) {
            if (!e || e.noDisplay) continue
            const name = (e.name || "").toLowerCase()
            const comment = (e.comment || "").toLowerCase()
            if (!q || name.includes(q) || comment.includes(q)) out.push(e)
        }
        // Prefix matches first, then alphabetical
        out.sort((a, b) => {
            const an = (a.name || "").toLowerCase()
            const bn = (b.name || "").toLowerCase()
            if (q) {
                const ap = an.startsWith(q) ? 0 : 1
                const bp = bn.startsWith(q) ? 0 : 1
                if (ap !== bp) return ap - bp
            }
            return an.localeCompare(bn)
        })
        return out
    }

    function toggle() { visible_ ? hide() : show() }
    function show()   { filtered = buildFiltered(""); activeIndex = 0; visible_ = true }
    function hide()   { visible_ = false }

    function launchAt(idx) {
        if (idx < 0 || idx >= filtered.length) { hide(); return }
        const entry = filtered[idx]
        if (!entry) { hide(); return }
        entry.execute()  // built-in launch method on DesktopEntry
        hide()
    }

    IpcHandler {
        target: "launcher"
        function toggle() { root.toggle() }
        function show()   { root.show() }
        function hide()   { root.hide() }
    }

    LazyLoader {
        active: root.visible_
        PanelWindow {
            screen: Quickshell.screens[0]
            anchors { top: true; left: true; right: true; bottom: true }
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            // Dim background — Item wrapper so Keys attaches properly
            Item {
                anchors.fill: parent
                focus: true
                Keys.onEscapePressed: root.hide()

                Rectangle {
                    anchors.fill: parent
                    color: Qt.rgba(0, 0, 0, 0.45)
                    MouseArea { anchors.fill: parent; onClicked: root.hide() }
                }
            }

            // Centered card
            Rectangle {
                anchors.centerIn: parent
                width: 600
                height: Math.min(parent.height - 80, 520)
                radius: 14
                color: Theme.Yoake.alpha(Theme.Yoake.bg, 0.92)
                border.color: Theme.Yoake.peach
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 14

                    // Search box
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 44
                        radius: 8
                        color: Theme.Yoake.surface
                        border.color: queryInput.activeFocus ? Theme.Yoake.peach : Theme.Yoake.border
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 14
                            spacing: 10

                            Text {
                                text: "\uF002"  // FA search
                                color: Theme.Yoake.peach
                                font.family: Theme.Fonts.family
                                font.pixelSize: Theme.Fonts.sizeMd
                            }

                            TextInput {
                                id: queryInput
                                Layout.fillWidth: true
                                color: Theme.Yoake.fg
                                font.family: Theme.Fonts.family
                                font.pixelSize: Theme.Fonts.sizeMd
                                focus: true
                                selectByMouse: true
                                clip: true

                                Component.onCompleted: Qt.callLater(forceActiveFocus)

                                onTextChanged: {
                                    root.filtered = root.buildFiltered(text)
                                    root.activeIndex = 0
                                }
                                Keys.onPressed: (event) => {
                                    if (event.key === Qt.Key_Escape) {
                                        root.hide()
                                        event.accepted = true
                                    } else if (event.key === Qt.Key_Down) {
                                        root.activeIndex = Math.min(root.activeIndex + 1, root.filtered.length - 1)
                                        event.accepted = true
                                    } else if (event.key === Qt.Key_Up) {
                                        root.activeIndex = Math.max(root.activeIndex - 1, 0)
                                        event.accepted = true
                                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                        root.launchAt(root.activeIndex)
                                        event.accepted = true
                                    }
                                }

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Search applications…"
                                    color: Theme.Yoake.muted
                                    font: parent.font
                                    visible: parent.text === ""
                                }
                            }
                        }
                    }

                    // App list
                    ListView {
                        id: list
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        model: root.filtered.length
                        currentIndex: root.activeIndex
                        onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Contain)
                        spacing: 4
                        boundsBehavior: Flickable.StopAtBounds

                        delegate: Rectangle {
                            required property int index
                            readonly property var entry: root.filtered[index]
                            width: ListView.view.width
                            height: 48
                            radius: 8
                            color: index === root.activeIndex
                                ? Theme.Yoake.alpha(Theme.Yoake.peach, 0.18)
                                : "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                spacing: 12

                                Image {
                                    Layout.preferredWidth: 32
                                    Layout.preferredHeight: 32
                                    source: {
                                        const e = parent.parent.entry
                                        if (!e || !e.icon) return ""
                                        return Quickshell.iconPath(e.icon, "application-x-executable")
                                    }
                                    sourceSize.width: 32
                                    sourceSize.height: 32
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                }
                                Text {
                                    text: parent.parent.entry?.name ?? ""
                                    color: Theme.Yoake.fg
                                    font.family: Theme.Fonts.family
                                    font.pixelSize: Theme.Fonts.sizeMd
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onEntered: root.activeIndex = index
                                onClicked: root.launchAt(index)
                            }
                        }
                    }
                }
            }
        }
    }
}
