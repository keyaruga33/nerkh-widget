import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import "../lib/Assets.js" as Assets
import "../lib/Format.js" as Fmt
import "../lib/Ui.js" as Ui
import "../lib/Translations.js" as Tr

MouseArea {
    id: compact

    // ── Input Properties ──
    required property var source
    property string symbol: "USD"
    property var symbols: []
    property string lang: "en"
    property string numerals: "latin"
    property string unitScale: "toman"
    property bool showIcon: true
    property string iconSize: "small"
    property int fontDelta: 0
    property string displayMode: "single"
    property int cycleInterval: 5
    property bool showChange: true
    property bool showUnit: true

    // ── Cycling State ──
    property int _cycleIndex: 0

    Timer {
        id: cycleTimer
        interval: Math.max(2, compact.cycleInterval) * 1000
        repeat: true
        running: compact.displayMode === "cycle" && compact.symbols.length > 1
        onTriggered: {
            compact._cycleIndex = (compact._cycleIndex + 1) % compact.symbols.length
        }
    }

    // ── Active Symbol & Rate ──
    readonly property string effectiveSymbol: {
        if (compact.displayMode === "cycle" && compact.symbols.length > 0)
            return compact.symbols[compact._cycleIndex % compact.symbols.length]
        return compact.symbol
    }

    readonly property int iconPx: Ui.iconPx(iconSize, Kirigami.Units.iconSizes)
    readonly property var rate: source.rates[effectiveSymbol]
    readonly property bool hasRate: rate !== undefined && rate !== null
    readonly property bool vertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical

    readonly property color moveColor: !hasRate
        ? Kirigami.Theme.disabledTextColor
        : (rate.direction === "up" ? Kirigami.Theme.positiveTextColor
          : (rate.direction === "down" ? Kirigami.Theme.negativeTextColor
                                       : Kirigami.Theme.disabledTextColor))

    readonly property string priceText: hasRate
        ? Fmt.formatNumber(Fmt.scalePrice(rate.price, rate.unit, unitScale),
                           rate.decimals, numerals)
        : "—"

    readonly property string unitText: hasRate
        ? Fmt.unitLabel(rate.unit, unitScale, lang) : ""

    signal toggleRequested()

    activeFocusOnTab: true
    hoverEnabled: true
    Layout.minimumWidth: vertical ? 0 : content.implicitWidth
    Layout.minimumHeight: vertical ? content.implicitHeight : 0
    Layout.preferredWidth: Layout.minimumWidth
    Layout.preferredHeight: Layout.minimumHeight

    onClicked: compact.toggleRequested()

    // ── Tooltip ──
    PlasmaCore.ToolTipArea {
        anchors.fill: parent
        mainText: Assets.nameFor(compact.effectiveSymbol, compact.lang) + "  ·  " + Assets.canonicalSymbol(compact.effectiveSymbol)
        subText: compact.hasRate
            ? (compact.priceText + " "
               + compact.unitText
               + (isNaN(compact.rate.changePercent) ? "" : "   " + Fmt.formatPercent(compact.rate.changePercent, compact.numerals))
               + "\n" + Fmt.relativeTime(compact.rate.updatedAt, compact.lang, compact.numerals))
            : Tr.t(compact.lang, "loading")
    }

    LayoutMirroring.enabled: compact.lang === "fa"
    LayoutMirroring.childrenInherit: true

    // ── Content Layout ──
    GridLayout {
        id: content
        anchors.centerIn: parent
        columns: compact.vertical ? 1 : 5
        rowSpacing: 0
        columnSpacing: Kirigami.Units.smallSpacing

        // ── Asset Icon ──
        Image {
            source: Assets.iconFor(compact.effectiveSymbol)
            visible: compact.showIcon
            sourceSize.width: compact.iconPx
            sourceSize.height: compact.iconPx
            Layout.preferredWidth: visible ? compact.iconPx : 0
            Layout.preferredHeight: visible ? compact.iconPx : 0
            Layout.alignment: Qt.AlignHCenter
            fillMode: Image.PreserveAspectFit
            smooth: true
            asynchronous: true
            cache: true
        }

        // ── Price Label ──
        PlasmaComponents.Label {
            text: compact.priceText
            font.bold: true
            font.pointSize: (compact.vertical
                ? Kirigami.Theme.smallFont.pointSize
                : Kirigami.Theme.defaultFont.pointSize) + Ui.fontDelta(compact.fontDelta)
            Layout.alignment: Qt.AlignHCenter
        }

        // ── Unit Label ──
        PlasmaComponents.Label {
            text: compact.unitText
            font.pointSize: Kirigami.Theme.smallFont.pointSize - 1
            opacity: 0.55
            visible: compact.showUnit && !compact.vertical && text.length > 0
            Layout.alignment: Qt.AlignHCenter
        }

        // ── Direction Marker ──
        Canvas {
            id: marker
            implicitWidth: compact.iconPx / 2
            implicitHeight: compact.iconPx / 2
            Layout.alignment: Qt.AlignHCenter
            visible: compact.showChange && compact.hasRate && compact.rate.direction !== "flat"

            readonly property color tone: compact.moveColor
            readonly property bool up: compact.hasRate && compact.rate.direction === "up"

            onToneChanged: requestPaint()
            onUpChanged: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.fillStyle = tone
                ctx.beginPath()
                if (up) {
                    ctx.moveTo(width / 2, 0)
                    ctx.lineTo(width, height)
                    ctx.lineTo(0, height)
                } else {
                    ctx.moveTo(0, 0)
                    ctx.lineTo(width, 0)
                    ctx.lineTo(width / 2, height)
                }
                ctx.closePath()
                ctx.fill()
            }
        }
    }
}
