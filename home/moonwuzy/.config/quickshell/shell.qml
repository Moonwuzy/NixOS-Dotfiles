import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray

ShellRoot {
    id: root

    property string cpuUsage: "0"
    property string ramUsage: "0"
    property string networkStatus: "󰖩"
    property string currentTime: ""

    property var workspaceData: []

    property color walBackground: "#101515"
    property color walForeground: "#c3c4c4"
    property color walColor0: "#101515"
    property color walColor1: "#39689C"
    property color walColor4: "#8F6A99"

    function updateClock() {
        currentTime = Qt.formatDateTime(
            new Date(),
            "hh:mm AP dddd, MMM dd"
        )
    }

    function transparentColor(c, a) {
        return Qt.rgba(c.r, c.g, c.b, a)
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            root.updateClock()
        }
    }

    Process {
        id: walProcess

        command: [
            "cat",
            "/home/moonwuzy/.cache/wal/colors.json"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var data = JSON.parse(this.text)

                    if (data.special) {
                        if (data.special.background)
                            root.walBackground =
                                data.special.background

                        if (data.special.foreground)
                            root.walForeground =
                                data.special.foreground
                    }

                    if (data.colors) {
                        if (data.colors.color0)
                            root.walColor0 =
                                data.colors.color0

                        if (data.colors.color1)
                            root.walColor1 =
                                data.colors.color1

                        if (data.colors.color4)
                            root.walColor4 =
                                data.colors.color4
                    }
                } catch (e) {
                    console.log(
                        "Could not load Pywal colors:",
                        e
                    )
                }
            }
        }
    }

    Process {
        id: cpuProcess

        command: [
            "sh",
            "-c",
            "top -bn1 | awk '/Cpu\\(s\\)/ {printf \"%.0f\", 100-$8}'"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                var value = this.text.trim()

                if (value !== "")
                    root.cpuUsage = value
            }
        }
    }

    Process {
        id: ramProcess

        command: [
            "sh",
            "-c",
            "free | awk '/Mem:/ {printf \"%.0f\", ($3/$2)*100}'"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                var value = this.text.trim()

                if (value !== "")
                    root.ramUsage = value
            }
        }
    }

    Process {
        id: networkProcess

        command: [
            "sh",
            "-c",
            "if ip route get 1.1.1.1 >/dev/null 2>&1; then if iwgetid -r >/dev/null 2>&1; then printf '󰖩'; else printf '󰈀'; fi; else printf '󰖪'; fi"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                var value = this.text.trim()

                if (value !== "")
                    root.networkStatus = value
            }
        }
    }

    Process {
        id: workspaceProcess

        command: [
            "swaymsg",
            "-t",
            "get_workspaces",
            "-r"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var data = JSON.parse(this.text)
                    root.workspaceData = data
                } catch (e) {
                    console.log(
                        "Could not read Sway workspaces:",
                        e
                    )
                }
            }
        }
    }

    Component.onCompleted: {
        walProcess.running = true
        cpuProcess.running = true
        ramProcess.running = true
        networkProcess.running = true
        workspaceProcess.running = true
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            cpuProcess.running = false
            cpuProcess.running = true

            ramProcess.running = false
            ramProcess.running = true

            networkProcess.running = false
            networkProcess.running = true

            workspaceProcess.running = false
            workspaceProcess.running = true
        }
    }

    PwObjectTracker {
        id: audioTracker

        objects: [
            Pipewire.defaultAudioSink
        ]
    }

    PanelWindow {
        id: bar

        anchors.top: true
        anchors.left: true
        anchors.right: true

        margins.top: 6
        margins.left: 8
        margins.right: 8

        implicitHeight: 30
        exclusiveZone: 36

        color: "transparent"

        Rectangle {
            anchors.fill: parent

            color: root.transparentColor(
                root.walBackground,
                0.75
            )

            border.color: root.walColor0
            border.width: 1
            radius: 18

            Row {
                anchors.fill: parent

                anchors.leftMargin: 8
                anchors.rightMargin: 8

                spacing: 6

                Row {
                    id: leftSide

                    anchors.verticalCenter:
                        parent.verticalCenter

                    spacing: 6

                    Text {
                        text: "   iloveyaoi"

                        color:
                            root.walForeground

                        font.family:
                            "JetBrainsMono Nerd Font"

                        font.pixelSize: 15

                        verticalAlignment:
                            Text.AlignVCenter
                    }

                    Row {
                        spacing: 2

                        Repeater {
                            model:
                                root.workspaceData

                            Rectangle {
                                width: 34
                                height: 24

                                radius: 8

                                color: "transparent"

                                property bool isFocused:
                                    modelData.focused

                                Text {
                                    anchors.centerIn:
                                        parent

                                    text:
                                        modelData.name

                                    color:
                                        parent.isFocused
                                        ? root.walColor4
                                        : root.walForeground

                                    font.family:
                                        "JetBrainsMono Nerd Font"

                                    font.pixelSize: 15

                                    font.bold:
                                        parent.isFocused
                                }

                                MouseArea {
                                    anchors.fill:
                                        parent

                                    onClicked: {
                                        Quickshell.execDetached([
                                            "swaymsg",
                                            "workspace",
                                            String(
                                                modelData.name
                                            )
                                        ])
                                    }
                                }
                            }
                        }
                    }
                }

                Item {
                    anchors.verticalCenter:
                        parent.verticalCenter

                    width:
                        parent.width
                        - leftSide.width
                        - rightSide.width
                        - 12

                    height:
                        parent.height

                    Text {
                        anchors.centerIn:
                            parent

                        text:
                            root.currentTime

                        color:
                            root.walForeground

                        font.family:
                            "JetBrainsMono Nerd Font"

                        font.pixelSize: 15
                    }
                }

                Row {
                    id: rightSide

                    anchors.verticalCenter:
                        parent.verticalCenter

                    spacing: 14

                    Text {
                        text:
                            "cpu "
                            + root.cpuUsage
                            + "% "

                        color:
                            root.walForeground

                        font.family:
                            "JetBrainsMono Nerd Font"

                        font.pixelSize: 15
                    }

                    Text {
                        text:
                            "ram "
                            + root.ramUsage
                            + "% "

                        color:
                            root.walForeground

                        font.family:
                            "JetBrainsMono Nerd Font"

                        font.pixelSize: 15
                    }

                    Text {
                        text:
                            root.networkStatus

                        color:
                            root.walForeground

                        font.family:
                            "JetBrainsMono Nerd Font"

                        font.pixelSize: 17
                    }

                    Text {
                        text:
                            "󰋖"

                        color:
                            root.walForeground

                        font.family:
                            "JetBrainsMono Nerd Font"

                        font.pixelSize: 17

                        MouseArea {
                            anchors.fill:
                                parent

                            onClicked: {
                                Quickshell.execDetached([
                                    "/home/moonwuzy/.config/wofi/help.sh"
                                ])
                            }
                        }
                    }

                    Text {
                        property var sink:
                            Pipewire.defaultAudioSink

                        text: {
                            if (
                                !sink
                                || !sink.audio
                            )
                                return "󰖁"

                            if (sink.audio.muted)
                                return "󰖁 muted"

                            return "󰕾 "
                                + Math.min(
                                    100,
                                    Math.round(
                                        sink.audio.volume
                                        * 100
                                    )
                                )
                                + "%"
                        }

                        color:
                            root.walForeground

                        font.family:
                            "JetBrainsMono Nerd Font"

                        font.pixelSize: 15

                        MouseArea {
                            anchors.fill:
                                parent

                            onClicked: {
                                Quickshell.execDetached([
                                    "pavucontrol"
                                ])
                            }
                        }
                    }

                    Text {
                        property var battery:
                            UPower.displayDevice

                        text: {
                            if (
                                !battery
                                || !battery.ready
                            )
                                return "󰂑"

                            var p =
                                Math.round(
                                    battery.percentage
                                )

                            if (
                                battery.state
                                === UPowerDeviceState.Charging
                            )
                                return "󰂄 "
                                    + p
                                    + "%"

                            if (p >= 90)
                                return "󰁹 "
                                    + p
                                    + "%"

                            if (p >= 70)
                                return "󰂀 "
                                    + p
                                    + "%"

                            if (p >= 50)
                                return "󰁾 "
                                    + p
                                    + "%"

                            if (p >= 30)
                                return "󰁼 "
                                    + p
                                    + "%"

                            if (p >= 10)
                                return "󰁺 "
                                    + p
                                    + "%"

                            return "󰂃 "
                                + p
                                + "%"
                        }

                        color:
                            root.walForeground

                        font.family:
                            "JetBrainsMono Nerd Font"

                        font.pixelSize: 15
                    }

                    Text {
                        text:
                            "󰃠"

                        color:
                            root.walForeground

                        font.family:
                            "JetBrainsMono Nerd Font"

                        font.pixelSize: 17

                        MouseArea {
                            anchors.fill:
                                parent

                            onClicked: {
                                Quickshell.execDetached([
                                    "brightnessctl",
                                    "set",
                                    "5%+"
                                ])
                            }

                            onWheel:
                                function(wheel) {
                                    if (
                                        wheel.angleDelta.y
                                        > 0
                                    ) {
                                        Quickshell.execDetached([
                                            "brightnessctl",
                                            "set",
                                            "5%+"
                                        ])
                                    } else {
                                        Quickshell.execDetached([
                                            "brightnessctl",
                                            "set",
                                            "5%-"
                                        ])
                                    }
                                }
                        }
                    }

                    Text {
                        text:
                            "⏻"

                        color:
                            root.walForeground

                        font.family:
                            "JetBrainsMono Nerd Font"

                        font.pixelSize: 17

                        MouseArea {
                            anchors.fill:
                                parent

                            onClicked: {
                                Quickshell.execDetached([
                                    "/run/current-system/sw/bin/wlogout"
                                ])
                            }
                        }
                    }

                    Row {
                        id: trayRow

                        spacing: 10

                        Repeater {
                            model:
                                SystemTray.items

                            delegate: Item {
                                id: trayItem

                                width: 24
                                height: 24

                                Image {
                                    anchors.fill:
                                        parent

                                    source:
                                        modelData.icon

                                    sourceSize.width: 24
                                    sourceSize.height: 24

                                    fillMode:
                                        Image.PreserveAspectFit

                                    smooth: true
                                }

                                MouseArea {
                                    id: trayMouseArea

                                    anchors.fill:
                                        parent

                                    acceptedButtons:
                                        Qt.LeftButton
                                        | Qt.RightButton
                                        | Qt.MiddleButton

                                    hoverEnabled: true

                                    onPressed:
                                        function(mouse) {
                                            mouse.accepted = true
                                        }

                                    onClicked:
                                        function(mouse) {
                                            mouse.accepted = true

                                            if (
                                                mouse.button
                                                === Qt.RightButton
                                            ) {
                                                if (
                                                    modelData.hasMenu
                                                ) {
                                                    modelData.display(
                                                        bar,
                                                        mouse.x,
                                                        mouse.y
                                                    )
                                                }

                                                return
                                            }

                                            if (
                                                mouse.button
                                                === Qt.LeftButton
                                            ) {
                                                if (
                                                    modelData.onlyMenu
                                                ) {
                                                    if (
                                                        modelData.hasMenu
                                                    ) {
                                                        modelData.display(
                                                            bar,
                                                            mouse.x,
                                                            mouse.y
                                                        )
                                                    }
                                                } else {
                                                    modelData.activate()
                                                }

                                                return
                                            }

                                            if (
                                                mouse.button
                                                === Qt.MiddleButton
                                            ) {
                                                modelData.secondaryActivate()
                                            }
                                        }

                                    onWheel:
                                        function(wheel) {
                                            modelData.scroll(
                                                wheel.angleDelta.y,
                                                wheel.angleDelta.x !== 0
                                            )
                                        }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
