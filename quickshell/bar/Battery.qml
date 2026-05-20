import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import "../" as Theme

Item {
    id: root
    Layout.preferredHeight: 22
    implicitWidth: row.implicitWidth + 14

    readonly property var device: UPower.displayDevice
    readonly property real pct: device?.percentage ? device.percentage * 100 : 0
    readonly property string state: device?.state ?? ""
    readonly property bool charging: state === UPowerDeviceState.Charging || state === UPowerDeviceState.FullyCharged
    readonly property bool warning: pct <= 20 && !charging
    readonly property bool critical: pct <= 10 && !charging

    function icon() {
        if (charging) return "\uF0E7"  // bolt
        if (pct >= 90) return "\uF240"  // battery-full
        if (pct >= 70) return "\uF241"  // battery 3/4
        if (pct >= 50) return "\uF242"  // battery 1/2
        if (pct >= 30) return "\uF243"  // battery 1/4
        if (pct >= 10) return "\uF243"
        return "\uF244"  // battery-empty
    }

    function color_() {
        if (critical) return Theme.Yoake.rose
        if (warning) return Theme.Yoake.peach
        if (charging) return Theme.Yoake.cream
        return Theme.Yoake.fg
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 5
        Text {
            text: root.icon()
            color: root.color_()
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
        }
        Text {
            text: Math.round(root.pct) + "%"
            color: root.color_()
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeSm
        }
    }
}
