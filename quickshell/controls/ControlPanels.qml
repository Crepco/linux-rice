// Host for the bar control popups (system / power / clock / volume /
// brightness / wifi / bluetooth). Renders whichever panel Controls.open
// names: power is a centered overlay with a dimmed backdrop, clock drops
// centered under the bar, the rest are top-left/right dropdown cards.
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "../" as Theme

Scope {
    id: root

    // Scriptable: qs ipc call controls toggle <name>
    IpcHandler {
        target: "controls"
        function toggle(name: string): void { Theme.Controls.toggle(name) }
        function open(name: string): void { Theme.Controls.show(name) }
        function close(): void { Theme.Controls.close() }
    }

    LazyLoader {
        active: Theme.Controls.open !== ""

        PanelWindow {
            id: panelWin
            screen: Quickshell.screens[0]
            anchors { top: true; left: true; right: true; bottom: true }
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: isPower
                ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.OnDemand

            readonly property bool isPower: Theme.Controls.open === "power"
            readonly property bool isClock: Theme.Controls.open === "clock"
            // System menu drops on the left under the Arch icon; pills on the right.
            readonly property bool leftSide: Theme.Controls.open === "system"
                                          || Theme.Controls.open === "monitors"

            // Click-away + Escape to dismiss (also dims the screen for power)
            Item {
                anchors.fill: parent
                focus: true
                Keys.onEscapePressed: Theme.Controls.close()
                Component.onCompleted: Qt.callLater(forceActiveFocus)

                Rectangle {
                    anchors.fill: parent
                    color: Qt.rgba(0, 0, 0, 0.45)
                    visible: panelWin.isPower
                }
                MouseArea { anchors.fill: parent; onClicked: Theme.Controls.close() }
            }

            Rectangle {
                id: card
                anchors.top: panelWin.isPower ? undefined : parent.top
                anchors.topMargin: 46
                anchors.left: !panelWin.isPower && !panelWin.isClock && panelWin.leftSide
                    ? parent.left : undefined
                anchors.right: !panelWin.isPower && !panelWin.isClock && !panelWin.leftSide
                    ? parent.right : undefined
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                anchors.horizontalCenter: panelWin.isPower || panelWin.isClock
                    ? parent.horizontalCenter : undefined
                anchors.verticalCenter: panelWin.isPower ? parent.verticalCenter : undefined

                width: panelWin.isPower || panelWin.isClock ? content.implicitWidth + 36 : 320
                implicitHeight: content.implicitHeight + (panelWin.isPower ? 36 : 28)
                radius: panelWin.isPower ? 22 : 12
                color: Theme.Yoake.alpha(Theme.Yoake.bg, panelWin.isPower ? 0.96 : 0.92)
                border.color: Theme.Yoake.peach
                border.width: 1

                // swallow clicks so they don't reach the dismiss catcher
                MouseArea { anchors.fill: parent }

                Loader {
                    id: content
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: panelWin.isPower ? 18 : 14
                    sourceComponent: {
                        switch (Theme.Controls.open) {
                            case "system":     return systemC
                            case "monitors":   return monitorsC
                            case "power":      return powerC
                            case "clock":      return clockC
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
            Component { id: monitorsC;   MonitorsPanel {} }
            Component { id: powerC;      PowerMenu {} }
            Component { id: clockC;      ClockPanel {} }
            Component { id: volumeC;     VolumePanel {} }
            Component { id: brightnessC; BrightnessPanel {} }
            Component { id: wifiC;       WifiPanel {} }
            Component { id: bluetoothC;  BluetoothPanel {} }
        }
    }
}
