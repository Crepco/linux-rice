// Lockscreen using Wayland session-lock + PAM auth
// Theme: Yoake — peach hour, cream minute, blurred wallpaper
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam
import "../" as Theme

Scope {
    id: root

    property bool locked: false
    property string input_: ""
    property string status: ""
    property bool authError: false

    function lock()   { locked = true; input_ = ""; status = ""; authError = false }
    function unlock() { locked = false }

    IpcHandler {
        target: "lock"
        function activate() { root.lock() }
    }

    WlSessionLock {
        id: sessionLock
        locked: root.locked

        WlSessionLockSurface {
            color: "#000000"

            // Blurred wallpaper background
            Image {
                anchors.fill: parent
                source: "file:///home/crepco/Pictures/wallpapers/wallpaper.png"
                fillMode: Image.PreserveAspectCrop
                opacity: 0.65
            }

            // Dark overlay
            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0.04, 0.04, 0.10, 0.55)
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 14
                width: 380

                // Hour : minute (huge, two colors)
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 8
                    Text {
                        id: hourText
                        text: "00"
                        color: Theme.Yoake.peach
                        font.family: Theme.Fonts.family
                        font.pixelSize: 120
                        font.weight: Font.Bold
                    }
                    Text {
                        text: ":"
                        color: Theme.Yoake.cream
                        font.family: Theme.Fonts.family
                        font.pixelSize: 100
                    }
                    Text {
                        id: minuteText
                        text: "00"
                        color: Theme.Yoake.cream
                        font.family: Theme.Fonts.family
                        font.pixelSize: 120
                        font.weight: Font.Bold
                    }
                }

                // Date
                Text {
                    id: dateText
                    text: ""
                    color: Theme.Yoake.fgDim
                    font.family: Theme.Fonts.family
                    font.pixelSize: 18
                    Layout.alignment: Qt.AlignHCenter
                }

                Item { Layout.preferredHeight: 30 }

                // User
                Text {
                    text: "⚡ " + (Quickshell.env("USER") || "crepco")
                    color: Theme.Yoake.mauve
                    font.family: Theme.Fonts.family
                    font.pixelSize: 22
                    Layout.alignment: Qt.AlignHCenter
                }

                // Input field
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 50
                    radius: 8
                    color: Theme.Yoake.alpha(Theme.Yoake.bg, 0.7)
                    border.color: root.authError ? Theme.Yoake.rose : Theme.Yoake.peach
                    border.width: 2

                    Text {
                        anchors.centerIn: parent
                        text: root.status !== "" ? root.status : (
                            root.input_.length === 0 ? "" : "•".repeat(root.input_.length)
                        )
                        color: root.input_.length === 0 ? Theme.Yoake.muted : Theme.Yoake.fg
                        font.family: Theme.Fonts.family
                        font.pixelSize: 22
                    }
                }
            }

            // Live clock + date
            Timer {
                interval: 1000; running: true; repeat: true; triggeredOnStart: true
                onTriggered: {
                    const now = new Date()
                    hourText.text = String(now.getHours()).padStart(2, '0')
                    minuteText.text = String(now.getMinutes()).padStart(2, '0')
                    const days = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat']
                    const months = ['January','February','March','April','May','June','July','August','September','October','November','December']
                    dateText.text = days[now.getDay()] + ", " + now.getDate() + " " + months[now.getMonth()]
                }
            }

            // Hidden text input for capturing password
            TextInput {
                id: hiddenInput
                anchors.fill: parent
                color: "transparent"
                opacity: 0
                focus: true
                echoMode: TextInput.Password

                onTextChanged: root.input_ = text

                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        root.submit()
                        event.accepted = true
                    } else if (event.key === Qt.Key_Escape) {
                        text = ""
                        event.accepted = true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.IBeamCursor
                    onClicked: hiddenInput.forceActiveFocus()
                }
            }
        }
    }

    PamContext {
        id: pam
        config: "hyprlock"  // reuse hyprlock's PAM config — known to work
        active: false

        onCompleted: (result) => {
            if (result === PamResult.Success) {
                root.status = ""
                hiddenInput.text = ""
                root.unlock()
            } else {
                root.authError = true
                root.status = "wrong"
                resetTimer.start()
            }
        }
    }

    Timer {
        id: resetTimer
        interval: 1200
        onTriggered: {
            root.status = ""
            root.authError = false
            hiddenInput.text = ""
        }
    }

    function submit() {
        if (root.input_.length === 0) return
        root.status = "checking…"
        pam.active = false
        pam.active = true
        // Send response after pam becomes active (it'll ask for password)
    }

    Connections {
        target: pam
        function onPamMessage() {
            if (pam.responseRequired) {
                pam.respond(root.input_)
            }
        }
    }
}
