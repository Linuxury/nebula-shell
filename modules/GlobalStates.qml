// Global UI state singleton

pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: globalStates

    // Sidebar / control center
    property bool sidebarOpen: false

    // Launcher
    property bool launcherOpen: false

    // Notifications
    property bool doNotDisturb: false

    // Dock (bottom bar) — always visible by default
    property bool dockVisible: true

    // Workspace overview
    property bool overviewOpen: false
}
