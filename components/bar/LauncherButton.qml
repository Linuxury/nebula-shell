// Nebula Bar — Launcher Button

import QtQuick
import Quickshell

BarButton {
    icon: ""
    onClicked: GlobalStates.launcherOpen = !GlobalStates.launcherOpen
}
