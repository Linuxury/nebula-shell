// Nebula Dock — Individual dock app icon

import QtQuick
import Quickshell
import Quickshell.Widgets

Item {
    id: dockApp

    property var desktopEntry: null
    property bool isPinned: false
    property bool isRunning: false

    implicitWidth: 44
    implicitHeight: 44

    // === Icon ===
    Rectangle {
        anchors.centerIn: parent
        width: 40
        height: 40
        radius: Theme.radius / 2
        color: mouseArea.containsMouse ? Theme.surface1 : "transparent"

        // App icon
        IconImage {
            anchors.centerIn: parent
            width: 32
            height: 32
            source: desktopEntry ? Quickshell.iconPath(desktopEntry.icon, "") : ""
        }

        // Running indicator dot
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
            width: 6
            height: 6
            radius: 3
            color: Theme.primary
            visible: dockApp.isRunning
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (desktopEntry) desktopEntry.execute()
            }

            // Tooltip on hover
            Rectangle {
                anchors.bottom: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 8
                width: tooltipText.implicitWidth + 16
                height: tooltipText.implicitHeight + 8
                radius: Theme.radius / 2
                color: Theme.mantle
                border.color: Theme.border
                border.width: 1
                visible: mouseArea.containsMouse && desktopEntry

                Text {
                    id: tooltipText
                    anchors.centerIn: parent
                    text: desktopEntry ? desktopEntry.name : ""
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }
            }
        }
    }
}
