import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../" as Theme

// Dot/pill workspace indicator: the active workspace is an elongated pill that
// stretches; occupied workspaces are dots; empty ones are dim dots.
Item {
    id: root

    Layout.preferredHeight: 22
    implicitWidth: dots.implicitWidth
    implicitHeight: 10

    readonly property int activeWs: Hyprland.focusedWorkspace?.id ?? 1

    function occupied(id) {
        const ws = Hyprland.workspaces.values.find(w => w.id === id)
        return ws ? (ws.lastIpcObject?.windows ?? 0) > 0 : false
    }

    // How many to show: at least 5, growing to cover the highest occupied/active.
    function shownCount() {
        let n = Math.max(5, root.activeWs)
        for (const w of Hyprland.workspaces.values)
            if (w.id > n && w.id <= 10) n = w.id
        return n
    }

    RowLayout {
        id: dots
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            model: root.shownCount()

            Rectangle {
                id: dot
                required property int index
                readonly property int wsId: index + 1
                readonly property bool active: root.activeWs === wsId
                readonly property bool isOccupied: root.occupied(wsId)

                Layout.alignment: Qt.AlignVCenter
                implicitWidth: active ? 22 : 8
                implicitHeight: 8
                radius: 4
                color: active ? Theme.Yoake.peach
                     : isOccupied ? Theme.Yoake.cream
                     : Theme.Yoake.alpha(Theme.Yoake.fg, 0.28)

                Behavior on implicitWidth { Anim {} }
                Behavior on color { ColorAnimation { duration: 220 } }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch("workspace " + dot.wsId)
                }
            }
        }
    }
}
