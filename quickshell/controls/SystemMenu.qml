import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import "../" as Theme

// Control-center dropdown opened from the Arch icon: sound, battery, bluetooth.
ColumnLayout {
    id: root
    spacing: 14

    // ── Sound ──
    VolumePanel { Layout.fillWidth: true }

    Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Theme.Yoake.border }

    // ── Battery ──
    RowLayout {
        Layout.fillWidth: true
        spacing: 10

        readonly property var dev: UPower.displayDevice
        readonly property real pct: dev?.percentage ? dev.percentage * 100 : 0
        readonly property string st: dev?.state ?? ""
        readonly property bool charging: st === UPowerDeviceState.Charging || st === UPowerDeviceState.FullyCharged
        readonly property bool present: dev?.isLaptopBattery ?? false

        Text {
            text: parent.charging ? "\uF0E7" : (parent.pct >= 80 ? "\uF240" : parent.pct >= 50 ? "\uF242" : parent.pct >= 20 ? "\uF243" : "\uF244")
            color: !parent.present ? Theme.Yoake.muted
                 : parent.pct <= 15 && !parent.charging ? Theme.Yoake.rose
                 : parent.charging ? Theme.Yoake.sage : Theme.Yoake.cream
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeLg
        }
        Text {
            text: "Battery"
            color: Theme.Yoake.fg
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
            Layout.fillWidth: true
        }
        Text {
            text: !parent.present ? "no battery"
                : Math.round(parent.pct) + "%" + (parent.charging ? "  (charging)" : "")
            color: parent.charging ? Theme.Yoake.sage : Theme.Yoake.fgDim
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeSm
        }
    }

    Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Theme.Yoake.border }

    // ── Bluetooth ──
    BluetoothPanel { Layout.fillWidth: true }

    Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Theme.Yoake.border }

    // ── Display settings ──
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 28
        radius: 6
        color: displayMa.containsMouse ? Theme.Yoake.surface : Theme.Yoake.surfaceAlt
        Text {
            anchors.centerIn: parent
            text: "󰍹  Display settings"
            color: Theme.Yoake.fgDim
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeSm
        }
        MouseArea {
            id: displayMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: Theme.Controls.show("monitors")
        }
    }
}
