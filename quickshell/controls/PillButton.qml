import QtQuick
import "../" as Theme

// Small pill-shaped text/icon button used in the control panels.
Rectangle {
    id: root
    property string text: ""
    property color accent: Theme.Yoake.peach
    signal tapped()

    implicitHeight: 24
    implicitWidth: label.implicitWidth + 18
    radius: 6
    color: ma.containsMouse ? Theme.Yoake.alpha(accent, 0.22) : Theme.Yoake.surfaceAlt

    Text {
        id: label
        anchors.centerIn: parent
        text: root.text
        color: root.accent
        font.family: Theme.Fonts.family
        font.pixelSize: Theme.Fonts.sizeSm
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.tapped()
    }
}
