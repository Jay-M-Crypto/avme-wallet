/* Copyright (c) 2020-2021 AVME Developers
   Distributed under the MIT/X11 software license, see the accompanying
   file LICENSE or http://www.opensource.org/licenses/mit-license.php. */
import QtQuick 2.9
import QtQuick.Controls 2.2

import "qrc:/qml/components"

// Popup for showing the progress of a transaction. Has to be opened manually.
AVMEPopup {
  id: txProgressPopup
  widthPct: 0.8
  heightPct: 0.8
  property color popupBgColor: "#1C2029"
  property bool requestedFromWS: false

  // Store the data in case we need to retry the transaction
  property string operation
  property string from
  property string to
  property string value
  property string txData
  property string gas
  property string gasPrice
  property string pass
  property string nonce

  Connections {
    target: qmlSystem
    function onTxStart(
      operation_, from_, to_, value_, txData_, gas_, gasPrice_, pass_
    ) {
      operation = operation_
      from = from_
      to = to_
      value = value_
      txData = txData_
      gas = gas_
      gasPrice = gasPrice_
      pass = pass_
      nonce = accountHeader.accountNonce
      // Uncomment to see the data passed to the popup
      //console.log(operation)
      //console.log(from)
      //console.log(to)
      //console.log(value)
      //console.log(txData)
      //console.log(gas)
      //console.log(gasPrice)
      resetStatuses()
      console.log("Ue tem dois rodando " + parent.id)
      qmlSystem.makeTransaction(
        operation, from, to, value, txData, gas, gasPrice, pass, nonce
      )
    }
    function onTxBuilt(b) {
      buildPngRotate.stop()
      buildPng.rotation = 0
      if (b) {
        buildText.color = "limegreen"
        buildText.text = "Transaction built!"
        buildPng.source = "qrc:/img/ok.png"
        signText.color = "#FFFFFF"
        signPngRotate.start()
      } else {
        buildText.color = "crimson"
        buildText.text = "Error on building transaction."
        buildPng.source = "qrc:/img/no.png"
        btnClose.visible = true
        btnRetry.visible = true
      }
    }
    function onTxSigned(b, msg) {
      signPngRotate.stop()
      signPng.rotation = 0
      if (b) {
        signText.color = "limegreen"
        signText.text = msg
        signPng.source = "qrc:/img/ok.png"
        sendText.color = "#FFFFFF"
        sendPngRotate.start()
      } else {
        signText.color = "crimson"
        signText.text = msg
        signPng.source = "qrc:/img/no.png"
        btnClose.visible = true
        btnRetry.visible = true
      }
    }
    function onTxSent(b, linkUrl, txid, msg) {
      sendPngRotate.stop()
      sendPng.rotation = 0
      if (b) {
        sendText.color = "limegreen"
        sendText.text = "Transaction sent!"
        sendPng.source = "qrc:/img/ok.png"
        confirmText.color = "#FFFFFF"
        confirmPngRotate.start()
        qmlSystem.checkTransactionFor15s(txid);
      } else {
        sendText.color = "crimson"
        sendText.text = "Error on sending transaction.<br> " + msg
        sendPng.source = "qrc:/img/no.png"
        btnClose.visible = true
        btnRetry.visible = true
      }
    }
    function onTxConfirmed(b, txid) {
      confirmPngRotate.stop()
      confirmPng.rotation = 0
      if (b) {
        confirmText.color = "limegreen"
        confirmText.text = "Transaction confirmed!"
        confirmPng.source = "qrc:/img/ok.png"
        if (requestedFromWS) {
          qmlSystem.requestedTransactionStatus(true, txid)
        }
      } else {
        confirmText.color = "crimson"
        confirmText.text = "Transaction not confirmed.<br><b>Retrying will attempt a higher fee. (Recommended)</b>"
        confirmPng.source = "qrc:/img/no.png"
        btnRetry.visible = true
      }
      btnClose.visible = true
    }
    function onTxRetry() {
      sendText.text = "Transaction nonce is too low, or a transaction with"
      + "<br>the same hash was already imported. Retrying..."
    }
    function onLedgerRequired() { ledgerStatusPopup.open() }
    function onLedgerDone() { ledgerStatusPopup.close() }
  }

  function resetStatuses() {
    buildText.color = "#FFFFFF"
    signText.color = "#444444"
    sendText.color = "#444444"
    confirmText.color = "#444444"
    buildText.text = "Building transaction..."
    signText.text = "Signing transaction..."
    sendText.text = "Broadcasting transaction..."
    confirmText.text = "Confirming transaction..."
    buildPng.source = signPng.source = sendPng.source = "qrc:/img/icons/loading.png"
    buildPngRotate.start()
    btnOpenLink.visible = false
    btnClose.visible = false
    btnRetry.visible = false
  }

  Column {
    id: items
    anchors {
      centerIn: parent
      margins: 30
    }
    spacing: 20

    // Enter/Numpad enter key override
    Keys.onPressed: {
      if ((event.key == Qt.Key_Return) || (event.key == Qt.Key_Enter)) {
        if (btnClose.visible) { txProgressPopup.close() }
      }
    }

    Row {
      id: buildRow
      anchors.horizontalCenter: parent.horizontalCenter
      height: 70
      spacing: 40

      Image {
        id: buildPng
        height: 64
        anchors.verticalCenter: buildText.verticalCenter
        fillMode: Image.PreserveAspectFit
        source: "qrc:/img/icons/loading.png"
        RotationAnimator {
          id: buildPngRotate
          target: buildPng
          from: 0
          to: 360
          duration: 1000
          loops: Animation.Infinite
          easing.type: Easing.InOutQuad
          running: false
        }
      }

      Text {
        id: buildText
        font.pixelSize: 24.0
        color: "#FFFFFF"
        text: "Building transaction..."
      }
    }

    Row {
      id: signRow
      anchors.horizontalCenter: parent.horizontalCenter
      height: 70
      spacing: 40

      Image {
        id: signPng
        height: 64
        anchors.verticalCenter: signText.verticalCenter
        fillMode: Image.PreserveAspectFit
        source: "qrc:/img/icons/loading.png"
        RotationAnimator {
          id: signPngRotate
          target: signPng
          from: 0
          to: 360
          duration: 1000
          loops: Animation.Infinite
          easing.type: Easing.InOutQuad
          running: false
        }
      }

      Text {
        id: signText
        font.pixelSize: 24.0
        color: "#444444"
        text: "Signing transaction..."
      }
    }

    Row {
      id: sendRow
      anchors.horizontalCenter: parent.horizontalCenter
      height: 70
      spacing: 40

      Image {
        id: sendPng
        height: 64
        anchors.verticalCenter: sendText.verticalCenter
        fillMode: Image.PreserveAspectFit
        source: "qrc:/img/icons/loading.png"
        RotationAnimator {
          id: sendPngRotate
          target: sendPng
          from: 0
          to: 360
          duration: 1000
          loops: Animation.Infinite
          easing.type: Easing.InOutQuad
          running: false
        }
      }

      Text {
        id: sendText
        font.pixelSize: 24.0
        color: "#444444"
        text: "Broadcasting transaction..."
      }
    }

    Row {
      id: confirmRow
      anchors.horizontalCenter: parent.horizontalCenter
      height: 70
      spacing: 40

      Image {
        id: confirmPng
        height: 64
        anchors.verticalCenter: confirmText.verticalCenter
        fillMode: Image.PreserveAspectFit
        source: "qrc:/img/icons/loading.png"
        RotationAnimator {
          id: confirmPngRotate
          target: confirmPng
          from: 0
          to: 360
          duration: 1000
          loops: Animation.Infinite
          easing.type: Easing.InOutQuad
          running: false
        }
      }

      Text {
        id: confirmText
        font.pixelSize: 24.0
        color: "#444444"
        text: "Confirming transaction..."
      }
    }
  }

  AVMEButton {
    id: btnOpenLink
    property string linkUrl
    width: parent.width * 0.5
    anchors {
      bottom: btnClose.top
      horizontalCenter: parent.horizontalCenter
      margins: 20
    }
    text: "Open Transaction in Block Explorer"
    onClicked: Qt.openUrlExternally(linkUrl)
  }

  AVMEButton {
    id: btnRetry
    width: parent.width * 0.25
    anchors {
      bottom: parent.bottom
      horizontalCenter: parent.horizontalCenter
      horizontalCenterOffset: -150
      margins: 20
    }
    text: "Retry"
    onClicked: {} // TODO
  }

  AVMEButton {
    id: btnClose
    width: parent.width * 0.25
    anchors {
      bottom: parent.bottom
      horizontalCenter: parent.horizontalCenter
      horizontalCenterOffset: 150
      margins: 20
    }
    text: "Close"
    onClicked: txProgressPopup.close()
  }

  AVMEPopupInfo {
    id: ledgerStatusPopup
    icon: "qrc:/img/warn.png"
    info: "Please confirm the transaction on your device."
    okBtn.text: "Close"
  }
}
