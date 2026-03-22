// Event Horizon Panel — Sidebar / Control Center
// Phase 5: Brightness, audio, toggles, power profiles, dock, theme

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import qs.modules

Item {
    id: sidebarRoot

    property var screen

    // Visible when GlobalStates.sidebarOpen
    visible: GlobalStates.sidebarOpen

    implicitWidth: 320
    implicitHeight: sidebarContent.implicitHeight + 24

    // Focus grab to close on click outside
    HyprlandFocusGrab {
        id: sidebarFocus
        windows: [sidebarRoot.Window.window]
        onCleared: GlobalStates.sidebarOpen = false
    }

    // Background
    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: Theme.bg
        opacity: Theme.bgOpacity
        border.color: Theme.borderDim
        border.width: 1
    }

    // PwObjectTracker
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    // Content
    ColumnLayout {
        id: sidebarContent
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // === Header ===
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: Icons.getIcon("tune")
                color: Theme.primary
                font.family: Icons.fontFamily
                font.pixelSize: 20
            }

            Text {
                Layout.fillWidth: true
                text: "Control Center"
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
                    onClicked: GlobalStates.sidebarOpen = false
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

        // === Audio Slider ===
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: {
                        const sink = Pipewire.defaultAudioSink
                        const vol = sink ? sink.audio.volume : 0
                        const muted = sink ? sink.audio.muted : true
                        if (muted) return Icons.getIcon("volume_mute")
                        if (vol > 0.66) return Icons.getIcon("volume_up")
                        if (vol > 0.33) return Icons.getIcon("volume_down")
                        return Icons.getIcon("volume_off")
                    }
                    color: Theme.fg
                    font.family: Icons.fontFamily
                    font.pixelSize: 18
                }

                Text {
                    Layout.fillWidth: true
                    text: "Audio"
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }

                Text {
                    text: {
                        const sink = Pipewire.defaultAudioSink
                        const muted = sink ? sink.audio.muted : true
                        return muted ? "Muted" : Math.round((sink ? sink.audio.volume : 0) * 100) + "%"
                    }
                    color: Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize - 1
                }
            }

            // Volume slider
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 8
                radius: 4
                color: Theme.surface0

                Rectangle {
                    width: parent.width * (Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio.volume : 0)
                    height: parent.height
                    radius: 4
                    color: Theme.primary

                    Behavior on width {
                        NumberAnimation { duration: 100 }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: (mouse) => {
                        if (Pipewire.defaultAudioSink) {
                            Pipewire.defaultAudioSink.audio.volume = mouse.x / width
                        }
                    }
                }
            }
        }

        // === Brightness Slider ===
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: Icons.getIcon("brightness_high")
                    color: Theme.fg
                    font.family: Icons.fontFamily
                    font.pixelSize: 18
                }

                Text {
                    Layout.fillWidth: true
                    text: "Brightness"
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }

                Text {
                    text: Math.round(brightnessSlider.value * 100) + "%"
                    color: Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize - 1
                }
            }

            // Brightness slider
            Rectangle {
                id: brightnessSlider
                Layout.fillWidth: true
                Layout.preferredHeight: 8
                radius: 4
                color: Theme.surface0

                property real value: 0.8

                Rectangle {
                    width: parent.width * brightnessSlider.value
                    height: parent.height
                    radius: 4
                    color: Theme.tertiary

                    Behavior on width {
                        NumberAnimation { duration: 100 }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: (mouse) => {
                        brightnessSlider.value = Math.max(0.05, Math.min(1, mouse.x / width))
                    }
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

        // === Quick Toggles ===
        GridLayout {
            Layout.fillWidth: true
            columns: 4
            rowSpacing: 8
            columnSpacing: 8

            // Wi-Fi toggle
            ToggleButton {
                icon: Icons.getIcon("wifi")
                label: "Wi-Fi"
                checked: true
                Layout.fillWidth: true
            }

            // Bluetooth toggle
            ToggleButton {
                icon: Icons.getIcon("bluetooth")
                label: "Bluetooth"
                checked: true
                Layout.fillWidth: true
            }

            // Do Not Disturb
            ToggleButton {
                icon: Icons.getIcon("do_not_disturb_on")
                label: "DND"
                checked: GlobalStates.doNotDisturb
                onCheckedChanged: GlobalStates.doNotDisturb = checked
                Layout.fillWidth: true
            }

            // Night Light
            ToggleButton {
                icon: Icons.getIcon("dark_mode")
                label: "Night"
                checked: false
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

        // === Power Profiles ===
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: Icons.getIcon("speed")
                    color: Theme.fg
                    font.family: Icons.fontFamily
                    font.pixelSize: 18
                }

                Text {
                    Layout.fillWidth: true
                    text: "Power Profile"
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                PowerProfileButton {
                    icon: Icons.getIcon("bolt")
                    label: "Performance"
                    active: true
                    Layout.fillWidth: true
                }

                PowerProfileButton {
                    icon: Icons.getIcon("battery_full")
                    label: "Balanced"
                    active: false
                    Layout.fillWidth: true
                }

                PowerProfileButton {
                    icon: Icons.getIcon("battery_alert")
                    label: "Saver"
                    active: false
                    Layout.fillWidth: true
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

        // === Settings ===
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            // Dock toggle
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: Icons.getIcon("dashboard")
                    color: Theme.fg
                    font.family: Icons.fontFamily
                    font.pixelSize: 18
                }

                Text {
                    Layout.fillWidth: true
                    text: "Show Dock"
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }

                Switch {
                    checked: GlobalStates.dockVisible
                    onCheckedChanged: GlobalStates.dockVisible = checked
                }
            }

            // Theme toggle
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: Icons.getIcon("dark_mode")
                    color: Theme.fg
                    font.family: Icons.fontFamily
                    font.pixelSize: 18
                }

                Text {
                    Layout.fillWidth: true
                    text: "Dark Mode"
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }

                Switch {
                    checked: true
                    onCheckedChanged: {
                        // Toggle between light/dark theme
                    }
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

        // === System Stats ===
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: Icons.getIcon("memory")
                    color: Theme.fg
                    font.family: Icons.fontFamily
                    font.pixelSize: 18
                }

                Text {
                    Layout.fillWidth: true
                    text: "System"
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }
            }

            // CPU/RAM placeholder
            Text {
                Layout.fillWidth: true
                text: "CPU: --%  |  RAM: --%"
                color: Theme.fgDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize - 1
            }
        }
    }

    // Toggle button component
    component ToggleButton: Rectangle {
        property string icon: ""
        property string label: ""
        property bool checked: false

        height: 60
        radius: Theme.radius
        color: checked ? Theme.primary : Theme.surface0

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 2

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: icon
                color: checked ? Theme.bg : Theme.fg
                font.family: Icons.fontFamily
                font.pixelSize: 20
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: label
                color: checked ? Theme.bg : Theme.fgDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize - 2
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: checked = !checked
        }
    }

    // Power profile button component
    component PowerProfileButton: Rectangle {
        property string icon: ""
        property string label: ""
        property bool active: false

        height: 40
        radius: Theme.radius / 2
        color: active ? Theme.primary : Theme.surface0

        RowLayout {
            anchors.centerIn: parent
            spacing: 4

            Text {
                text: icon
                color: active ? Theme.bg : Theme.fg
                font.family: Icons.fontFamily
                font.pixelSize: 14
            }

            Text {
                text: label
                color: active ? Theme.bg : Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize - 1
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: active = !active
        }
    }

    // Simple switch component
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
