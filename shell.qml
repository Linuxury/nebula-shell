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
            exclusiveZone: 36

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
}
