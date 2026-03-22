// Solar Flares — Notification Component
// Phase 4: Toast notifications, stacked, auto-dismiss

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import qs.modules

Item {
    id: notificationRoot

    property var screen

    implicitWidth: 350
    implicitHeight: notificationList.implicitHeight + 24

    // Notification server
    NotificationServer {
        id: notifServer

        actionsSupported: true
        imageSupported: true
        persistenceSupported: true
        keepOnReload: true

        onNotification: (notif) => {
            // Track all incoming notifications
            notif.tracked = true
        }
    }

    // Notification list
    ColumnLayout {
        id: notificationList
        anchors.fill: parent
        spacing: 8

        Repeater {
            model: notifServer.trackedNotifications

            delegate: NotificationToast {
                required property Notification modelData
                notification: modelData
                Layout.fillWidth: true
            }
        }
    }

    // Individual notification toast
    component NotificationToast: Rectangle {
        id: toast

        property Notification notification: null

        height: toastContent.implicitHeight + 16
        radius: Theme.radius
        color: Theme.bg
        opacity: Theme.bgOpacity
        border.color: Theme.borderDim
        border.width: 1

        // Auto-dismiss timer
        Timer {
            interval: 5000
            running: true
            onTriggered: {
                if (toast.notification) {
                    toast.notification.dismiss()
                }
            }
        }

        RowLayout {
            id: toastContent
            anchors.fill: parent
            anchors.margins: 8
            spacing: 12

            // App icon or notification icon
            Image {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                source: {
                    if (!toast.notification) return ""
                    const icon = toast.notification.appIcon || toast.notification.image
                    if (!icon) return ""
                    if (icon.startsWith("/")) return "file://" + icon
                    return Quickshell.iconPath(icon, "")
                }
                fillMode: Image.PreserveAspectFit
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                // App name
                Text {
                    Layout.fillWidth: true
                    text: toast.notification ? toast.notification.appName : ""
                    color: Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize - 2
                    elide: Text.ElideRight
                }

                // Summary
                Text {
                    Layout.fillWidth: true
                    text: toast.notification ? toast.notification.summary : ""
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.bold: true
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                }

                // Body
                Text {
                    Layout.fillWidth: true
                    visible: text.length > 0
                    text: toast.notification ? toast.notification.body : ""
                    color: Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize - 1
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    maximumLineCount: 3
                }
            }

            // Dismiss button
            Text {
                text: ""
                color: Theme.fgDim
                font.pixelSize: 14

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (toast.notification) {
                            toast.notification.dismiss()
                        }
                    }
                }
            }
        }

        // Slide in animation
        NumberAnimation on x {
            from: 350
            to: 0
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
}
