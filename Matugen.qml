import QtQuick
import Quickshell

QtObject {
    id: matugen

    property var theme: null

    // Path to matugen-generated colors JSON
    // Expected format:
    // {
    //   "primary": "#b4befe",
    //   "on_primary": "#1e1e2e",
    //   "secondary": "#cba6f7",
    //   "tertiary": "#89b4fa",
    //   "surface": "#1e1e2e",
    //   "surface_dim": "#181825",
    //   "on_surface": "#cdd6f4",
    //   "on_surface_variant": "#a6adc8",
    //   "outline": "#585b70",
    //   "outline_variant": "#45475a",
    //   "error": "#f38ba8"
    // }
    readonly property string colorsPath: Quickshell.shellPath("matugen-colors.json")

    // File watcher - reloads colors when matugen regenerates the file
    FileWatcher {
        id: colorWatcher
        path: matugen.colorsPath
        onFileChanged: matugen.loadColors()
    }

    // Load and apply colors on startup and when file changes
    Component.onCompleted: loadColors()

    function loadColors() {
        const xhr = new XMLHttpRequest()
        xhr.open("GET", "file://" + colorsPath)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200 || xhr.status === 0) {
                    try {
                        const colors = JSON.parse(xhr.responseText)
                        applyColors(colors)
                    } catch (e) {
                        console.warn("[Nebula] Failed to parse matugen colors:", e)
                    }
                } else {
                    console.info("[Nebula] No matugen colors found, using base theme")
                }
            }
        }
        xhr.send()
    }

    function applyColors(colors) {
        if (!theme) return

        // Map matugen colors to theme properties
        if (colors.primary)          theme.primary    = colors.primary
        if (colors.secondary)        theme.secondary  = colors.secondary
        if (colors.tertiary)         theme.tertiary   = colors.tertiary
        if (colors.error)            theme.error      = colors.error

        // Surfaces
        if (colors.surface)          theme.base       = colors.surface
        if (colors.surface_dim)      theme.mantle     = colors.surface_dim
        if (colors.surface_bright)   theme.surface0   = colors.surface_bright

        // Text
        if (colors.on_surface)       theme.text       = colors.on_surface
        if (colors.on_surface_variant) theme.subtext0 = colors.on_surface_variant

        // Borders
        if (colors.outline)          theme.border     = colors.outline
        if (colors.outline_variant)  theme.borderDim  = colors.outline_variant

        console.info("[Nebula] Matugen colors applied")
    }
}
