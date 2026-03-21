// Nebula Bar — Workspaces (3 persistent workspace buttons)

import QtQuick
import QtQuick.Layouts
import Quickshell
import "../.."
import Quickshell.Hyprland

RowLayout {
    id: workspaceRoot

    property HyprlandMonitor monitor

    spacing: 4

    // 3 persistent workspaces
    Repeater {
        model: 3

        delegate: Rectangle {
            required property int index

            readonly property int wsId: index + 1
            readonly property bool isActive: {
                const active = Hyprland.focusedWorkspace
                return active && active.id === wsId
            }
            readonly property bool hasWindows: {
                const workspaces = Hyprland.workspaces.values
                for (let i = 0; i < workspaces.length; i++) {
                    if (workspaces[i].id === wsId && workspaces[i].toplevels.length > 0) {
                        return true
                    }
                }
                return false
            }

            Layout.preferredWidth: 28
            Layout.preferredHeight: 24
            radius: Theme.radius / 2
            color: isActive ? Theme.primary : (hasWindows ? Theme.surface1 : "transparent")

            Text {
                anchors.centerIn: parent
                text: String(wsId)
                color: isActive ? Theme.bg : Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                font.bold: isActive
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + wsId)
                onWheel: (e) => {
                    Hyprland.dispatch(e.angleDelta.y < 0 ? "workspace r+1" : "workspace r-1")
                }
            }
        }
    }
}
