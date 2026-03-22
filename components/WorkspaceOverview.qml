// Nebula Workspace Overview — 2×5 grid of workspaces
// Shows window titles, focused workspace highlight, click to switch

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.modules

Item {
    id: overviewRoot

    property var screen

    // Visible when GlobalStates.overviewOpen
    visible: GlobalStates.overviewOpen

    implicitWidth: 700
    implicitHeight: 400

    // Close on escape
    Keys.onEscapePressed: GlobalStates.overviewOpen = false

    // Focus grab to close on click outside
    HyprlandFocusGrab {
        id: overviewFocus
        windows: [overviewRoot.Window.window]
        onCleared: GlobalStates.overviewOpen = false
    }

    // Background
    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: Theme.bg
        opacity: Theme.bgOpacity
        border.color: Theme.borderDim
        border.width: 1
    }

    // Content
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: Icons.getIcon("dashboard")
                color: Theme.primary
                font.family: Icons.fontFamily
                font.pixelSize: 20
            }

            Text {
                Layout.fillWidth: true
                text: "Workspace Overview"
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize + 2
                font.bold: true
            }

            Text {
                text: Icons.getIcon("close")
                color: Theme.fgDim
                font.family: Icons.fontFamily
                font.pixelSize: 18

                MouseArea {
                    anchors.fill: parent
                    onClicked: GlobalStates.overviewOpen = false
                }
            }
        }

        // Workspace grid (2×5)
        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 5
            rowSpacing: 8
            columnSpacing: 8

            Repeater {
                model: 10 // 2 rows × 5 columns

                WorkspaceCard {
                    wsId: index + 1
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }

    // Workspace card component
    component WorkspaceCard: Rectangle {
        id: card

        property int wsId: 1

        readonly property bool isActive: {
            const ws = Hyprland.focusedWorkspace
            return ws && ws.id === wsId
        }

        readonly property var workspace: {
            const workspaces = Hyprland.workspaces.values
            for (let i = 0; i < workspaces.length; i++) {
                if (workspaces[i].id === wsId) return workspaces[i]
            }
            return null
        }

        readonly property string windowTitle: {
            if (!workspace) return ""
            const toplevels = workspace.toplevels
            if (!toplevels || toplevels.length === 0) return ""
            // Get the focused window title
            for (let i = 0; i < toplevels.length; i++) {
                if (toplevels[i].activated) return toplevels[i].title || ""
            }
            return toplevels[0].title || ""
        }

        readonly property int windowCount: {
            if (!workspace) return 0
            return workspace.toplevels ? workspace.toplevels.length : 0
        }

        radius: Theme.radius
        color: isActive ? Theme.primary : Theme.surface0
        border.color: isActive ? Theme.primary : Theme.borderDim
        border.width: isActive ? 2 : 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 4

            // Workspace number
            RowLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: String(wsId)
                    color: isActive ? Theme.bg : Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize + 4
                    font.bold: true
                }

                Item { Layout.fillWidth: true }

                // Window count badge
                Rectangle {
                    visible: windowCount > 0
                    width: countText.implicitWidth + 8
                    height: countText.implicitHeight + 4
                    radius: 8
                    color: isActive ? Theme.bg : Theme.surface1

                    Text {
                        id: countText
                        anchors.centerIn: parent
                        text: String(windowCount)
                        color: isActive ? Theme.primary : Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize - 2
                    }
                }
            }

            // Window title (or placeholder)
            Text {
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: windowTitle.length > 0
                text: windowTitle
                color: isActive ? Theme.bg : Theme.fgDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize - 1
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                maximumLineCount: 2
                verticalAlignment: Text.AlignTop
            }

            // Empty workspace placeholder
            Text {
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: windowTitle.length === 0
                text: "Empty"
                color: isActive ? Theme.bg : Theme.borderDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize - 1
                font.italic: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            // Active indicator line
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 2
                radius: 1
                color: isActive ? Theme.bg : "transparent"
                visible: isActive
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onEntered: card.opacity = 0.9
            onExited: card.opacity = 1.0

            onClicked: {
                Hyprland.dispatch("workspace " + wsId)
                GlobalStates.overviewOpen = false
            }
        }

        // Hover animation
        Behavior on opacity {
            NumberAnimation { duration: 100 }
        }

        // Scale on hover
        transform: Scale {
            id: cardScale
            xScale: mouseArea.containsMouse ? 1.02 : 1.0
            yScale: mouseArea.containsMouse ? 1.02 : 1.0
            Behavior on xScale { NumberAnimation { duration: 100 } }
            Behavior on yScale { NumberAnimation { duration: 100 } }
        }

        property var mouseArea: MouseArea {
            anchors.fill: parent
            hoverEnabled: true
        }
    }
}
