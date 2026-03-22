// Nebula Dock — Bottom panel with pinned + running apps

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules
import Quickshell.Hyprland
import Quickshell.Widgets

import "dock"

Item {
    id: dockRoot

    property var screen

    // Visible when GlobalStates.dockVisible (controlled from sidebar)
    visible: GlobalStates.dockVisible

    // Dock dimensions
    implicitHeight: dockBg.implicitHeight
    implicitWidth: dockLayout.implicitWidth + 24

    // === Background ===
    Rectangle {
        id: dockBg
        anchors.fill: parent
        implicitHeight: 56
        radius: Theme.radius
        color: Theme.bg
        opacity: Theme.bgOpacity

        border.color: Theme.borderDim
        border.width: 1
    }

    // === Layout ===
    RowLayout {
        id: dockLayout
        anchors.centerIn: parent
        spacing: 4

        // === Pinned Apps ===
        Repeater {
            model: pinnedApps

            DockApp {
                required property var modelData
                desktopEntry: modelData
                isPinned: true
                isRunning: isAppRunning(modelData)
            }
        }

        // === Divider (only show if there are running non-pinned apps) ===
        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 36
            Layout.leftMargin: 4
            Layout.rightMargin: 4
            color: Theme.borderDim
            opacity: 0.5
            visible: unpinnedRunningApps.length > 0
        }

        // === Running Unpinned Apps ===
        Repeater {
            model: unpinnedRunningApps

            DockApp {
                required property var modelData
                desktopEntry: modelData
                isPinned: false
                isRunning: true
            }
        }
    }

    // === Data ===

    // Pinned apps list (by desktop entry ID)
    readonly property var pinnedAppIds: [
        "firefox.desktop",
        "kitty.desktop",
        "nemo.desktop",
        "steam.desktop",
        "discord.desktop"
    ]

    // Resolve pinned desktop entries
    readonly property var pinnedApps: {
        const entries = []
        for (let i = 0; i < pinnedAppIds.length; i++) {
            const entry = DesktopEntries.byId(pinnedAppIds[i])
            if (entry && !entry.noDisplay) entries.push(entry)
        }
        return entries
    }

    // All running toplevels from Hyprland
    readonly property var runningToplevels: Hyprland.toplevels.values

    // Unpinned running apps (running but not in pinned list)
    readonly property var unpinnedRunningApps: {
        const seen = new Set(pinnedAppIds)
        const result = []
        const toplevels = runningToplevels

        for (let i = 0; i < toplevels.length; i++) {
            const cls = toplevels[i].class || ""
            // Match by startupClass
            const entries = DesktopEntries.applications.values
            for (let j = 0; j < entries.length; j++) {
                const entry = entries[j]
                if (entry.noDisplay) continue
                if (entry.startupClass && entry.startupClass.toLowerCase() === cls.toLowerCase()) {
                    if (!seen.has(entry.id)) {
                        seen.add(entry.id)
                        result.push(entry)
                    }
                    break
                }
            }
        }
        return result
    }

    // Check if a pinned app is currently running
    function isAppRunning(entry) {
        if (!entry) return false
        const cls = entry.startupClass ? entry.startupClass.toLowerCase() : ""
        if (!cls) return false

        const toplevels = runningToplevels
        for (let i = 0; i < toplevels.length; i++) {
            if ((toplevels[i].class || "").toLowerCase() === cls) return true
        }
        return false
    }
}
