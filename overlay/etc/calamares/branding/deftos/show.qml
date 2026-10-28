import QtQuick

Item {
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: "#1a1a1a"

        Text {
            anchors.centerIn: parent
            text: "Welcome to DeftOS!"
            font.pixelSize: 48
            font.bold: true
            color: "#FF1744"
        }

        Text {
            anchors.top: parent.top
            anchors.topMargin: 100
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Installing DeftOS..."
            font.pixelSize: 24
            color: "#ffffff"
        }
    }
}
