// Lockscreen — Wayland session-lock + PAM auth
// Yoake palette: peach hour, cream minute
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
    property bool pamReady: false  // true once PAM has prompted

    function lock() {
        input_ = ""; status = ""; authError = false; pamReady = false
        locked = true
        Qt.callLater(() => pam.active = true)
    }

    function unlock() {
        locked = false
        pam.active = false
    }

    function submit() {
        if (!pamReady || input_.length === 0) return
        status = "checking…"
        pam.respond(input_)
        pamReady = false  // wait for next prompt
    }

    IpcHandler {
        target: "lock"
        function activate() { root.lock() }
    }

    PamContext {
        id: pam
        config: "hyprlock"
        active: false

        onPamMessage: {
            // PAM asked us something; if it needs a response we're ready to send one
            if (responseRequired) root.pamReady = true
        }

        onCompleted: (result) => {
            if (result === PamResult.Success) {
                root.status = ""
                root.input_ = ""
                root.unlock()
            } else {
                root.authError = true
                root.status = "wrong"
                root.input_ = ""
                resetTimer.start()
            }
        }

        onError: (err) => {
            root.authError = true
            root.status = "auth error"
            resetTimer.start()
        }
    }

    Timer {
        id: resetTimer
        interval: 1200
        onTriggered: {
            root.status = ""
            root.authError = false
            // Restart PAM for another attempt
            pam.active = false
            Qt.callLater(() => pam.active = true)
        }
    }

    WlSessionLock {
        id: sessionLock
        locked: root.locked

        WlSessionLockSurface {
            color: "#000000"

            Image {
                anchors.fill: parent
                source: "file:///home/crepco/Pictures/wallpapers/wallpaper.png"
                fillMode: Image.PreserveAspectCrop
                opacity: 0.65
            }

            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0.04, 0.04, 0.10, 0.55)
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 14
                width: 380

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

                Text {
                    id: dateText
                    text: ""
                    color: Theme.Yoake.fgDim
                    font.family: Theme.Fonts.family
                    font.pixelSize: 18
                    Layout.alignment: Qt.AlignHCenter
                }

                Item { Layout.preferredHeight: 30 }

                Text {
                    text: "⚡ " + (Quickshell.env("USER") || "user")
                    color: Theme.Yoake.mauve
                    font.family: Theme.Fonts.family
                    font.pixelSize: 22
                    Layout.alignment: Qt.AlignHCenter
                }

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

            TextInput {
                id: hiddenInput
                anchors.fill: parent
                color: "transparent"
                opacity: 0
                focus: true
                echoMode: TextInput.Password

                Component.onCompleted: Qt.callLater(forceActiveFocus)

                onTextChanged: root.input_ = text

                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        root.submit()
                        event.accepted = true
                    } else if (event.key === Qt.Key_Backspace && root.status === "wrong") {
                        // Clear error state immediately on retype
                        root.status = ""
                        root.authError = false
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.ArrowCursor
                    onClicked: hiddenInput.forceActiveFocus()
                }
            }
        }
    }
}
