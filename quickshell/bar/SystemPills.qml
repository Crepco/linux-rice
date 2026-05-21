import QtQuick
import QtQuick.Layouts
import Quickshell
import "../" as Theme

// Connected right-side pill — mirrors waybar's seamless network/audio/backlight/battery group
Rectangle {
    Layout.preferredHeight: 22
    implicitWidth: row.implicitWidth + 16
    radius: 6
    color: Theme.Yoake.bg
    border.color: Theme.Yoake.alpha(Theme.Yoake.mauve, 0.20)
    border.width: 1

    RowLayout {
        id: row
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        spacing: 0

        Network    {}
        Separator  {}
        Bluetooth  {}
        Separator  {}
        Audio      {}
        Separator  {}
        Backlight  {}
        Separator  {}
        Battery    {}
    }

    // Inline separator helper
    component Separator: Rectangle {
        Layout.preferredWidth: 1
        Layout.fillHeight: true
        Layout.topMargin: 5
        Layout.bottomMargin: 5
        color: Theme.Yoake.alpha(Theme.Yoake.mauve, 0.18)
    }
}
