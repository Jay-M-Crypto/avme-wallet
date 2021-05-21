#TODO: Fix library order, it is very messy currently
SET(QT_LIBS "")
LIST(APPEND QT_LIBS "-lc++ -lSystem -lobjc")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5Network.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5Gui.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5Qml.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/qml/QtQuick.2/libqtquick2plugin.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/qml/QtQuick/Window.2/libwindowplugin.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5Quick.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libqtlibpng.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libqtharfbuzz.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libz.a")
#LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5DBus.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5Widgets.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5Core.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5EventDispatcherSupport.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5AccessibilitySupport.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5ThemeSupport.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5FontDatabaseSupport.a")
#LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5DBus.a")
#LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5CglSupport.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5ClipboardSupport.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/plugins/platforms/libqcocoa.a")
# I don't know why this works the way it does, it just *does*, let's roll with it
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5GraphicsSupport.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5Network.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5Gui.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5QmlModels.a")

LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/qml/QtQuick/Controls.2/libqtquickcontrols2plugin.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5QuickControls2.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/qml/QtQuick/Templates.2/libqtquicktemplates2plugin.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5QuickTemplates2.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/qml/Qt/labs/platform/libqtlabsplatformplugin.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5Charts.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/qml/QtCharts/libqtchartsqml2.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5QmlWorkerScript.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libQt5Widgets.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libqtpcre2.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libqtharfbuzz.a")
LIST(APPEND QT_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libzmq.a")
LIST(APPEND QT_LIBS "-framework AppKit -framework ApplicationServices -framework Carbon -framework CoreFoundation -framework CoreGraphics -framework CoreServices -framework CoreText -framework CoreVideo -framework Foundation -framework ImageIO -framework IOKit -framework IOSurface -framework Metal -framework Security -framework QuartzCore -framework Cocoa -framework Kerberos -framework GSS -framework CFNetwork -framework Network -framework System -framework SystemConfiguration")


SET(BOOST_LIBS "")
LIST(APPEND BOOST_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libboost_filesystem-mt-x64.a")
#LIST(APPEND BOOST_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libboost_log_setup-mt-x64.a")
#LIST(APPEND BOOST_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libboost_log-mt-64.a")
#LIST(APPEND BOOST_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libboost_log_setup-mt-x64.a")
LIST(APPEND BOOST_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libboost_program_options-mt-x64.a")
LIST(APPEND BOOST_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libboost_system-mt-x64.a")
LIST(APPEND BOOST_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libboost_thread-mt-x64.a")
LIST(APPEND BOOST_LIBS "${CMAKE_SOURCE_DIR}/depends/${DEPENDS_PREFIX}/lib/libboost_chrono-mt-x64.a")
