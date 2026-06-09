import QtQuick
import QtQuick.Layouts
import Quickshell
import "../" as Theme

Item {
    id: root
    Layout.preferredHeight: 22
    implicitWidth: row.implicitWidth + 14

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 5
        Text {
            text: ""  // sun
            color: Theme.Yoake.cream
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
        }
        Text {
            text: Theme.Brightness.percent + "%"
            color: Theme.Yoake.cream
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeSm
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Theme.Controls.toggle("brightness")
    }
}
