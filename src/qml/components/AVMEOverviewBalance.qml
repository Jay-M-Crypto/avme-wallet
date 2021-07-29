/* Copyright (c) 2020-2021 AVME Developers
   Distributed under the MIT/X11 software license, see the accompanying
   file LICENSE or http://www.opensource.org/licenses/mit-license.php. */
import QtQuick 2.15
// Version 2.15 required for Gradient.orientation
import QtQuick.Controls 2.2

// Panel template for basic info/data/etc.
Rectangle {
  id: overviewBalance
  property alias totalFiatBalance: fiatBalance.text
  property alias totalCoinBalance: coinBalance.text
  property alias totalTokenBalance: tokenBalance.text

  implicitWidth: 500
  implicitHeight: 120
  gradient: Gradient {
    orientation: Gradient.Horizontal
  	GradientStop { position: 0.0; color: "#9300f5" }
  	GradientStop { position: 1.0; color: "#00d6f6" }
  }
  radius: 10
  Text {
      id: title
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.topMargin: parent.height * 0.05
      anchors.leftMargin: parent.height * 0.1
      color: "white"
      font.pixelSize: 18.0
      font.bold: true
      text: "Total balance"
  }
  Text {
      id: fiatBalance
      anchors.top: title.bottom
      anchors.left: parent.left
      anchors.topMargin: parent.height * 0.01
      anchors.leftMargin: parent.height * 0.1
      color: "white"
      font.pixelSize: 24.0
      font.bold: true
      text: if (accountHeader.coinBalance) {
        var totalFiatBalance = +accountHeader.coinValue
        for (var token in accountHeader.tokenList) {
          totalFiatBalance += +accountHeader.tokenList[token]["value"]
        }
        text: totalFiatBalance
      } else {
        text: "Loading..."
      }
  }
  Text {
      id: coinBalance
      anchors.top: fiatBalance.bottom
      anchors.left: parent.left
      anchors.topMargin: parent.height * 0.01
      anchors.leftMargin: parent.height * 0.1
      color: "white"
      font.pixelSize: 18.0
      font.bold: true
      text: accountHeader.coinBalance ? accountHeader.coinBalance + " AVAX" : "Loading..."
  }
   Text {
      id: tokenBalance
      anchors.top: coinBalance.bottom
      anchors.left: parent.left
      anchors.topMargin: parent.height * 0.01
      anchors.leftMargin: parent.height * 0.1
      color: "white"
      font.pixelSize: 18.0
      font.bold: true
      // Using the own tokenList object makes the own ff to fail
      text: if (accountHeader.coinBalance) {
        var totalTokenWorth = 0.000000000000000000
        for (var token in accountHeader.tokenList) {
          totalTokenWorth += +accountHeader.tokenList[token]["balance"] *
                              +accountHeader.tokenList[token]["derivedValue"]
          console.log(totalTokenWorth)
        }
        text: totalTokenWorth + " AVAX (Tokens)"
      } else {
        text: "Loading..."
      }
  } 
}
