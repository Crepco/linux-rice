import QtQuick
import QtQuick.Layouts
import "../" as Theme

// Dropdown for the bar clock: now-playing + visualizer on the left,
// month calendar on the right.
RowLayout {
    id: root
    spacing: 16

    MediaCard {
        Layout.preferredWidth: 250
        Layout.alignment: Qt.AlignTop
    }

    Rectangle {
        Layout.preferredWidth: 1
        Layout.fillHeight: true
        Layout.topMargin: 4
        Layout.bottomMargin: 4
        color: Theme.Yoake.border
    }

    CalendarView {
        Layout.preferredWidth: 230
        Layout.alignment: Qt.AlignTop
    }
}
