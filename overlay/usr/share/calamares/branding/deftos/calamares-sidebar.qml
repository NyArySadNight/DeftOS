/* DeftOS Calamares sidebar.
 * Chi dung cac thanh phan QML co ban de khong phu thuoc vao bien noi bo cua Calamares.
 */

import QtQuick

Rectangle {
    id: sidebar
    color: "#1a1a2e"

    Column {
        anchors.centerIn: parent
        spacing: 12

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "DeftOS"
            color: "#00CED1"
            font.pixelSize: 28
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Installer"
            color: "#FFFFFF"
            font.pixelSize: 14
        }
    }
}
