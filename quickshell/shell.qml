// Yoake (夜明け) Quickshell — entry point
// Phase 1+2: bar
// Phase 3: notifications
// Phase 4: launcher
// Phase 5: lockscreen
// Phase 6: OSD

import QtQuick
import Quickshell
import "bar"
import "notif"
import "launcher"
import "lock"
import "osd"

ShellRoot {
    Bar {}
    PopupList {}
    Launcher {}
    LockScreen {}
    Osd {}
}
