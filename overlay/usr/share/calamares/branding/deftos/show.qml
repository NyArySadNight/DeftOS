/* Calamares Slideshow - DeftOS Installation Slideshow
 *
 * This is a QML file that shows a welcome slide during installation.
 */

import QtQuick
import org.kde.kirigami as Kirigami

Rectangle {
    id: root

    color: "#1a1a2e"
    width: 800
    height: 600

    Column {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 30

        Item { height: 40 }

        Text {
            width: parent.width
            text: "Welcome to DeftOS!"
            color: "#00CED1"
            font.pixelSize: 48
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
        }

        Text {
            width: parent.width
            text: "DeftOS: A High-Performance Arch-based Linux Distribution"
            color: "#FFFFFF"
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
        }

        Item { height: 20 }

        Text {
            width: parent.width
            text: "Powered by Performance & Innovation\n\n" +
                  "• KDE Plasma 6 Desktop\n" +
                  "• Optimized Performance\n" +
                  "• Secure & Reliable\n" +
                  "• Calamares Installer\n" +
                  "• Snapper Snapshots"
            color: "#CCCCCC"
            font.pixelSize: 16
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            lineHeight: 1.8
        }

        Item { height: 40 }

        Text {
            width: parent.width
            text: "Installation in progress..."
            color: "#00CED1"
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
        }
    }
}
