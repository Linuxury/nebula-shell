// Nebula Bar — Clock with calendar tooltip

import QtQuick
import Quickshell

Item {
    id: clockRoot

    implicitWidth: clockText.implicitWidth + 16
    implicitHeight: 32

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    // Format: Friday, 20 Mar 2026  09:05 PM
    readonly property string timeText: {
        const d = clock.date
        const days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        const h = d.getHours() % 12 || 12
        const m = String(d.getMinutes()).padStart(2, "0")
        const ampm = d.getHours() >= 12 ? "PM" : "AM"
        return `${days[d.getDay()]}, ${d.getDate()} ${months[d.getMonth()]} ${d.getFullYear()}  ${h}:${m} ${ampm}`
    }

    Text {
        id: clockText
        anchors.centerIn: parent
        text: clockRoot.timeText
        color: Theme.fg
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
    }

    // Calendar tooltip on hover
    Rectangle {
        id: tooltip
        anchors.top: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 4
        width: 220
        height: calendarColumn.implicitHeight + 16
        radius: Theme.radius
        color: Theme.mantle
        border.color: Theme.border
        border.width: 1
        visible: mouseArea.containsMouse

        Column {
            id: calendarColumn
            anchors.centerIn: parent
            spacing: 8

            // Month/Year header
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: {
                    const d = clock.date
                    const months = ["January", "February", "March", "April", "May", "June",
                                    "July", "August", "September", "October", "November", "December"]
                    return months[d.getMonth()] + " " + d.getFullYear()
                }
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize + 2
                font.bold: true
            }

            // Day headers
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 4
                Repeater {
                    model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                    Text {
                        text: modelData
                        color: Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize - 2
                        width: 24
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            // Calendar grid
            Grid {
                anchors.horizontalCenter: parent.horizontalCenter
                columns: 7
                spacing: 4

                Repeater {
                    model: {
                        const d = clock.date
                        const firstDay = new Date(d.getFullYear(), d.getMonth(), 1).getDay()
                        const daysInMonth = new Date(d.getFullYear(), d.getMonth() + 1, 0).getDate()
                        const cells = []
                        for (let i = 0; i < firstDay; i++) cells.push(0)
                        for (let i = 1; i <= daysInMonth; i++) cells.push(i)
                        return cells
                    }

                    Text {
                        required property var modelData
                        text: modelData > 0 ? String(modelData) : ""
                        color: modelData === clock.date.getDate() ? Theme.primary : Theme.fg
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize - 1
                        font.bold: modelData === clock.date.getDate()
                        width: 24
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }
}
