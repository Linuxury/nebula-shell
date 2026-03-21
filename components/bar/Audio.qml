// Nebula Bar — Audio volume controls

import QtQuick
import QtQuick.Layouts
import Quickshell
import "../.."
import Quickshell.Services.Pipewire

Item {
    id: audioRoot

    implicitWidth: audioRow.implicitWidth + 8
    implicitHeight: 32

    // Track default sink
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: sink ? sink.audio.volume : 0
    readonly property bool muted: sink ? sink.audio.muted : true

    readonly property string volumeIcon: {
        if (muted) return ""
        if (volume > 0.66) return ""
        if (volume > 0.33) return ""
        return ""
    }

    RowLayout {
        id: audioRow
        anchors.centerIn: parent
        spacing: 4

        // Volume icon (click to mute toggle)
        Text {
            text: audioRoot.volumeIcon
            color: audioRoot.muted ? Theme.error : Theme.fg
            font.pixelSize: 14

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (audioRoot.sink) {
                        audioRoot.sink.audio.muted = !audioRoot.sink.audio.muted
                    }
                }
            }
        }

        // Volume percentage
        Text {
            visible: !audioRoot.muted
            text: Math.round(audioRoot.volume * 100) + "%"
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize - 1
        }
    }
}
