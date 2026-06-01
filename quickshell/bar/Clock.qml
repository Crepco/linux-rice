import QtQuick
import QtQuick.Layouts
import Quickshell
import "../" as Theme

Rectangle {
    Layout.preferredHeight: 22
    Layout.alignment: Qt.AlignVCenter
    implicitWidth: clockText.implicitWidth + 22
    color: "transparent"

    property string currentTime: ""

    function updateTime() {
        const now = new Date();
        const h = String(now.getHours()).padStart(2, '0');
        const m = String(now.getMinutes()).padStart(2, '0');
        currentTime = h + ":" + m;
    }

    Component.onCompleted: updateTime()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: parent.updateTime()
    }

    Text {
        id: clockText
        anchors.centerIn: parent
        text: parent.currentTime
        color: Theme.Yoake.cream
        font.family: Theme.Fonts.family
        font.pixelSize: Theme.Fonts.sizeMd
        font.weight: Font.DemiBold
    }
}
