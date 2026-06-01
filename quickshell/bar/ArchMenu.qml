import QtQuick
import QtQuick.Layouts
import "../" as Theme

// Left-side Arch button — opens the control-center dropdown (sound/battery/bluetooth).
Rectangle {
    id: root
    Layout.preferredHeight: 22
    implicitWidth: 34
    radius: 6
    color: ma.containsMouse || Theme.Controls.open === "system"
         ? Theme.Yoake.alpha(Theme.Yoake.peach, 0.18) : "transparent"

    Text {
        anchors.centerIn: parent
        text: ""  // Arch Linux logo (Nerd Font)
        color: Theme.Yoake.peach
        font.family: Theme.Fonts.family
        font.pixelSize: Theme.Fonts.sizeMd
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Theme.Controls.toggle("system")
    }
}
