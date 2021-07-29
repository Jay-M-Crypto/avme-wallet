/* Copyright (c) 2020-2021 AVME Developers
   Distributed under the MIT/X11 software license, see the accompanying
   file LICENSE or http://www.opensource.org/licenses/mit-license.php. */
import QtQuick 2.9
import QtQuick.Controls 2.2

import "qrc:/qml/components"
import "qrc:/qml/popups"

/**
 * Header that shows the current Account and stores details about it
 * (e.g. balances, QR code, buttons for changing Account/Wallet, etc.)
 */
Rectangle {
  id: accountHeader
  property string currentAddress
  property var coinBalance
  property var coinValue
  property var coinPrice
  property var tokenList: ({})
  height: 50
  color: "transparent"
  radius: 10

  Timer { id: addressTimer; interval: 2000 }
  Timer { id: balancesTimer; interval: 5000; repeat: true; onTriggered: refreshBalances() }
  Timer { id: ledgerRetryTimer; interval: 250; onTriggered: checkLedger() }

  Connections {
    target: QmlSystem
    function onAccountAVAXBalancesUpdated(address, avaxBalance, avaxValue, avaxPrice) {
      if (address == currentAddress) {
        coinBalance = avaxBalance
        coinValue = avaxValue
        coinPrice = avaxPrice
        // Uncomment to see data
        //console.log("Coin")
        //console.log("Balance: " + coinBalance)
        //console.log("USD Value: " + coinValue)
      }
    }
    function onAccountTokenBalancesUpdated(address, tokenAddress, tokenSymbol, tokenBalance, tokenValue, tokenDerivedValue) {
      if (address == currentAddress) {
        var tokenInformation = ({})
        tokenInformation["balance"] = tokenBalance
        tokenInformation["value"] = tokenValue
        tokenInformation["derivedValue"] = tokenDerivedValue
        tokenInformation["symbol"] = tokenSymbol
        tokenList[tokenAddress] = tokenInformation
        // Uncomment to see data
        //for (var token in tokenList) {
        //  console.log("Token")
        //  console.log("Address: ", token)
        //  console.log("Symbol: ", tokenList[token]["symbol"])
        //  console.log("Balance: ", tokenList[token]["balance"])
        //  console.log("USD Value: ", tokenList[token]["value"])
        //  console.log("Derived Value: ", tokenList[token]["derivedValue"])
        //}
      }
    }
  }

  function getAddress() {
    currentAddress = QmlSystem.getCurrentAccount()
    refreshBalances()
    balancesTimer.start()
  }

  function refreshBalances() {
    QmlSystem.getAccountAVAXBalances(currentAddress)
    QmlSystem.getAccountTokenBalances(currentAddress)
  }

  function checkLedger() {
    var data = QmlSystem.checkForLedger()
    if (data.state) {
      ledgerFailPopup.close()
      ledgerRetryTimer.stop()
      ledgerPopup.open()
    } else {
      ledgerFailPopup.info = data.message
      ledgerFailPopup.open()
      ledgerRetryTimer.start()
    }
  }

  function qrEncode() {
    qrcodePopup.qrModel.clear()
    var qrData = QmlSystem.getQRCodeFromAddress(currentAddress)
    for (var i = 0; i < qrData.length; i++) {
      qrcodePopup.qrModel.set(i, JSON.parse(qrData[i]))
    }
  }

  Rectangle {
    id: qrCodeRect
    anchors {
      top: parent.top
      left: parent.left
      leftMargin: 10
      verticalCenter: parent.verticalCenter
    }
    color: "transparent"
    radius: 5
    height: addressText.height
    width: height

    Image {
      id: qrCodeImage
      anchors.centerIn: parent
      height: parent.height * 0.8
      width: parent.width * 0.8
      fillMode: Image.PreserveAspectFit
      antialiasing: true
      smooth: true
      source: "qrc:/img/icons/qrcode.png"
    }
    MouseArea {
      id: qrCodeMouseArea
      anchors.fill: parent
      hoverEnabled: true
      onEntered: {
        parent.color = "#3F434C"
        qrCodeImage.source = "qrc:/img/icons/qrcodeSelect.png"
      }
      onExited: {
        parent.color = "transparent"
        qrCodeImage.source = "qrc:/img/icons/qrcode.png"
      }
      onClicked: {
        qrEncode()
        qrcodePopup.open()
      }
    }
  }

  Rectangle {
    id: copyClipRect
    anchors {
      top: parent.top
      left: qrCodeRect.right
      leftMargin: 10
      verticalCenter: parent.verticalCenter
    }
    enabled: (!addressTimer.running)
    color: "transparent"
    radius: 5
    height: addressText.height
    width: height

    Image {
      id: copyClipImage
      anchors.centerIn: parent
      height: parent.height * 0.8
      width: parent.width * 0.8
      fillMode: Image.PreserveAspectFit
      antialiasing: true
      smooth: true
      source: "qrc:/img/icons/Icon_Clipboard.png"
    }
    MouseArea {
      id: copyClipMouseArea
      anchors.fill: parent
      hoverEnabled: true
      onEntered: {
        parent.color = "#3F434C"
        copyClipImage.source = "qrc:/img/icons/Icon_Clipboard_On.png"
      }
      onExited: {
        parent.color = "transparent"
        copyClipImage.source = "qrc:/img/icons/Icon_Clipboard.png"
      }
      onClicked: {
        QmlSystem.copyToClipboard(currentAddress)
        addressTimer.start()
      }
    }
  }

  Text {
    id: addressText
    anchors {
      verticalCenter: parent.verticalCenter
      left: copyClipRect.right
      leftMargin: 10
    }
    color: "#FFFFFF"
    text: (!addressTimer.running) ? currentAddress : "Copied to clipboard!"
    font.bold: true
    font.pixelSize: 17.0

    Rectangle {
      id: addressRect
      anchors.fill: parent
      anchors.margins: -10
      color: "transparent"
      z: parent.z - 1
      radius: 5
      MouseArea {
        id: addressMouseArea
        anchors.fill: parent
        hoverEnabled: true
        enabled: (!addressTimer.running)
        onEntered: parent.color = "#3F434C"
        onExited: parent.color = "transparent"
        onClicked: {
          parent.color = "transparent"
          QmlSystem.copyToClipboard(currentAddress)
          addressTimer.start()
        }
      }
    }
  }

  AVMEButton {
    id: btnChangeAccount
    width: parent.width * 0.15
    anchors {
      verticalCenter: parent.verticalCenter
      right: btnChangeWallet.left
      rightMargin: 10
    }
    text: "Change Account"
    onClicked: {
      if (QmlSystem.getLedgerFlag()) {
        checkLedger()
      } else {
        QmlSystem.hideMenu()
        QmlSystem.setScreen(content, "qml/screens/AccountsScreen.qml")
      }
    }
  }

  AVMEButton {
    id: btnChangeWallet
    width: parent.width * 0.15
    anchors {
      verticalCenter: parent.verticalCenter
      right: parent.right
      rightMargin: 10
    }
    text: "Change Wallet"
    onClicked: {
      QmlSystem.setLedgerFlag(false)
      QmlSystem.hideMenu()
      QmlSystem.setScreen(content, "qml/screens/StartScreen.qml")
    }
  }

  // Popup for Ledger accounts
  AVMEPopupLedger {
    id: ledgerPopup
  }

  // Info popup for if communication with Ledger fails
  AVMEPopupInfo {
    id: ledgerFailPopup
    icon: "qrc:/img/warn.png"
    onAboutToHide: ledgerRetryTimer.stop()
    okBtn.text: "Close"
  }

  // "qrcodeWidth = 0" makes the program not even open, so leave it at 1
  AVMEPopupQRCode {
    id: qrcodePopup
    qrcodeWidth: (currentAddress != "") ? QmlSystem.getQRCodeSize(currentAddress) : 1
    textAddress.text: currentAddress
  }
}
