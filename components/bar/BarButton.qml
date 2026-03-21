// Nebula Bar — Launcher Button

import QtQuick
import Quickshell

Item {
    implicitWidth: 32
    implicitHeight: 32

    property string icon: ""

    signal clicked()

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius / 2
        color: mouseArea.containsMouse ? Theme.surface1 : "transparent"

        Text {
            anchors.centerIn: parent
            text: icon
            color: Theme.fg
            font.pixelSize: 16
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: parent.parent.clicked()
        }
    }
}
