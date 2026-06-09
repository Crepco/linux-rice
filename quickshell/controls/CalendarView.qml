import QtQuick
import QtQuick.Layouts
import "../" as Theme

// Hand-rolled month calendar — today is a peach pill, ‹ › steps months.
ColumnLayout {
    id: root
    spacing: 8

    property int year: new Date().getFullYear()
    property int month: new Date().getMonth()   // 0-based

    readonly property var today: new Date()
    readonly property int firstOffset: new Date(year, month, 1).getDay()       // Sun = 0
    readonly property int daysInMonth: new Date(year, month + 1, 0).getDate()

    function step(d) {
        let m = month + d, y = year
        if (m < 0)  { m = 11; y-- }
        if (m > 11) { m = 0;  y++ }
        month = m; year = y
    }

    // ── Header: ‹ Month Year › ──
    RowLayout {
        Layout.fillWidth: true
        spacing: 6

        component NavButton: Rectangle {
            property string glyph: ""
            signal tapped()
            implicitWidth: 22
            implicitHeight: 22
            radius: 6
            color: nma.containsMouse ? Theme.Yoake.alpha(Theme.Yoake.peach, 0.18) : "transparent"
            Text {
                anchors.centerIn: parent
                text: parent.glyph
                color: Theme.Yoake.peach
                font.family: Theme.Fonts.family
                font.pixelSize: Theme.Fonts.sizeSm
            }
            MouseArea {
                id: nma
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: parent.tapped()
            }
        }

        NavButton { glyph: ""; onTapped: root.step(-1) }
        Text {
            text: Qt.formatDate(new Date(root.year, root.month, 1), "MMMM yyyy")
            color: Theme.Yoake.cream
            font.family: Theme.Fonts.family
            font.pixelSize: Theme.Fonts.sizeMd
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
        }
        NavButton { glyph: ""; onTapped: root.step(1) }
    }

    // ── Day-of-week header ──
    RowLayout {
        Layout.fillWidth: true
        spacing: 0
        Repeater {
            model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
            Text {
                required property string modelData
                text: modelData
                color: Theme.Yoake.muted
                font.family: Theme.Fonts.family
                font.pixelSize: Theme.Fonts.sizeSm - 1
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
            }
        }
    }

    // ── Day grid (6 weeks) ──
    GridLayout {
        columns: 7
        rowSpacing: 2
        columnSpacing: 0
        Layout.fillWidth: true

        Repeater {
            model: 42
            Item {
                required property int index
                readonly property int day: index - root.firstOffset + 1
                readonly property bool valid: day >= 1 && day <= root.daysInMonth
                readonly property bool isToday: valid
                    && day === root.today.getDate()
                    && root.month === root.today.getMonth()
                    && root.year === root.today.getFullYear()

                Layout.fillWidth: true
                implicitHeight: 24

                Rectangle {
                    anchors.centerIn: parent
                    width: 24
                    height: 22
                    radius: 7
                    color: parent.isToday ? Theme.Yoake.peach : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: parent.parent.valid ? parent.parent.day : ""
                        color: parent.parent.isToday ? Theme.Yoake.bg : Theme.Yoake.fgDim
                        font.family: Theme.Fonts.family
                        font.pixelSize: Theme.Fonts.sizeSm
                        font.weight: parent.parent.isToday ? Font.Bold : Font.Normal
                    }
                }
            }
        }
    }
}
