import QtQuick
import "../" as Theme

// Minimal horizontal slider (0..100). Drag or click the track to set a value.
// While dragging it is *uncontrolled* — the handle follows the cursor immediately
// and emits moved(v); when released it resyncs to the owner's `value`.
Item {
    id: root

    property real value: 0          // external/actual value, 0..100
    property real from: 0           // brightness uses 1 to avoid full-off
    property color accent: Theme.Yoake.peach
    signal moved(real v)

    implicitHeight: 18

    // Displayed value: tracks the cursor while pressed, the real value otherwise.
    property real _val: value
    onValueChanged: if (!ma.pressed) _val = value

    readonly property real frac: Math.min(1, Math.max(0, (_val - from) / (100 - from)))

    function setFromX(px) {
        const f = Math.min(1, Math.max(0, px / width))
        _val = from + f * (100 - from)
        root.moved(_val)
    }

    // Track
    Rectangle {
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
