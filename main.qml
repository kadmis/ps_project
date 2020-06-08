import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2

import helper 1.0
import deencryptor 1.0


ApplicationWindow {
    id: mainWindow
    title: "[De]Cryptist™"
    visible: true
    width: 800
    height: 600
    flags: Qt.Window | Qt.FramelessWindowHint
    color: "transparent"

    property bool isDark: false
    property bool isDehasher: false
    property int previousX
    property int previousY

    Material.theme: isDark ? Material.Dark : Material.Light
    Material.primary: isDark ? Material.Orange : Material.Purple
    Material.accent: isDark ? Material.DeepOrange : Material.Pink

    Rectangle {
            id: mainContent
            x: 10
            y: 10
            width: parent.width-20
            height: parent.height-20
            radius: 20
            color: Material.backgroundColor

            //mouse area w celu tracenia focusu po odkliknieciu w pola tekstowe
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    focus = true
                }
            }


            Switch {
                id: switchMode
                width: 140
                height: 35
                text: qsTr("Tryb")
                anchors.bottomMargin: 8
                anchors.leftMargin: 0
                anchors.rightMargin: 639
                anchors.topMargin: 525
                anchors.fill: parent

                onCheckedChanged: isDehasher=!isDehasher
            }

            Text {
                id: modeTitle
                anchors.rightMargin: 340
                anchors.bottomMargin: 447
                anchors.leftMargin: 341
                anchors.topMargin: 93
                text: isDehasher ? qsTr("Odszyfrowywanie") : qsTr("Szyfrowanie")
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 25

                color: Material.accent
            }

            Rectangle {
                id: menuBar
                color: Material.primaryColor
                height: 45
                width: parent.width
                radius: 10

                anchors.top: parent.top

                MouseArea {
                    id: dragMouseArea
                    layer.smooth: true
                    antialiasing: true
                    anchors.fill: parent

                    onPressed: {
                        previousX = mouseX
                        previousY = mouseY
                    }

                    onMouseXChanged: {
                        var dx = mouseX - previousX;
                        mainWindow.setX(mainWindow.x + dx);
                    }

                    onMouseYChanged: {
                        var dy = mouseY - previousY;
                        mainWindow.setY(mainWindow.y + dy);
                    }
                }

                Text {
                    id: title
                    textFormat: Text.RichText
                    text: qsTr(mainWindow.title)
                    font.pointSize: 12
                    anchors.verticalCenter: parent.verticalCenter
                    leftPadding: 8
                    color: isDark ? "black" : "white"
                    z:100
                    Material.elevation: 6
                    ToolTip.text: qsTr("Stworzone przez:\n-Kamil Adamus\n-Robert Sobala\nGrupa: IP30s3")
                    ToolTip.visible: titleMouseArea.containsMouse

                    MouseArea {
                        id: titleMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }

                RowLayout {
                    id: buttonsRow
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    spacing: 2
                    z:100

                    RoundButton {
                        id: minimizeButton
                        //scale: 0.7
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignRight
                        icon.source: "minimize.png"
                        icon.color: isDark ? "black" : "white"
                        Material.background: Material.accent

                        onClicked: mainWindow.showMinimized()
                    }

                    RoundButton {
                        id: closeButton
                        //scale: 0.7
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignRight
                        icon.source: "close.png"
                        icon.color: isDark ? "black" : "white"
                        Material.background: Material.Red

                        onClicked: mainWindow.close()
                    }
                }

                Rectangle {
                    color: Material.primaryColor
                    height: menuBar.radius
                    anchors.bottom: menuBar.bottom
                    anchors.left: menuBar.left
                    anchors.right: menuBar.right
                }
            }

            Switch {
                id: themeSwitcher
                x: 620
                y: 525
                width: 140
                height: 35
                text: qsTr("Ciemny motyw")
                checkable: true
                display: AbstractButton.TextBesideIcon
                anchors.rightMargin: 8
                anchors.bottomMargin: 8
                anchors.leftMargin: 619
                anchors.topMargin: 523
                anchors.fill: parent

                onCheckedChanged: isDark=!isDark
            }

            //pola tekstowe przechowujace nazwy plikow
            TextField {
                id: srcFileName
                y: 156
                height: 40
                anchors.right: parent.right
                anchors.rightMargin: 205
                anchors.left: parent.left
                anchors.leftMargin: 206
                placeholderText: qsTr("Nazwa pliku źródłowego")
                selectByMouse: true
            }

            TextField {
                id: dstFileName
                y: 227
                height: 40
                anchors.right: parent.right
                anchors.rightMargin: 205
                anchors.left: parent.left
                anchors.leftMargin: 206
                placeholderText: qsTr("Nazwa pliku docelowego")
                selectByMouse: true
            }

            //pola tekstowe przechowujace faktyczna sciezke do pliku
            Text {
                id: srcFileFullPath
                x: 8
                y: 558
                visible: false
                font.pixelSize: 12
            }

            Text {
                id: dstFolderPath
                x: 8
                y: 558
                visible: false
                font.pixelSize: 12
            }

            RoundButton {
                id: selectSrcFile
                y: 156
                height: 40
                text: qsTr("...")
                anchors.left: srcFileName.right
                anchors.leftMargin: 6
                anchors.right: parent.right
                anchors.rightMargin: 157
                Material.background: Material.accent
                Material.foreground: isDark ? "black" : "white"

                onClicked: {
                    srcFileDialog.open()
                }
            }

            RoundButton {
                id: selectDstFolder
                y: 227
                height: 40
                text: qsTr("...")
                anchors.left: srcFileName.right
                anchors.leftMargin: 6
                anchors.right: parent.right
                anchors.rightMargin: 157
                Material.background: Material.accent
                Material.foreground: isDark ? "black" : "white"

                onClicked: {
                    dstFileDialog.open()
                }
            }

            TextField {
                id: password
                y: 301
                height: 40
                anchors.right: parent.right
                anchors.rightMargin: 205
                anchors.left: parent.left
                anchors.leftMargin: 206
                placeholderText: qsTr("Hasło")
                selectByMouse: true

                echoMode: TextInput.Password

            }

            Button {
                id: executeBtn
                text: qsTr("Wykonaj")
                anchors.rightMargin: 340
                anchors.bottomMargin: 160
                anchors.leftMargin: 340
                anchors.topMargin: 380
                anchors.fill: parent

                Material.background: Material.accent
                Material.foreground: isDark ? "black" : "white"

                onClicked: {
                    let isDecrypt = switchMode.checked
                    busyIndicator.running = true

                    if(srcFileFullPath.text.toString().length==0 || dstFileName.text.toString().length==0) {
                        popupMessageText.text = "Nazwa pliku musi zawierać jeden lub więcej znaków"
                        popupTitle.text = "Błąd"
                        popupMessage.open()
                        busyIndicator.running = false
                    }
                    else {                        
                        let fullDstFilePath

                        if(dstFolderPath.text.toString().length>0) {
                            fullDstFilePath = dstFolderPath.text.toString().replace("file:///","").concat('/'+ dstFileName.text.toString())
                        }
                        else  {
                            fullDstFilePath = dstFileName.text.toString()
                        }

                        startDeencryption(srcFileFullPath.text.toString(),fullDstFilePath, password.text.toString(), isDecrypt)
                    }
                }
            }
    }

    FileDialog {
        id: srcFileDialog
        title: "Proszę wybrać plik źródłowy"

        onAccepted: {
            srcFileName.text = helper.getFileNameFromPath(srcFileDialog.fileUrl)
            srcFileFullPath.text = srcFileDialog.fileUrl
            this.close()
        }
    }

    FileDialog {
        id: dstFileDialog
        title: "Proszę wybrać folder dla pliku docelowego"
        selectFolder: true
        selectExisting: false

        onAccepted:  {
            dstFolderPath.text = dstFileDialog.folder
            this.close()
        }
    }

    BusyIndicator {
        id: busyIndicator
        width:100
        height:100
        x: parent.x + (parent.width - this.width)/2
        y: parent.y + (parent.height - this.height)/2
        running: false
    }

    Popup {
        id: popupMessage
        x: parent.x + (parent.width - this.width)/2
        y: parent.y + (parent.height - this.height)/2
        width: 400
        height: 150
        modal: true
        focus: true
        closePolicy: Popup.NoAutoClose

        Overlay.modal: Rectangle {
            radius:20
            color:"#aacfdbe7"
            width: 5
        }

        background: Rectangle {
            id: popUpMainContent
            radius:15
            color: Material.backgroundColor

            GridLayout {
                rows: 4
                columns: 1

                Rectangle {
                    radius:10
                    width:400
                    height:50
                    color: Material.primary

                    Text {
                        id: popupTitle
                        text:"Info"
                        font.pointSize: 16
                        color: isDark ? "black" : "white"
                        padding: 8
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Rectangle {
                        height: parent.radius
                        color: Material.primary
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                    }
                }

                Text {
                   id: popupMessageText
                   font.pointSize: 12
                   color: isDark ? "white" : "black"
                   padding: 8
                   Layout.alignment: Qt.AlignHCenter
                }

                Button {
                    id: okButton
                    text:qsTr("Ok")
                    onClicked: popupMessage.close()
                    Material.background: Material.accent
                    Material.foreground: isDark ? "black" : "white"
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    signal startDeencryption(string src, string dst, string pswd, bool isDecrypt)

    Connections {
        target: deencryptor
        onDeencryptionFinished: {
            busyIndicator.running = false
            popupTitle.text = isSuccess ? "Sukces" : "Błąd"
            popupMessageText.text = message
            popupMessage.open()
        }
    }


}





























