// Nebula Shell — Entry Point

import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import "./components"

ShellRoot {
    id: root

    // Matugen color loader - overrides theme colors when wallpaper changes
    Matugen {
        id: matugen
    }

    // Bar - one instance per screen
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            property var modelData
            screen: modelData

            anchors { top: true; left: true; right: true }
            exclusiveZone: 30

            WlrLayershell.namespace: "nebula:bar"
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

            color: "transparent"

            Bar {
                anchors.fill: parent
                screen: bar.screen
            }
        }
    }

    // Dock - one instance per screen (bottom)
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: dock
            property var modelData
            screen: modelData

            anchors { bottom: true }
            exclusiveZone: 72

            WlrLayershell.namespace: "nebula:dock"
            WlrLayershell.layer: WlrLayer.Bottom
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

            color: "transparent"

            Dock {
                anchors.centerIn: parent
                anchors.bottomMargin: 8
                screen: dock.screen
            }
        }
    }

    // Notifications - one instance per screen (top right)
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: notifPanel
            property var modelData
            screen: modelData

            anchors { top: true; right: true }
            margins { top: 48; right: 12 }
            implicitWidth: 350
            implicitHeight: 400

            color: "transparent"

            Notifications {
                anchors.fill: parent
                screen: notifPanel.screen
            }
        }
    }

    // OSD - one instance per screen (right side)
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: osdPanel
            property var modelData
            screen: modelData

            anchors { right: true; top: true; bottom: true }
            margins { right: 12; top: 200; bottom: 200 }
            implicitWidth: 250
            implicitHeight: 60

            color: "transparent"

            OSD {
                anchors.fill: parent
                screen: osdPanel.screen
            }
        }
    }

    // Launcher - floating window (global, single instance)
    Launcher {
        id: launcherWindow
    }

    // Sidebar - control center (right side)
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: sidebarPanel
            property var modelData
            screen: modelData

            anchors { top: true; right: true; bottom: true }
            margins { top: 48; right: 12; bottom: 12 }
            implicitWidth: 320

            color: "transparent"

            Sidebar {
                anchors.fill: parent
                screen: sidebarPanel.screen
            }
        }
    }

    // Workspace Overview - centered overlay
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: overviewPanel
            property var modelData
            screen: modelData

            anchors { top: true; left: true; right: true; bottom: true }
            margins { top: 100; left: 100; right: 100; bottom: 100 }
            implicitWidth: 700
            implicitHeight: 400

            color: "transparent"

            WorkspaceOverview {
                anchors.fill: parent
                screen: overviewPanel.screen
            }
        }
    }

    // Lock Screen - full screen overlay
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: lockScreenPanel
            property var modelData
            screen: modelData

            anchors { top: true; left: true; right: true; bottom: true }

            color: "transparent"

            WlrLayershell.namespace: "nebula:lockscreen"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            LockScreen {
                anchors.fill: parent
                screen: lockScreenPanel.screen
            }
        }
    }

    // Screenshot tool - centered overlay
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: screenshotPanel
            property var modelData
            screen: modelData

            anchors { top: true; left: true; right: true; bottom: true }
            margins { top: 200; left: 200; right: 200; bottom: 200 }
            implicitWidth: 400
            implicitHeight: 200

            color: "transparent"

            Screenshot {
                anchors.fill: parent
                screen: screenshotPanel.screen
            }
        }
    }
}
