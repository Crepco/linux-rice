import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../" as Theme

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 40
            color: "transparent"

            // Force layer-shell to TOP and reserve space
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            exclusionMode: ExclusionMode.Normal
            exclusiveZone: 40

            // ─── Centered solid island ───
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 6
                height: 30
                radius: 10
                color: Theme.Yoake.bg
                border.color: Theme.Yoake.alpha(Theme.Yoake.peach, 0.20)
                border.width: 1
                implicitWidth: content.implicitWidth + 24

                RowLayout {
                    id: content
                    anchors.centerIn: parent
                    spacing: 10

                    ArchMenu {}
                    Separator {}
                    Workspaces {}
                    Clock {}
                    Separator {}
                    Cpu {}
                    Backlight {}
                    Network {}
                    PowerButton {}
                }
            }

            // thin vertical divider between groups
            component Separator: Rectangle {
                Layout.preferredWidth: 1
                Layout.preferredHeight: 14
                Layout.alignment: Qt.AlignVCenter
                color: Theme.Yoake.alpha(Theme.Yoake.peach, 0.18)
            }
        }
    }
}
