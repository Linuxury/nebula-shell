// Nebula Screenshot — Screenshot tool
// Phase 8: Selection, full screen, window capture

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.modules

Item {
    id: screenshotRoot

    property var screen

    // Visible when GlobalStates.screenshotOpen
    visible: GlobalStates.screenshotOpen

    implicitWidth: 400
    implicitHeight: 200

    // Background
    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: Theme.bg
        opacity: Theme.bgOpacity
        border.color: Theme.borderDim
        border.width: 1
    }

    // Content
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: Icons.getIcon("photo_camera")
                color: Theme.primary
                font.family: Icons.fontFamily
                font.pixelSize: 20
            }

            Text {
                Layout.fillWidth: true
                text: "Screenshot"
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize + 2
                font.bold: true
            }

            Text {
                text: Icons.getIcon("close")
                color: Theme.fgDim
                font.family: Icons.fontFamily
                font.pixelSize: 18

                MouseArea {
                    anchors.fill: parent
                    onClicked: GlobalStates.screenshotOpen = false
                }
            }
        }

        // Separator
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Theme.borderDim
            opacity: 0.5
        }

        // Screenshot options
        GridLayout {
            Layout.fillWidth: true
            columns: 3
            rowSpacing: 8
            columnSpacing: 8

            // Full screen
            ScreenshotButton {
                icon: Icons.getIcon("fullscreen")
                label: "Full Screen"
                onClicked: {
                    takeScreenshot("full")
                    GlobalStates.screenshotOpen = false
                }
                Layout.fillWidth: true
            }

            // Selection
            ScreenshotButton {
                icon: Icons.getIcon("crop")
                label: "Selection"
                onClicked: {
                    takeScreenshot("selection")
                    GlobalStates.screenshotOpen = false
                }
                Layout.fillWidth: true
            }

            // Window
            ScreenshotButton {
                icon: Icons.getIcon("desktop_windows")
                label: "Window"
                onClicked: {
                    takeScreenshot("window")
                    GlobalStates.screenshotOpen = false
                }
                Layout.fillWidth: true
            }
        }

        // Separator
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Theme.borderDim
            opacity: 0.5
        }

        // Options
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            // Copy to clipboard toggle
            RowLayout {
                spacing: 4

                Text {
                    text: Icons.getIcon("content_copy")
                    color: Theme.fg
                    font.family: Icons.fontFamily
                    font.pixelSize: 16
                }

                Text {
                    text: "Copy to clipboard"
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize - 1
                }

                Switch {
                    checked: copyToClipboard
                    onCheckedChanged: copyToClipboard = checked
                }
            }

            Item { Layout.fillWidth: true }

            // Delay slider
            RowLayout {
                spacing: 4

                Text {
                    text: Icons.getIcon("timer")
                    color: Theme.fg
                    font.family: Icons.fontFamily
                    font.pixelSize: 16
                }

                Text {
                    text: "Delay: " + delaySeconds + "s"
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize - 1
                }

                Rectangle {
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 6
                    radius: 3
                    color: Theme.surface0

                    Rectangle {
                        width: parent.width * (delaySeconds / 5)
                        height: parent.height
                        radius: 3
                        color: Theme.primary

                        MouseArea {
                            anchors.fill: parent
                            onClicked: (mouse) => {
                                delaySeconds = Math.round((mouse.x / width) * 5)
                            }
                        }
                    }
                }
            }
        }
    }

    // State
    property bool copyToClipboard: true
    property int delaySeconds: 0

    // Take screenshot function
    function takeScreenshot(mode) {
        let delay = delaySeconds > 0 ? `sleep ${delaySeconds} && ` : ""
        let clipboard = copyToClipboard ? " | wl-copy" : ""
        let filename = `~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png`

        // Create screenshots directory if it doesn't exist
        Quickshell.execDetached(["mkdir", "-p", "~/Pictures/Screenshots"])

        let cmd = ""
        switch(mode) {
            case "full":
                cmd = `${delay}grim ${filename}${clipboard}`
                break
            case "selection":
                cmd = `${delay}grim -g "$(slurp)" ${filename}${clipboard}`
                break
            case "window":
                cmd = `${delay}grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" ${filename}${clipboard}`
                break
        }

        Quickshell.execDetached(["sh", "-c", cmd])
    }

    // Screenshot button component
    component ScreenshotButton: Rectangle {
        property string icon: ""
        property string label: ""
        signal clicked()

        height: 60
        radius: Theme.radius
        color: mouseArea.containsMouse ? Theme.surface1 : Theme.surface0

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 4

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: icon
                color: Theme.fg
                font.family: Icons.fontFamily
                font.pixelSize: 24
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: label
                color: Theme.fgDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize - 1
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: parent.clicked()
        }
    }

    // Simple switch component (same as Sidebar)
    component Switch: Rectangle {
        property bool checked: false

        width: 40
        height: 20
        radius: 10
        color: checked ? Theme.primary : Theme.surface0

        Rectangle {
            width: 16
            height: 16
            radius: 8
            color: Theme.fg
            anchors.verticalCenter: parent.verticalCenter
            x: checked ? parent.width - width - 2 : 2

            Behavior on x {
                NumberAnimation { duration: 150 }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: checked = !checked
        }
    }
}
