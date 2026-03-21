// Nebula Bar — Media Player Controls (conditional, only when playing)

import QtQuick
import QtQuick.Layouts
import Quickshell
import "../.."
import Quickshell.Services.Mpris

Item {
    id: mediaRoot

    implicitWidth: mediaRow.implicitWidth + 8
    implicitHeight: 32

    // Find first playing player
    readonly property var activePlayer: {
        const players = Mpris.players.values
        for (let i = 0; i < players.length; i++) {
            if (players[i].isPlaying) return players[i]
        }
        // Fallback: any player
        return players.length > 0 ? players[0] : null
    }

    // Only show when something is playing
    visible: activePlayer !== null

    RowLayout {
        id: mediaRow
        anchors.centerIn: parent
        spacing: 4

        // Previous
        Text {
            text: ""
            color: Theme.fgDim
            font.pixelSize: 12

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (mediaRoot.activePlayer) mediaRoot.activePlayer.previous()
                }
            }
        }

        // Play/Pause
        Text {
            text: mediaRoot.activePlayer && mediaRoot.activePlayer.isPlaying ? " " : " "
            color: Theme.fg
            font.pixelSize: 14

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (mediaRoot.activePlayer) mediaRoot.activePlayer.togglePlaying()
                }
            }
        }

        // Next
        Text {
            text: ""
            color: Theme.fgDim
            font.pixelSize: 12

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (mediaRoot.activePlayer) mediaRoot.activePlayer.next()
                }
            }
        }

        // Track info (truncated)
        Text {
            Layout.maximumWidth: 150
            visible: mediaRoot.activePlayer
            text: {
                if (!mediaRoot.activePlayer) return ""
                const title = mediaRoot.activePlayer.trackTitle || ""
                const artist = mediaRoot.activePlayer.trackArtist || ""
                if (artist) return artist + " — " + title
                return title
            }
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize - 1
            elide: Text.ElideRight
        }
    }
}
