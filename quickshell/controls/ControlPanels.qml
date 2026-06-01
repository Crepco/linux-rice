// Host for the bar control popups (volume / brightness / wifi / bluetooth).
// Renders a top-right dropdown card with whichever panel Controls.open names.
import QtQuick
import Quickshell
import Quickshell.Wayland
import "../" as Theme

Scope {
    id: root

    LazyLoader {
        active: Theme.Controls.open !== ""

        PanelWindow {
            screen: Quickshell.screens[0]
            anchors { top: true; left: true; right: true; bottom: true }
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

            // Click-away + Escape to dismiss
            Item {
                anchors.fill: parent
                focus: true
                Keys.onEscapePressed: Theme.Controls.close()
                Component.onCompleted: Qt.callLater(forceActiveFocus)

                MouseArea { anchors.fill: parent; onClicked: Theme.Controls.close() }
            }

            // Dropdown card — drops from the left under the Arch icon for the
            // system menu, from the right under the bar pills otherwise.
            readonly property bool leftSide: Theme.Controls.open === "system"

            Rectangle {
                id: card
                anchors.top: parent.top
                anchors.left: parent.leftSide ? parent.left : undefined
                anchors.right: parent.leftSide ? undefined : parent.right
                anchors.topMargin: 40      // bar is 32 high
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                width: 320
                implicitHeight: content.implicitHeight + 28
                radius: 12
                color: Theme.Yoake.bg
                border.color: Theme.Yoake.peach
                border.width: 1

                // swallow clicks so they don't reach the dismiss catcher
                MouseArea { anchors.fill: parent }

                Loader {
                    id: content
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 14
                    sourceComponent: {
                        switch (Theme.Controls.open) {
                            case "system":     return systemC
                            case "power":      return powerC
                            case "volume":     return volumeC
                            case "brightness": return brightnessC
                            case "wifi":       return wifiC
                            case "bluetooth":  return bluetoothC
                            default:           return null
                        }
                    }
                }
            }

            Component { id: systemC;     SystemMenu {} }
            Component { id: powerC;      PowerMenu {} }
            Component { id: volumeC;     VolumePanel {} }
            Component { id: brightnessC; BrightnessPanel {} }
            Component { id: wifiC;       WifiPanel {} }
            Component { id: bluetoothC;  BluetoothPanel {} }
        }
    }
}
