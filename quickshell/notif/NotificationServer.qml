// org.freedesktop.Notifications DBus server — replaces dunst
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

NotificationServer {
    id: server

    keepOnReload: false
    bodySupported: true
    bodyMarkupSupported: true
    bodyHyperlinksSupported: true
    bodyImagesSupported: true
    imageSupported: true
    actionsSupported: true
    persistenceSupported: true

    onNotification: (notif) => {
        notif.tracked = true
    }
}
