// Event Horizon — Lock Screen Component
// Phase 7: Clock, date, password, user avatar, unlock

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.modules

Item {
    id: lockScreen

    property var screen

    // Visible when GlobalStates.lockScreenOpen
    visible: GlobalStates.lockScreenOpen

    // Full screen overlay
    anchors.fill: parent

    // Fade animation
    opacity: visible ? 1 : 0
    Behavior on opacity {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    // Focus the password input
    onVisibleChanged: {
        if (visible) {
            passwordInput.forceActiveFocus()
            passwordInput.text = ""
            unlockTimer.stop()
        }
    }

    // Background with blur effect (simulated with dark overlay)
    Rectangle {
        anchors.fill: parent
        color: Theme.mantle
        opacity: 0.95
    }

    // Background pattern
    Rectangle {
        anchors.fill: parent
        color: "transparent"

        // Subtle grid pattern
        Grid {
            anchors.centerIn: parent
            columns: 20
            rows: 12
            spacing: 40

            Repeater {
                model: 240

                Rectangle {
                    width: 2
                    height: 2
                    radius: 1
                    color: Theme.surface1
                    opacity: 0.3
                }
            }
        }
    }

    // Main content (centered)
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 24

        // Clock
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 4

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: {
                    const d = new Date()
                    const h = String(d.getHours()).padStart(2, "0")
                    const m = String(d.getMinutes()).padStart(2, "0")
                    return h + ":" + m
                }
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: 72
                font.bold: true
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: {
                    const d = new Date()
                    const days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
                    const months = ["January", "February", "March", "April", "May", "June",
                                    "July", "August", "September", "October", "November", "December"]
                    return days[d.getDay()] + ", " + months[d.getMonth()] + " " + d.getDate()
                }
                color: Theme.fgDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize + 2
            }
        }

        // Spacer
        Item { Layout.preferredHeight: 40 }

        // User avatar placeholder
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 80
            height: 80
            radius: 40
            color: Theme.surface1
            border.color: Theme.primary
            border.width: 2

            Text {
                anchors.centerIn: parent
                text: Icons.getIcon("person")
                color: Theme.fgDim
                font.family: Icons.fontFamily
                font.pixelSize: 36
            }
        }

        // Username
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Quickshell.env("USER") || "user"
            color: Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize + 4
            font.bold: true
        }

        // Password input
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 300
            Layout.preferredHeight: 44
            radius: Theme.radius
            color: Theme.surface0
            border.color: passwordInput.activeFocus ? Theme.primary : Theme.borderDim
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                Text {
                    text: Icons.getIcon("lock")
                    color: Theme.fgDim
                    font.family: Icons.fontFamily
                    font.pixelSize: 18
                }

                TextInput {
                    id: passwordInput
                    Layout.fillWidth: true
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    echoMode: TextInput.Password
                    passwordCharacter: " "

                    onAccepted: {
                        unlockProcess.running = true
                    }

                    Keys.onEscapePressed: {
                        GlobalStates.lockScreenOpen = false
                    }
                }

                Text {
                    text: passwordInput.text.length > 0 ? Icons.getIcon("visibility") : ""
                    color: Theme.fgDim
                    font.family: Icons.fontFamily
                    font.pixelSize: 18

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            passwordInput.echoMode = passwordInput.echoMode === TextInput.Password
                                ? TextInput.Normal
                                : TextInput.Password
                        }
                    }
                }
            }
        }

        // Unlock button
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 300
            Layout.preferredHeight: 44
            radius: Theme.radius
            color: Theme.primary
            visible: passwordInput.text.length > 0

            RowLayout {
                anchors.centerIn: parent
                spacing: 8

                Text {
                    text: Icons.getIcon("lock_open")
                    color: Theme.bg
                    font.family: Icons.fontFamily
                    font.pixelSize: 18
                }

                Text {
                    text: "Unlock"
                    color: Theme.bg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.bold: true
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    unlockProcess.running = true
                }
            }
        }

        // Status message
        Text {
            Layout.alignment: Qt.AlignHCenter
            visible: unlockTimer.running
            text: "Incorrect password"
            color: Theme.error
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize - 1
        }
    }

    // Bottom hints
    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        spacing: 8

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 24

            // Power menu hint
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: Icons.getIcon("power_settings_new")
                    color: Theme.fgDim
                    font.family: Icons.fontFamily
                    font.pixelSize: 20
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Power"
                    color: Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize - 2
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Process.exec(["bash", Quickshell.shellPath("scripts/powermenu.sh")])
                    }
                }
            }

            // Switch user hint
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: Icons.getIcon("switch_account")
                    color: Theme.fgDim
                    font.family: Icons.fontFamily
                    font.pixelSize: 20
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Switch User"
                    color: Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize - 2
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // Switch user logic
                    }
                }
            }
        }

        // Hint text
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Press Escape to close • Enter to unlock"
            color: Theme.borderDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize - 2
        }
    }

    // Unlock process (uses pam to verify password)
    Process {
        id: unlockProcess
        command: ["sh", "-c", "echo '" + passwordInput.text + "' | sudo -S true 2>/dev/null"]

        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                // Unlock successful
                GlobalStates.lockScreenOpen = false
            } else {
                // Unlock failed
                unlockTimer.restart()
                passwordInput.text = ""
                passwordInput.forceActiveFocus()
            }
        }
    }

    // Error display timer
    Timer {
        id: unlockTimer
        interval: 3000
        repeat: false
    }

    // Update clock every second
    Timer {
        interval: 1000
        running: lockScreen.visible
        repeat: true
        onTriggered: {
            // Force clock update
            lockScreen.visible = lockScreen.visible
        }
    }
}
