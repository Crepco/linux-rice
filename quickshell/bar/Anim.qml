import QtQuick

// Caelestia-style standard animation, exaggerated so the motion is obvious.
// Springy overshoot. Use inside a Behavior:  Behavior on x { Anim {} }
NumberAnimation {
    duration: 450
    easing.type: Easing.OutBack
    easing.overshoot: 1.6
}
