import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import "representations"
import "lib/Assets.js" as Assets
import "lib/Translations.js" as Tr

PlasmoidItem {
    id: root

    // ── Internationalization & Numbering ──
    readonly property string lang: {
        var l = Plasmoid.configuration.language
        if (l === "fa" || l === "en")
            return l
        return Qt.locale().name.indexOf("fa") === 0 ? "fa" : "en"
    }

    readonly property string numerals: {
        var n = Plasmoid.configuration.numerals
        if (n === "latin" || n === "persian")
            return n
        return lang === "fa" ? "persian" : "latin"
    }

    // ── Asset Symbols ──
    readonly property var symbols: Assets.sortedBy(
        Assets.parseList(Plasmoid.configuration.enabledAssets),
        Plasmoid.configuration.groupOrder)

    readonly property string compactSymbol: {
        var wanted = String(Plasmoid.configuration.compactSymbol || "").toUpperCase()
        if (wanted.length > 0 && symbols.indexOf(wanted) !== -1)
            return wanted
        return symbols.length > 0 ? symbols[0] : "USD"
    }

    readonly property bool showingFull:
        root.expanded || Plasmoid.formFactor === PlasmaCore.Types.Planar

    // ── Data Source ──
    RatesSource {
        id: rates
        baseUrl: Plasmoid.configuration.apiBaseUrl
        apiKey: Plasmoid.configuration.apiKey
        authMethod: Plasmoid.configuration.authMethod
        symbols: root.symbols
        cryptoBase: Plasmoid.configuration.cryptoBase
        lang: root.lang
        intervalMinutes: Math.max(1, Plasmoid.configuration.refreshInterval)
        autoRefresh: Plasmoid.configuration.autoRefresh
        active: root.showingFull || Plasmoid.formFactor !== PlasmaCore.Types.Planar
    }

    // ── Clock Tick ──
    property double clockTick: 0

    Timer {
        interval: 1000
        repeat: true
        running: root.showingFull
        onTriggered: root.clockTick = Date.now()
    }

    Plasmoid.title: Tr.t(lang, "appName")
    toolTipMainText: Tr.t(lang, "appName")
    toolTipSubText: Tr.t(lang, "tagline")

    Plasmoid.backgroundHints: Plasmoid.formFactor === PlasmaCore.Types.Planar
        ? PlasmaCore.Types.NoBackground
        : PlasmaCore.Types.DefaultBackground

    preferredRepresentation: Plasmoid.formFactor === PlasmaCore.Types.Planar
        ? fullRepresentation : compactRepresentation

    switchWidth: Kirigami.Units.gridUnit * 14
    switchHeight: Kirigami.Units.gridUnit * 10

    // ── Compact Panel Representation ──
    compactRepresentation: CompactRepresentation {
        source: rates
        symbol: root.compactSymbol
        symbols: root.symbols
        lang: root.lang
        numerals: root.numerals
        unitScale: Plasmoid.configuration.unitScale
        showIcon: Plasmoid.configuration.showIcon
        iconSize: Plasmoid.configuration.iconSize
        fontDelta: Plasmoid.configuration.fontDelta
        displayMode: Plasmoid.configuration.compactDisplayMode
        cycleInterval: Plasmoid.configuration.compactCycleInterval
        showChange: Plasmoid.configuration.compactShowChange
        showUnit: Plasmoid.configuration.showCompactUnit
        onToggleRequested: root.expanded = !root.expanded
    }

    // ── Full Popup / Desktop Representation ──
    fullRepresentation: FullRepresentation {
        source: rates
        symbols: root.symbols
        groupOrder: Plasmoid.configuration.groupOrder
        lang: root.lang
        numerals: root.numerals
        unitScale: Plasmoid.configuration.unitScale
        labelStyle: Plasmoid.configuration.labelStyle
        showIcon: Plasmoid.configuration.showIcon
        iconSize: Plasmoid.configuration.iconSize
        fontDelta: Plasmoid.configuration.fontDelta
        showChange: Plasmoid.configuration.showChange
        showDeltaBar: Plasmoid.configuration.showDeltaBar
        showGroupLabels: Plasmoid.configuration.showGroupLabels
        autoRefresh: Plasmoid.configuration.autoRefresh
        clockTick: root.clockTick

        widgetOpacity: Plasmoid.configuration.widgetOpacity
        backgroundStyle: Plasmoid.configuration.backgroundStyle
        widgetRadius: Plasmoid.configuration.widgetRadius
        viewLayout: Plasmoid.configuration.viewLayout
        cardBorder: Plasmoid.configuration.cardBorder
        changeBadgeStyle: Plasmoid.configuration.changeBadgeStyle
        showSearchBar: Plasmoid.configuration.showSearchBar
        showPriceDifference: Plasmoid.configuration.showPriceDifference
        showTimestamp: Plasmoid.configuration.showTimestamp
    }

    // ── Context Actions ──
    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: Tr.t(root.lang, "refresh")
            icon.name: "view-refresh"
            onTriggered: rates.refresh()
        }
    ]
}
