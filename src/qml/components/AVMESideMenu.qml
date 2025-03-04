/* Copyright (c) 2020-2021 AVME Developers
   Distributed under the MIT/X11 software license, see the accompanying
   file LICENSE or http://www.opensource.org/licenses/mit-license.php. */
import QtQuick 2.9
import QtQuick.Controls 2.2

import "qrc:/qml/components"

// Side panel that acts as a "global menu"
Rectangle {
  id: sideMenu
  property string currentScreen
  property int currentSelectionOffset
  width: 200
  height: parent.height
  color: "#1C2029"

  // TODO: Using this if condition is a workaround, find a better solution
  property bool enableBtn: accountHeader.coinRawBalance

  Connections {
    target: qmlSystem
    function onGoToOverview() {
      currentSelectionOffset = 0
      changeScreen("Overview")
    }
  }

  function changeScreen(name) {
    content.active = false
    currentScreen = name
    qmlSystem.setScreen(content, "qml/screens/" + name + "Screen.qml")
    content.active = true
  }

  Rectangle {
    id: itemSelection
    width: (parent.width * 0.05)
    height: 40
    visible: (currentScreen != "Settings" && currentScreen != "About")
    anchors.left: parent.left
    y: items.y + sideMenu.currentSelectionOffset
    color: "#AD00FA"
  }

  Image {
    id: logo
    height: 50
    anchors {
      top: parent.top
      horizontalCenter: parent.horizontalCenter
      topMargin: 20
    }
    source: "qrc:/img/Welcome_Logo_AVME.png"
    fillMode: Image.PreserveAspectFit
    antialiasing: true
    smooth: true
  }

  Column {
    id: items
    width: parent.width
    anchors.verticalCenter: parent.verticalCenter
    spacing: 10

    AVMEButton {
      id: itemOverview
      width: (parent.width * 0.8)
      anchors.horizontalCenter: parent.horizontalCenter
      text: "Overview"
      enabled: enableBtn
      onClicked: {
        sideMenu.currentSelectionOffset = y
        changeScreen("Overview")
      }
    }

    AVMEButton {
      id: itemTokens
      width: (parent.width * 0.8)
      anchors.horizontalCenter: parent.horizontalCenter
      text: "Tokens"
      enabled: enableBtn
      onClicked: {
        sideMenu.currentSelectionOffset = y
        changeScreen("Tokens")
      }
    }

    AVMEButton {
      id: itemHistory
      width: (parent.width * 0.8)
      anchors.horizontalCenter: parent.horizontalCenter
      text: "History"
      enabled: enableBtn
      onClicked: {
        sideMenu.currentSelectionOffset = y
        changeScreen("History")
      }
    }

    AVMEButton {
      id: itemContacts
      width: (parent.width * 0.8)
      anchors.horizontalCenter: parent.horizontalCenter
      text: "Contacts"
      enabled: enableBtn
      onClicked: {
        sideMenu.currentSelectionOffset = y
        changeScreen("Contacts")
      }
    }

    AVMEButton {
      id: itemSend
      width: (parent.width * 0.8)
      anchors.horizontalCenter: parent.horizontalCenter
      text: "Send"
      enabled: enableBtn
      onClicked: {
        sideMenu.currentSelectionOffset = y
        changeScreen("Send")
      }
    }

    AVMEButton {
      id: itemExchange
      width: (parent.width * 0.8)
      anchors.horizontalCenter: parent.horizontalCenter
      text: "Exchange"
      enabled: enableBtn
      onClicked: {
        sideMenu.currentSelectionOffset = y
        changeScreen("Exchange")
      }
    }

    AVMEButton {
      id: itemLiquidity
      width: (parent.width * 0.8)
      anchors.horizontalCenter: parent.horizontalCenter
      text: "Liquidity"
      enabled: enableBtn
      onClicked: {
        sideMenu.currentSelectionOffset = y
        changeScreen("Liquidity")
      }
    }

    AVMEButton {
      id: itemStaking
      width: (parent.width * 0.8)
      anchors.horizontalCenter: parent.horizontalCenter
      text: "Staking"
      enabled: enableBtn
      onClicked: {
        sideMenu.currentSelectionOffset = y
        changeScreen("Staking")
      }
    }

    AVMEButton {
      id: itemApplications
      width: (parent.width * 0.8)
      anchors.horizontalCenter: parent.horizontalCenter
      text: "Applications"
      enabled: enableBtn
      onClicked: {
        sideMenu.currentSelectionOffset = y
        changeScreen("Applications")
      }
    }
  }

  Row {
    id: statsRow
    anchors {
      bottom: parent.bottom
      horizontalCenter: parent.horizontalCenter
      bottomMargin: 20
    }
    spacing: 20

    Image {
      id: itemSettings
      height: 24
      source: (currentScreen == "Settings")
        ? "qrc:/img/icons/Icon_Settings_On.png" : "qrc:/img/icons/Icon_Settings.png"
      fillMode: Image.PreserveAspectFit
      antialiasing: true
      smooth: true
      MouseArea {
        anchors.fill: parent
        onClicked: changeScreen("Settings")
      }
    }

    Text {
      id: versionText
      color: "#FFFFFF"
      font.pixelSize: 14.0
      anchors.verticalCenter: parent.verticalCenter
      text: "v" + qmlSystem.getProjectVersion()
    }

    Image {
      id: itemAbout
      height: 24
      source: (currentScreen == "About")
        ? "qrc:/img/icons/Icon_Info_On.png" : "qrc:/img/icons/Icon_Info.png"
      fillMode: Image.PreserveAspectFit
      antialiasing: true
      smooth: true
      MouseArea {
        anchors.fill: parent
        onClicked: changeScreen("About")
      }
    }
  }
}
