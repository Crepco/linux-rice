import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../" as Theme

// Caelestia-style workspaces, ported to a horizontal (top) bar.
// Signature move: a single active-indicator pill that SLIDES between
// workspaces with springy easing, instead of colours flipping instantly.
Rectangle {
    id: root

    Layout.preferredHeight: 22
    implicitWidth: cells.implicitWidth + 8
    radius: 6
    color: Theme.Yoake.bg
    border.color: Theme.Yoake.alpha(Theme.Yoake.peach, 0.18)
    border.width: 1

    readonly property int count: 10
    readonly property int cellW: 24
    readonly property int cellH: 18
    readonly property int activeWs: Hyprland.focusedWorkspace?.id ?? 1

    function occupied(id) {
        const ws = Hyprland.workspaces.values.find(w => w.id === id);
        return ws ? (ws.lastIpcObject?.windows ?? 0) > 0 : false;
    }

    Item {
        id: cells
        anchors.centerIn: parent
        implicitWidth: root.count * root.cellW
        implicitHeight: root.cellH

        // ─── Sliding active indicator (Caelestia signature) ───
        Rectangle {
            width: root.cellW
            height: root.cellH
            radius: 5
            x: (root.activeWs - 1) * root.cellW
            color: Theme.Yoake.alpha(Theme.Yoake.peach, 0.18)
            border.color: Theme.Yoake.alpha(Theme.Yoake.peach, 0.55)
            border.width: 1

            Behavior on x { Anim {} }
        }

        // ─── Workspace cells ───
        Repeater {
            model: root.count

            Item {
                id: cell
                required property int index
                readonly property int wsId: index + 1
                readonly property bool active: root.activeWs === wsId
                readonly property bool isOccupied: root.occupied(wsId)

                x: index * root.cellW
                width: root.cellW
                height: root.cellH

                // Hover state layer (animated — no binding breakage)
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: 4
                    color: Theme.Yoake.surface
                    opacity: ma.containsMouse && !cell.active ? 0.6 : 0
                    Behavior on opacity { Anim {} }
                }

                Text {
                    anchors.centerIn: parent
                    text: cell.wsId
                    color: cell.active
                        ? Theme.Yoake.peach
                        : cell.isOccupied
                            ? Theme.Yoake.fgDim
                            : Theme.Yoake.alpha(Theme.Yoake.fg, 0.4)
                    font.family: Theme.Fonts.family
                    font.pixelSize: Theme.Fonts.sizeSm
                    font.weight: cell.active ? Font.DemiBold : Font.Normal
                    // pronounced pop on the active workspace
                    scale: cell.active ? 1.3 : (cell.isOccupied ? 0.95 : 0.85)

                    Behavior on color { ColorAnimation { duration: 250 } }
                    Behavior on scale { Anim {} }
                }

                MouseArea {
                    id: ma
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: Hyprland.dispatch("workspace " + cell.wsId)
                }
            }
        }
    }
}
