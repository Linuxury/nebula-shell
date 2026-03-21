// Nebula Core — Bar Component
// Phase 2: Left (launcher, workspaces, title, media), Center (clock), Right (tray, audio, power)

import QtQuick
import QtQuick.Layouts
import Quickshell
import "../.."
import Quickshell.Hyprland
import Quickshell.Io

import "bar"

Item {
    id: barRoot

    property var screen

    // Monitor reference for workspace filtering
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(screen)

    // Focused window title
    readonly property string activeWindowTitle: {
        const toplevels = Hyprland.toplevels.values
        for (let i = 0; i < toplevels.length; i++) {
            if (toplevels[i].activated) {
                return toplevels[i].title || ""
            }
        }
        return ""
    }

    // Power menu process
    Process {
        id: powermenuProc
        command: ["bash", Quickshell.shellPath("scripts/powermenu.sh")]
    }

    implicitHeight: 36

    // === Background ===
    Rectangle {
        anchors.fill: parent
        color: Theme.bg
        opacity: Theme.bgOpacity
    }

    // === Layout ===
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 4

        // === LEFT ===
        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: 4

            LauncherButton {}

            Workspaces {
                monitor: barRoot.monitor
            }

            // Window title
            Text {
                Layout.maximumWidth: 200
                Layout.fillWidth: true
                visible: barRoot.activeWindowTitle.length > 0
                text: barRoot.activeWindowTitle
                color: Theme.fgDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }

            Media {}
        }

        // === CENTER ===
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 8

            Clock {}
        }

        // === RIGHT ===
        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 4

            SystemTray {}

            Audio {}

            // Separator
            Rectangle {
                Layout.preferredWidth: 1
                Layout.preferredHeight: 20
                color: Theme.borderDim
                opacity: 0.5
            }

            // Sidebar toggle button
            BarButton {
                icon: ""
                onClicked: GlobalStates.sidebarOpen = !GlobalStates.sidebarOpen
            }

            // Power button
            BarButton {
                icon: ""
                onClicked: powermenuProc.running = true
            }
        }
    }
}
