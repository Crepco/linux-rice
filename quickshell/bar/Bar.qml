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

            implicitHeight: 32
            color: "transparent"

            // Force layer-shell to TOP and reserve space
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            exclusionMode: ExclusionMode.Normal
            exclusiveZone: 32

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                spacing: 0

                // ─── LEFT ───
                RowLayout {
                    spacing: 5
                    Layout.alignment: Qt.AlignLeft
                    Workspaces {}
                    Uptime {}
                    Cpu {}
                }

                Item { Layout.fillWidth: true }

                // ─── CENTER ───
                Clock {}

                Item { Layout.fillWidth: true }

                // ─── RIGHT ───
                RowLayout {
                    spacing: 6
                    Layout.alignment: Qt.AlignRight
                    SystemTray {}
                    SystemPills {}
                }
            }
        }
    }
}
