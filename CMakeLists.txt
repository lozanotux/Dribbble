    # project name
    project (com.github.lozanotux.dribbble)

    # the oldest stable cmake version we support
    cmake_minimum_required (VERSION 2.6)

    # tell cmake where its modules can be found in our project directory
    list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
    list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/src)

    # where we install data directory (if we have any)
    set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

    # what to call that directory where we install data too
    set (PKGDATADIR "${DATADIR}/com.github.lozanotux.dribbble")

    set (EXEC_NAME "com.github.lozanotux.dribbble")
    set (RELEASE_NAME "Pow")
    set (VERSION "0.1")
    set (VERSION_INFO "First Alpha Version")

    # we're about to use pkgconfig to make sure dependencies are installed so let's find pkgconfig first
    find_package(PkgConfig)

    # now let's actually check for the required dependencies
    pkg_check_modules(DEPS REQUIRED gtk+-3.0 glib-2.0 granite gstreamer-1.0 gstreamer-pbutils-1.0)

    add_definitions(${DEPS_CFLAGS})
    link_libraries(${DEPS_LIBRARIES})
    link_directories(${DEPS_LIBRARY_DIRS})

    # make sure we have vala
    find_package(Vala REQUIRED)
    # make sure we use vala
    include(ValaVersion)
    # make sure it's the desired version of vala
    ensure_vala_version("0.16" MINIMUM)

    # files we want to compile
    include(ValaPrecompile)
    vala_precompile(VALA_C ${EXEC_NAME}
        src/Widgets/Controls.vala
        src/Widgets/InformationView.vala
        src/Widgets/StatusBar.vala
        src/Widgets/WelcomeView.vala

        src/Dribbble.vala

    # tell what libraries to use when compiling
    PACKAGES
        gtk+-3.0
        glib-2.0
        granite
        gstreamer-1.0
        gstreamer-pbutils-1.0
    )

    # GSchemas files
    add_subdirectory (data)

    # Translation files
    set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}")
    add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
    add_subdirectory (po)

    # tell cmake what to call the executable we just made
    add_executable(${EXEC_NAME} ${VALA_C})

    # install the binaries we just made
    install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

    # install our .desktop file so the Applications menu will see it
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.lozanotux.dribbble.desktop DESTINATION ${DATADIR}/applications/)

    # install our .appdata.xml file so AppCenter will see it
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.lozanotux.dribbble.appdata.xml DESTINATION ${DATADIR}/metainfo/)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/stylesheet.css DESTINATION ${DATADIR}/dribbble/)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/folder-open.svg DESTINATION ${DATADIR}/dribbble/)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/drag-music.png DESTINATION ${DATADIR}/dribbble/)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/24/dribbble.svg DESTINATION ${DATADIR}/icons/hicolor/24x24/apps)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/32/dribbble.svg DESTINATION ${DATADIR}/icons/hicolor/32x32/apps)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/48/dribbble.svg DESTINATION ${DATADIR}/icons/hicolor/48x48/apps)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/64/dribbble.svg DESTINATION ${DATADIR}/icons/hicolor/64x64/apps)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/128/dribbble.svg DESTINATION ${DATADIR}/icons/hicolor/128x128/apps)

    #Uninstall target
    configure_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
        IMMEDIATE @ONLY)

    add_custom_target(uninstall
        COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
