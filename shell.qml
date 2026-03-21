import Quickshell

ShellRoot {
    id: root

    // Theme singleton - accessed as Theme.colors throughout the shell
    Theme { id: theme }

    // Matugen color loader - overrides theme colors when wallpaper changes
    Matugen {
        id: matugen
        theme: theme
    }

    // Bar - one instance per screen
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            property var modelData
            screen: modelData

            // TODO: Phase 2 - Bar implementation
            // components/Bar.qml will be imported here

            implicitHeight: 36
            color: "transparent"
        }
    }
}
