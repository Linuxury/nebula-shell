pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: theme

    // === Core surfaces ===
    property string base:      "#1e1e2e"
    property string mantle:    "#181825"
    property string crust:     "#11111b"
    property string surface0:  "#313244"
    property string surface1:  "#45475a"
    property string surface2:  "#585b70"
    property string overlay0:  "#6c7086"
    property string overlay1:  "#7f849c"

    // === Text ===
    property string text:       "#cdd6f4"
    property string subtext0:   "#a6adc8"
    property string subtext1:   "#bac2de"

    // === Accent colors ===
    property string lavender:   "#b4befe"
    property string mauve:      "#cba6f7"
    property string blue:       "#89b4fa"
    property string sapphire:   "#74c7ec"
    property string sky:        "#89dceb"
    property string teal:       "#94e2d5"
    property string green:      "#a6e3a1"
    property string yellow:     "#f9e2af"
    property string peach:      "#fab387"
    property string maroon:     "#eba0ac"
    property string red:        "#f38ba8"
    property string flamingo:   "#f2cdcd"
    property string pink:       "#f5c2e7"
    property string rosewater:  "#f5e0dc"

    // === Semantic aliases (used by components) ===
    property string primary:    lavender
    property string secondary:  mauve
    property string tertiary:   blue
    property string error:      red
    property string warning:    yellow
    property string success:    green
    property string info:       sapphire

    // === Surface aliases ===
    property string bg:         base
    property string bgAlt:      mantle
    property string fg:         text
    property string fgDim:      subtext0
    property string border:     surface2
    property string borderDim:  surface1

    // === Font ===
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int    fontSize:   11

    // === Radius ===
    property int    radius:     12

    // === Opacity ===
    property real   bgOpacity:  0.85
}
