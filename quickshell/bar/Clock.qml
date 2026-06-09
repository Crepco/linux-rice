import QtQuick
import QtQuick.Layouts
import Quickshell
import "../" as Theme

// 12-hour clock pill — click opens the clock panel (media + calendar).
Rectangle {
    id: root
    Layout.preferredHeight: 22
    Layout.alignment: Qt.AlignVCenter
    implicitWidth: row.implicitWidth + 22
    radius: 6
    color: ma.containsMouse || Theme.Controls.open === "clock"
         ? Theme.Yoake.alpha(Theme.Yoake.peach, 0.18) : "transparent"

    property string currentTime: ""
    property string meridiem: ""

    function updateTime() {
        const now = new Date();
        let h = now.getHours();
        meridiem = h >= 12 ? "PM" : "AM";
        h = h % 12 || 12;
        currentTime = h + ":" + String(now.getMinutes()).padStart(2, '0');
    }

    Component.onCompleted: updateTime()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.updateTime()
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 3

        Text {
            text: root.currentTime
            color: Theme.Yoake.cream
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
            font.weight: Font.DemiBold
        }
        Text {
            text: root.meridiem
            color: Theme.Yoake.muted
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeSm - 2
            Layout.alignment: Qt.AlignBottom
            Layout.bottomMargin: 2
        }
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Theme.Controls.toggle("clock")
    }
}
