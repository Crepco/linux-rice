import QtQuick
import QtQuick.Layouts
import Quickshell
import "../" as Theme

// Native brightness control — reads/writes through the shared Brightness singleton.
ColumnLayout {
    id: root
    spacing: 12

    RowLayout {
        Layout.fillWidth: true
        spacing: 10
        Text {
            text: ""  // sun
            color: Theme.Yoake.cream
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeLg
        }
        Text {
            text: "Brightness"
            color: Theme.Yoake.fg
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
            Layout.fillWidth: true
        }
        Text {
            text: Theme.Brightness.percent + "%"
            color: Theme.Yoake.cream
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
        }
    }

    ValueSlider {
        Layout.fillWidth: true
        from: 1
        accent: Theme.Yoake.cream
        value: Theme.Brightness.percent
        onMoved: v => Theme.Brightness.setPercent(v)
    }
}
