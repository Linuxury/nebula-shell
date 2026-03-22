// Nebula Bar — Launcher Button

import QtQuick
import Quickshell
import qs.modules

BarButton {
    icon: Icons.getIcon("apps")
    onClicked: GlobalStates.launcherOpen = !GlobalStates.launcherOpen
}
