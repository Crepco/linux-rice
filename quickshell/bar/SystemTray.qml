import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import "../" as Theme

RowLayout {
    spacing: 6
    Layout.alignment: Qt.AlignVCenter

    Repeater {
        model: SystemTray.items
        delegate: Item {
            required property SystemTrayItem modelData
            implicitWidth: 18
            implicitHeight: 18

            Image {
                anchors.fill: parent
                source: modelData.icon
                fillMode: Image.PreserveAspectFit
                sourceSize.width: 18
                sourceSize.height: 18
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor
                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) modelData.activate()
                    else if (modelData.hasMenu) modelData.display(parent, 0, parent.height)
                }
            }
        }
    }
}
