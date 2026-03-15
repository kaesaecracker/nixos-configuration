pragma Singleton
import QtQuick

QtObject {
    // TODO: get those from stylix
    property QtObject colors: QtObject {
        id: colors // for recursive reference
        property color base00: "#1e1e2e"
        property color base01: "#181825"
        property color base02: "#313244"
        property color base03: "#45475a"
        property color base04: "#585b70"
        property color base05: "#cdd6f4"
        property color base06: "#f5e0dc"
        property color base07: "#b4befe"
        property color base08: "#f38ba8"
        property color base09: "#6f9dff"
        property color base0A: "#d162a4"
        property color base0B: "#a8c9ff"
        property color base0C: "#a30262"
        property color base0D: "#89b4fa"
        property color base0E: "#cba6f7"
        property color base0F: "#f2cdcd"
        property color base10: "#1e1e2e"
        property color base11: "#1e1e2e"
        property color base12: "#f38ba8"
        property color base13: "#f9e2af"
        property color base14: "#a6e3a1"
        property color base15: "#94e2d5"
        property color base16: "#89b4fa"
        property color base17: "#cba6f7"

        property alias background: colors.base00
        property alias backgroundLight: colors.base01
        property alias backgroundSelection: colors.base02
        property alias comments: colors.base03
        property alias foregroundDark: colors.base04
        property alias foreground: colors.base05
        property alias foregroundLight1: colors.base06
        property alias foregroundLight2: colors.base07
        property alias accent0: colors.base08
        property alias accent1: colors.base09
        property alias accent2: colors.base0A
        property alias accent3: colors.base0B
        property alias accent4: colors.base0C
        property alias accent5: colors.base0D
        property alias accent6: colors.base0E
        property alias accent7: colors.base0F
    }
}
