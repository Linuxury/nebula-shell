// Nebula Bar — System Tray

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

RowLayout {
    id: trayRoot

    spacing: 4

    // Only show if items exist
    visible: trayItems.count > 0

    Repeater {
        id: trayItems
        model: SystemTray.items

        delegate: Item {
            required property SystemTrayItem modelData

            implicitWidth: 24
            implicitHeight: 24

            // Tray icon
            Image {
                anchors.centerIn: parent
                source: modelData.icon
                width: 18
                height: 18
                fillMode: Image.PreserveAspectFit
            }

            // Right-click context menu
            QsMenuOpener {
                id: menuOpener
                menu: modelData.menu
            }

            QsMenuAnchor {
                id: menuAnchor
                menu: menuOpener
                anchor.window: QsWindow.window
                anchor.item: parent
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: (e) => {
                    if (e.button === Qt.RightButton) {
                        menuAnchor.open()
                    } else {
                        modelData.activate()
                    }
                }
            }
        }
    }
}
