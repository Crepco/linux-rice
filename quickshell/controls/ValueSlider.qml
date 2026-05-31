import QtQuick
import "../" as Theme

// Minimal horizontal slider (0..100). Drag or click the track to set a value.
// Emits moved(v) live while dragging; `value` is an input binding from the owner.
Item {
    id: root

    property real value: 0          // 0..100, driven by owner
    property real from: 0           // brightness uses 1 to avoid full-off
    property color accent: Theme.Yoake.peach
    signal moved(real v)

    implicitHeight: 18

    readonly property real frac: Math.min(1, Math.max(0, (value - from) / (100 - from)))

    function setFromX(px) {
        const f = Math.min(1, Math.max(0, px / width))
        root.moved(from + f * (100 - from))
    }

    // Track
    Rectangle {
        id: track
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 5
        radius: 2.5
        color: Theme.Yoake.surface

        // Fill
        Rectangle {
            width: parent.width * root.frac
            height: parent.height
            radius: 2.5
            color: root.accent
            Behavior on width { enabled: !ma.pressed; NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
        }
    }

    // Handle
    Rectangle {
        width: 14
        height: 14
        radius: 7
        color: root.accent
        border.color: Theme.Yoake.bg
        border.width: 2
        y: (parent.height - height) / 2
        x: root.frac * (parent.width - width)
        Behavior on x { enabled: !ma.pressed; NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        anchors.margins: -6        // easier grab target
        cursorShape: Qt.PointingHandCursor
        onPressed: mouse => root.setFromX(mouse.x - 6)
        onPositionChanged: mouse => { if (pressed) root.setFromX(mouse.x - 6) }
    }
}
