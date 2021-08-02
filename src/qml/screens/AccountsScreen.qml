/* Copyright (c) 2020-2021 AVME Developers
   Distributed under the MIT/X11 software license, see the accompanying
   file LICENSE or http://www.opensource.org/licenses/mit-license.php. */
import QtQuick 2.9
import QtQuick.Controls 2.2

import "qrc:/qml/components"
import "qrc:/qml/panels"
import "qrc:/qml/popups"

/**
 * Screen for listing and managing Accounts in the Wallet.
 * TODO: merge Ledger popup into this
 */
Item {
  id: accountsScreen

  Connections {
    target: QmlSystem
    function onAccountCreated(data) {
      chooseAccountPopup.clean()
      chooseAccountPopup.close()
      accountInfoPopup.close()
      fetchAccounts()
    }
    function onAccountCreationFailed() {
      accountInfoPopup.close()
      accountFailPopup.open()
    }
    function onAccountAVAXBalancesUpdated(address, avaxBalance, avaxValue) {
      for (var i = 0; i < accountSelectPanel.accountModel.count; i++) {
        if (accountSelectPanel.accountModel.get(i).address == address) {
          accountSelectPanel.accountModel.setProperty(
            i, "coinAmount", avaxBalance + " AVAX"
          )
          accountSelectPanel.accountModel.setProperty(
            i, "coinValue", "$" + avaxValue
          )
        }
      }
    }
  }

  Component.onCompleted: fetchAccounts()

  function fetchAccounts() {
    accountSelectPanel.accountModel.clear()
    var accList = QmlSystem.listAccounts()
    var addList = []
    for (var i = 0; i < accList.length; i++) {
      var accJson = JSON.parse(accList[i])
      accountSelectPanel.accountModel.set(i, accJson)
      accountSelectPanel.accountModel.setProperty(i, "coinAmount", "Loading...")
      accountSelectPanel.accountModel.setProperty(i, "coinValue", "Loading...")
      addList.push(accJson.address)
    }
    accountSelectPanel.accountModel.sortByAddress()
    QmlSystem.getAllAVAXBalances(addList)
  }

  function useSeed() {
    chooseAccountPopup.foreignSeed = seedPopup.fullSeed
    seedPopup.clean()
    seedPopup.close()
    chooseAccountPopup.open()
  }

  AVMEPopupChooseAccount { id: chooseAccountPopup }
  AVMEPopupSeed { id: seedPopup }

  AVMEPanelAccountSelect {
    id: accountSelectPanel
    height: parent.height * 0.9
    width: parent.width * 0.9
    anchors.centerIn: parent
    btnCreate.onClicked: chooseAccountPopup.open()
    btnImport.onClicked: seedPopup.open()
    btnSelect.onClicked: {
      QmlSystem.setCurrentAccount(accountList.currentItem.itemAddress)
      QmlSystem.loadTokenDB()
      QmlSystem.loadHistoryDB(QmlSystem.getCurrentAccount())
      QmlSystem.loadARC20Tokens()
      accountHeader.getAddress()
      QmlSystem.goToOverview()
      QmlSystem.setScreen(content, "qml/screens/OverviewScreen.qml")
    }
    btnErase.onClicked: confirmErasePopup.open()
  }

  // Popup for waiting for Accounts to be created/imported/erased, respectively
  AVMEPopup {
    id: accountInfoPopup
    property alias text: accountInfoText.text
    widthPct: 0.2
    heightPct: 0.1
    Text {
      id: accountInfoText
      color: "#FFFFFF"
      horizontalAlignment: Text.AlignHCenter
      anchors.centerIn: parent
      font.pixelSize: 14.0
    }
  }

  // Info popup for if the seed import fails
  AVMEPopupInfo {
    id: seedFailPopup
    icon: "qrc:/img/warn.png"
    info: "Seed is invalid. Please check if it's typed correctly."
  }

  AVMEPopupInfo {
    id: eraseFailPopup
    icon: "qrc:/img/warn.png"
    info: "Failed to erase Account, please try again."
  }

  AVMEPopupYesNo {
    id: confirmErasePopup
    widthPct: 0.4
    heightPct: 0.25
    icon: "qrc:/img/warn.png"
    info: "Are you sure you want to erase this Account?"
    yesBtn.onClicked: {
      confirmErasePopup.close()
      accountInfoPopup.text = "Erasing Account..."
      accountInfoPopup.open()
      if (QmlSystem.eraseAccount(accountSelectPanel.accountList.currentItem.itemAddress)) {
        accountInfoPopup.close()
        fetchAccounts()
      } else {
        accountInfoPopup.close()
        eraseFailPopup.open()
      }
    }
    noBtn.onClicked: {
      confirmErasePopup.close()
    }
  }
}

