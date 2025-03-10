/* Copyright (c) 2020-2021 AVME Developers
   Distributed under the MIT/X11 software license, see the accompanying
   file LICENSE or http://www.opensource.org/licenses/mit-license.php. */
import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.2

import QmlApi 1.0

import "qrc:/qml/components"

// The main window
ApplicationWindow {
  id: window
  property bool menuToggle: false
  property alias menuSize: sideMenu.width

  QmlApi { id: qmlApi }

  title: "AVME Wallet " + qmlSystem.getProjectVersion()
  width: 1280
  height: 720
  minimumWidth: 1280
  minimumHeight: 720
  visible: true

  Connections {
    target: qmlSystem
    function onHideMenu() { menuToggle = false }
    function onGoToOverview() { menuToggle = true }
  }

  // States for menu visibility and loader anchoring
  StateGroup {
    id: menuStates
    states: [
      State {
        name: "menuHide"; when: !menuToggle
        PropertyChanges { target: sideMenu; visible: false }
        PropertyChanges { target: accountHeader; visible: false }
        AnchorChanges {
          target: content;
          anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
          }
        }
      },
      State {
        name: "menuShow"; when: menuToggle
        PropertyChanges { target: sideMenu; visible: true }
        PropertyChanges { target: accountHeader; visible: true }
        AnchorChanges {
          target: content;
          anchors {
            left: sideMenu.right
            right: parent.right
            top: accountHeader.bottom
            bottom: parent.bottom
          }
        }
      }
    ]
  }

  // Background w/ logo image
  Rectangle {
    id: bg
    anchors.fill: parent
    gradient: Gradient {
      GradientStop { position: 0.0; color: "#0F0C18" }
      GradientStop { position: 1.0; color: "#190B25" }
    }

    Image {
      id: logoBg
      width: 1000
      height: 1000
      anchors {
        right: parent.right
        bottom: parent.bottom
        margins: -300
      }
      opacity: 0.15
      antialiasing: true
      smooth: true
      fillMode: Image.PreserveAspectFit
      source: "qrc:/img/avme_logo_hd.png"
    }
  }

  // Side menu
  AVMESideMenu {
    id: sideMenu
    anchors {
      left: parent.left
      top: parent.top
      bottom: parent.bottom
    }
  }

  // Account header
  AVMEAccountHeader {
    id: accountHeader
    anchors {
      top: parent.top
      left: sideMenu.right
      right: parent.right
      margins: 10
    }
  }

  // Dynamic screen loader (used in setScreen(id, screenpath))
  Loader {
    id: content
    antialiasing: true
    smooth: true
    source: "qrc:/qml/screens/StartScreen.qml"
  }
}
