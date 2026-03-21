// Nebula Matugen — Dynamic color loader

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: matugen

    // Path to matugen-generated colors JSON
    readonly property string colorsPath: Quickshell.shellPath("matugen-colors.json")

    // File reader with watch for live color updates
    FileView {
        id: colorFile
        path: matugen.colorsPath
        watchChanges: true
        onFileChanged: {
            reload()
            // Small delay to avoid race condition (100ms pattern from end-4)
            reloadTimer.restart()
        }
        onLoaded: applyColors()
    }

    Timer {
        id: reloadTimer
        interval: 100
        repeat: false
        onTriggered: applyColors()
    }

    Component.onCompleted: {
        if (colorFile.loaded) applyColors()
    }

    function applyColors() {
        const text = colorFile.text()
        if (!text || text.length === 0) {
            console.info("[Nebula] No matugen colors found, using base theme")
            return
        }

        try {
            const colors = JSON.parse(text)

            // Map matugen colors to Theme singleton properties
            if (colors.primary)              Theme.primary    = colors.primary
            if (colors.secondary)            Theme.secondary  = colors.secondary
            if (colors.tertiary)             Theme.tertiary   = colors.tertiary
            if (colors.error)                Theme.error      = colors.error

            // Surfaces
            if (colors.surface)              Theme.base       = colors.surface
            if (colors.surface_dim)          Theme.mantle     = colors.surface_dim
            if (colors.surface_bright)       Theme.surface0   = colors.surface_bright

            // Text
            if (colors.on_surface)           Theme.text       = colors.on_surface
            if (colors.on_surface_variant)   Theme.subtext0   = colors.on_surface_variant

            // Borders
            if (colors.outline)              Theme.border     = colors.outline
            if (colors.outline_variant)      Theme.borderDim  = colors.outline_variant

            console.info("[Nebula] Matugen colors applied")
        } catch (e) {
            console.warn("[Nebula] Failed to parse matugen colors:", e)
        }
    }
}
