// Stellar Nursery — Launcher Component
// Phase 4: App search, categories, keyboard navigation

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.modules

FloatingWindow {
    id: launcher

    visible: GlobalStates.launcherOpen

    implicitWidth: 500
    implicitHeight: 400

    // Close on click outside
    HyprlandFocusGrab {
        id: focusGrab
        windows: [launcher]
        onCleared: GlobalStates.launcherOpen = false
    }

    color: Theme.mantle

    // Fade animation
    opacity: visible ? 1 : 0
    Behavior on opacity {
        NumberAnimation {
            duration: 150
            easing.type: Easing.OutCubic
        }
    }

    // Search bar
    Rectangle {
        id: searchBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 12
        height: 40
        radius: Theme.radius
        color: Theme.surface0
        border.color: searchInput.activeFocus ? Theme.primary : Theme.border
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8

            Text {
                text: ""
                color: Theme.fgDim
                font.pixelSize: 16
            }

            TextInput {
                id: searchInput
                Layout.fillWidth: true
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                focus: true

                onTextChanged: {
                    appList.currentIndex = 0
                }

                Keys.onReturnPressed: {
                    if (appList.currentItem) {
                        appList.currentItem.modelData.execute()
                        GlobalStates.launcherOpen = false
                    }
                }

                Keys.onEscapePressed: {
                    GlobalStates.launcherOpen = false
                }

                Keys.onDownPressed: {
                    if (appList.currentIndex < appList.count - 1) {
                        appList.currentIndex++
                    }
                }

                Keys.onUpPressed: {
                    if (appList.currentIndex > 0) {
                        appList.currentIndex--
                    }
                }
            }
        }
    }

    // App list
    ListView {
        id: appList
        anchors.top: searchBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 12
        spacing: 4
        clip: true
        currentIndex: 0

        model: filteredApps

        delegate: Rectangle {
            required property DesktopEntry modelData
            required property int index

            width: appList.width
            height: 44
            radius: Theme.radius / 2
            color: appList.currentIndex === index ? Theme.surface1 : "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                spacing: 12

                IconImage {
                    Layout.preferredWidth: 28
                    Layout.preferredHeight: 28
                    source: modelData.icon ? Quickshell.iconPath(modelData.icon, "") : ""
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Text {
                        Layout.fillWidth: true
                        text: modelData.name
                        color: Theme.fg
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        elide: Text.ElideRight
                    }

                    Text {
                        Layout.fillWidth: true
                        visible: modelData.genericName.length > 0
                        text: modelData.genericName
                        color: Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize - 2
                        elide: Text.ElideRight
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: appList.currentIndex = index
                onClicked: {
                    modelData.execute()
                    GlobalStates.launcherOpen = false
                }
            }
        }

        // Scrollbar
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }
    }

    // Filtered app list
    readonly property var filteredApps: {
        const query = searchInput.text.toLowerCase().trim()
        const entries = DesktopEntries.applications.values
        const result = []

        for (let i = 0; i < entries.length; i++) {
            const entry = entries[i]
            if (entry.noDisplay) continue

            if (query.length === 0 ||
                entry.name.toLowerCase().includes(query) ||
                entry.genericName.toLowerCase().includes(query) ||
                entry.id.toLowerCase().includes(query)) {
                result.push(entry)
            }
        }

        // Sort by name
        result.sort((a, b) => a.name.localeCompare(b.name))
        return result
    }

    // Reset search on open
    onVisibleChanged: {
        if (visible) {
            searchInput.text = ""
            searchInput.forceActiveFocus()
        }
    }
}
