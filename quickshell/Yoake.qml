pragma Singleton
import QtQuick

QtObject {
    // Yoake (夜明け) palette — twilight train at the coast
    readonly property color bg:        "#20202F"
    readonly property color surface:   "#363849"
    readonly property color surfaceAlt:"#2A2A3C"
    readonly property color border:    "#4D4F63"
    readonly property color borderMid: "#6F7288"

    readonly property color fg:        "#E9CDB0"
    readonly property color fgDim:     "#C5B8AB"
    readonly property color muted:     "#9E8C9C"

    // Accents
    readonly property color peach:     "#E2AAA1"  // primary — sunlit cloud
    readonly property color peachHi:   "#EBBDA5"
    readonly property color cream:     "#E9CDB0"  // secondary — cloud highlight
    readonly property color mauve:     "#9E8C9C"  // tertiary
    readonly property color slateBlue: "#7A8CA8"
    readonly property color sage:      "#90A89C"
    readonly property color teal:      "#8AA0A0"
    readonly property color purple:    "#9E8C9C"
    readonly property color rose:      "#C08080"  // for error / critical

    // Alphas (commonly used)
    function alpha(color, a) { return Qt.rgba(color.r, color.g, color.b, a); }
}
