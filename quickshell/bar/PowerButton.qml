import QtQuick
import QtQuick.Layouts
import "../" as Theme

// Right-side power button — opens the power menu (lock/logout/suspend/reboot/shutdown).
Rectangle {
    id: root
    Layout.preferredHeight: 22
    implicitWidth: 30
    radius: 6
    color: ma.containsMouse || Theme.Controls.open === "power"
         ? Theme.Yoake.alpha(Theme.Yoake.rose, 0.22) : Theme.Yoake.bg
    border.color: Theme.Yoake.alpha(Theme.Yoake.rose, 0.30)
    border.width: 1

    Text {
        anchors.centerIn: parent
        text: ""  // power
        color: Theme.Yoake.rose
        font.family: Theme.Fonts.family
        font.pixelSize: Theme.Fonts.sizeMd
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Theme.Controls.toggle("power")
    }
}
