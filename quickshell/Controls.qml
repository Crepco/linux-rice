pragma Singleton
import QtQuick

// Shared open-state for the bar control popups (volume / brightness / wifi / bluetooth).
// Bar pills call toggle(name); the ControlPanels host renders whichever panel is open.
QtObject {
    property string open: ""   // "" | "volume" | "brightness" | "wifi" | "bluetooth"

    function toggle(name) { open = (open === name) ? "" : name }
    function show(name)   { open = name }
    function close()      { open = "" }
}
