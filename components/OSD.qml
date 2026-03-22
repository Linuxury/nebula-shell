// Pulsar Pills — OSD Component
// Phase 4: Volume/brightness pill, auto-dismiss

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import qs.modules

Item {
    id: osdRoot

    property var screen

    implicitWidth: 250
    implicitHeight: 60

    // Track volume changes
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: sink ? sink.audio.volume : 0
    readonly property bool muted: sink ? sink.audio.muted : true

    // Previous volume for change detection
    property real lastVolume: -1

    // Show OSD when volume changes
    visible: osdTimer.running

    // Track volume changes
    onVolumeChanged: {
        if (Math.abs(volume - lastVolume) > 0.01) {
            lastVolume = volume
            osdTimer.restart()
        }
    }

    onMutedChanged: {
        osdTimer.restart()
    }

    // Auto-dismiss timer
    Timer {
        id: osdTimer
        interval: 2000
        repeat: false
    }

    // PwObjectTracker
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    // OSD pill background
    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: Theme.bg
        opacity: Theme.bgOpacity
        border.color: Theme.borderDim
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12

            // Volume icon
            Text {
                text: {
                    if (muted) return Icons.getIcon("volume_mute")
                    if (volume > 0.66) return Icons.getIcon("volume_up")
                    if (volume > 0.33) return Icons.getIcon("volume_down")
                    if (volume > 0) return Icons.getIcon("volume_off")
                    return Icons.getIcon("volume_off")
                }
                color: muted ? Theme.error : Theme.fg
                font.family: Icons.fontFamily
                font.pixelSize: 22
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                // Volume percentage
                Text {
                    Layout.fillWidth: true
                    text: muted ? "Muted" : Math.round(volume * 100) + "%"
                    color: muted ? Theme.error : Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    horizontalAlignment: Text.AlignHCenter
                }

                // Volume bar
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 6
                    radius: 3
                    color: Theme.surface0

                    Rectangle {
                        width: parent.width * (muted ? 0 : volume)
                        height: parent.height
                        radius: 3
                        color: muted ? Theme.error : Theme.primary

                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }
        }

        // Slide in animation
        NumberAnimation on opacity {
            from: 0
            to: 1
            duration: 150
            easing.type: Easing.OutCubic
        }
    }
}
