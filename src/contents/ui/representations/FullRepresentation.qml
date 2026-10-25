import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import "../components"
import "../lib/Assets.js" as Assets
import "../lib/Format.js" as Fmt
import "../lib/Ui.js" as Ui
import "../lib/Translations.js" as Tr

Item {
    id: view

    // ── Input Properties ──
    required property var source
    property string lang: "en"
    property string numerals: "latin"
    property string unitScale: "toman"
    property string labelStyle: "name"
    property bool showIcon: true
    property string iconSize: "small"
    property int fontDelta: 0
    property bool showChange: true
    property bool showDeltaBar: true
    property bool showGroupLabels: true
    property bool autoRefresh: true
    property var symbols: []
    property string groupOrder: "fiat,metal,crypto"
    property double clockTick: 0

    // ── Customization Properties ──
    property int widgetOpacity: 100
    property string backgroundStyle: "system"
    property int widgetRadius: 12
    property string viewLayout: "list"
    property bool cardBorder: false
    property string changeBadgeStyle: "pill"
    property bool showSearchBar: true
    property bool showPriceDifference: false
    property bool showTimestamp: true

    // ── Translation & State ──
    function tr(key, args) { return Tr.t(lang, key, args) }

    readonly property bool empty: symbols.length === 0
    property var entries: []
    property real priceColumn: 0

    function groupTitle(group) {
        if (group === "metal")
            return tr("groupMetal")
        if (group === "crypto")
            return tr("groupCrypto")
        return tr("groupFiat")
    }

    function _matchesFilter(sym, q) {
        if (!q || q.length === 0)
            return true
        var s = sym.toLowerCase()
        var enName = Assets.nameFor(sym, "en").toLowerCase()
        var faName = Assets.nameFor(sym, "fa")
        return s.indexOf(q) !== -1 || enName.indexOf(q) !== -1 || faName.indexOf(q) !== -1
    }

    function rebuild() {
        var out = []
        var lastGroup = ""
        var ordered = Assets.sortedBy(symbols, groupOrder)
        var q = (searchBarItem && searchBarItem.text) ? searchBarItem.text.trim().toLowerCase() : ""

        var filtered = []
        for (var k = 0; k < ordered.length; ++k) {
            if (_matchesFilter(ordered[k], q))
                filtered.push(ordered[k])
        }

        if (viewLayout === "grid") {
            var groupBuckets = {}
            var groupSequence = []
            for (var i = 0; i < filtered.length; ++i) {
                var sym = filtered[i]
                var g = Assets.typeFor(sym)
                if (!groupBuckets[g]) {
                    groupBuckets[g] = []
                    groupSequence.push(g)
                }
                groupBuckets[g].push(sym)
            }

            for (var gi = 0; gi < groupSequence.length; ++gi) {
                var grp = groupSequence[gi]
                var grpItems = groupBuckets[grp]
                for (var j = 0; j < grpItems.length; j += 2) {
                    out.push({
                        isGridRow: true,
                        group: (j === 0 && showGroupLabels) ? grp : "",
                        first: gi === 0 && j === 0,
                        leftSymbol: grpItems[j],
                        rightSymbol: (j + 1 < grpItems.length) ? grpItems[j + 1] : ""
                    })
                }
            }
        } else {
            for (var m = 0; m < filtered.length; ++m) {
                var itemSym = filtered[m]
                var itemGroup = Assets.typeFor(itemSym)
                var opensGroup = showGroupLabels && itemGroup !== lastGroup
                lastGroup = itemGroup
                out.push({
                    isGridRow: false,
                    symbol: itemSym,
                    group: opensGroup ? itemGroup : "",
                    first: m === 0
                })
            }
        }

        entries = out
    }

    TextMetrics {
        id: metrics
        font.bold: true
        font.family: Kirigami.Theme.defaultFont.family
        font.pointSize: Kirigami.Theme.defaultFont.pointSize + Ui.fontDelta(view.fontDelta) + 1
    }

    function measure() {
        var widest = 0
        var map = source.rates
        for (var i = 0; i < symbols.length; ++i) {
            var r = map[symbols[i]]
            if (!r)
                continue
            metrics.text = Fmt.formatNumber(
                Fmt.scalePrice(r.price, r.unit, unitScale), r.decimals, numerals)
            widest = Math.max(widest, metrics.advanceWidth)
        }
        priceColumn = widest > 0 ? Math.ceil(widest) + 2 : 0
    }

    // ── Signal Handlers ──
    onSymbolsChanged: { rebuild(); measure() }
    onGroupOrderChanged: rebuild()
    onShowGroupLabelsChanged: rebuild()
    onViewLayoutChanged: { rebuild(); measure() }
    onLangChanged: { rebuild(); measure() }
    onNumeralsChanged: measure()
    onUnitScaleChanged: measure()
    onFontDeltaChanged: measure()
    Component.onCompleted: { rebuild(); measure() }

    Connections {
        target: view.source
        function onRatesChanged() { view.measure() }
    }

    // ── Layout Sizing ──
    implicitWidth: viewLayout === "grid"
        ? Kirigami.Units.gridUnit * 28
        : Kirigami.Units.gridUnit * 20
    implicitHeight: Math.min(Kirigami.Units.gridUnit * 28,
                             layout.implicitHeight + Kirigami.Units.largeSpacing * 2)

    LayoutMirroring.enabled: view.lang === "fa"
    LayoutMirroring.childrenInherit: true

    // ── Custom Background Container ──
    Rectangle {
        id: customBg
        anchors.fill: parent
        radius: view.widgetRadius
        visible: view.backgroundStyle !== "frameless"
        z: -1

        color: {
            var alpha = (view.widgetOpacity / 100.0)
            if (view.backgroundStyle === "glass")
                return Qt.alpha(Kirigami.Theme.backgroundColor, alpha * 0.72)
            if (view.backgroundStyle === "translucent")
                return Qt.alpha(Kirigami.Theme.backgroundColor, alpha * 0.45)
            if (view.backgroundStyle === "card")
                return Qt.alpha(Kirigami.Theme.backgroundColor, alpha)
            return Qt.alpha(Kirigami.Theme.backgroundColor, alpha)
        }

        border.color: view.cardBorder
            ? Qt.alpha(Kirigami.Theme.highlightColor, 0.35)
            : (view.backgroundStyle === "glass" ? Qt.alpha(Kirigami.Theme.textColor, 0.15) : "transparent")
        border.width: (view.cardBorder || view.backgroundStyle === "glass") ? 1 : 0
    }

    // ── Main Layout ──
    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing
        spacing: Kirigami.Units.smallSpacing

        // ── Header Bar ──
        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            PlasmaComponents.Label {
                text: view.tr("appName")
                font.pointSize: Kirigami.Theme.defaultFont.pointSize + 3
                font.weight: Font.Bold
                font.letterSpacing: view.lang === "fa" ? 0 : 0.6
            }

            Item { Layout.fillWidth: true }

            PlasmaComponents.Label {
                text: {
                    view.clockTick
                    if (view.source.loading)
                        return view.tr("refreshing")
                    if (view.source.lastUpdated === 0)
                        return view.tr("never")
                    return view.tr("updated", Fmt.relativeTime(
                        view.source.lastUpdated, view.lang, view.numerals))
                }
                font: Kirigami.Theme.smallFont
                opacity: 0.6
                elide: Text.ElideRight
                visible: view.showTimestamp
                Layout.maximumWidth: Kirigami.Units.gridUnit * 9
            }

            RefreshControl {
                busy: view.source.loading
                progress: {
                    view.clockTick
                    if (!view.autoRefresh || view.source.nextRefreshAt === 0)
                        return 0
                    var total = Math.max(1, view.source.intervalMinutes) * 60000
                    return (view.source.nextRefreshAt - Date.now()) / total
                }
                showTrack: view.autoRefresh
                tooltip: view.tr("refresh")
                tooltipSub: {
                    view.clockTick
                    if (!view.autoRefresh)
                        return view.tr("manualOnly")
                    if (view.source.nextRefreshAt === 0)
                        return ""
                    return view.tr("nextIn", Fmt.countdown(
                        view.source.nextRefreshAt - Date.now(), view.lang, view.numerals))
                }
                onClicked: view.source.refresh()
            }
        }

        // ── Search & Filter Bar ──
        Kirigami.SearchField {
            id: searchBarItem
            Layout.fillWidth: true
            visible: view.showSearchBar && !view.empty
            placeholderText: view.tr("searchPlaceholder")
            onTextChanged: view.rebuild()
        }

        // ── Separator Line ──
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 1
            color: Qt.alpha(Kirigami.Theme.textColor, 0.12)
        }

        // ── Rates List / Cards View ──
        QQC.ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: rateList.contentHeight
            visible: !view.empty

            ListView {
                id: rateList
                model: view.entries
                spacing: view.viewLayout === "cards" ? Kirigami.Units.smallSpacing : 0
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                reuseItems: true
                cacheBuffer: 0

                delegate: ColumnLayout {
                    id: entryDelegate
                    required property var modelData

                    width: rateList.width
                    spacing: 0

                    // ── Group Header ──
                    GroupLabel {
                        Layout.fillWidth: true
                        Layout.topMargin: entryDelegate.modelData.first
                            ? 0 : Kirigami.Units.largeSpacing
                        Layout.bottomMargin: Kirigami.Units.smallSpacing / 2
                        visible: entryDelegate.modelData.group.length > 0
                        title: visible ? view.groupTitle(entryDelegate.modelData.group) : ""
                        uppercase: view.lang !== "fa"
                    }

                    // ── Single Row (List / Cards / Compact) ──
                    RateRow {
                        Layout.fillWidth: true
                        visible: !entryDelegate.modelData.isGridRow
                        symbol: entryDelegate.modelData.symbol || ""
                        rate: view.source.rates[entryDelegate.modelData.symbol]
                        lang: view.lang
                        numerals: view.numerals
                        unitScale: view.unitScale
                        labelStyle: view.labelStyle
                        showIcon: view.showIcon
                        iconSize: view.iconSize
                        fontDelta: view.fontDelta
                        showChange: view.showChange
                        showDeltaBar: view.showDeltaBar
                        priceColumnWidth: view.priceColumn
                        viewLayout: view.viewLayout
                        changeBadgeStyle: view.changeBadgeStyle
                        showPriceDifference: view.showPriceDifference
                        cardRadius: Math.min(16, view.widgetRadius)
                    }

                    // ── 2-Column Grid Row ──
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Kirigami.Units.smallSpacing
                        visible: entryDelegate.modelData.isGridRow

                        RateRow {
                            Layout.fillWidth: true
                            symbol: entryDelegate.modelData.leftSymbol || ""
                            rate: view.source.rates[entryDelegate.modelData.leftSymbol]
                            lang: view.lang
                            numerals: view.numerals
                            unitScale: view.unitScale
                            labelStyle: view.labelStyle
                            showIcon: view.showIcon
                            iconSize: view.iconSize
                            fontDelta: view.fontDelta
                            showChange: view.showChange
                            showDeltaBar: view.showDeltaBar
                            priceColumnWidth: 0
                            viewLayout: "cards"
                            changeBadgeStyle: view.changeBadgeStyle
                            showPriceDifference: view.showPriceDifference
                            cardRadius: Math.min(16, view.widgetRadius)
                        }

                        RateRow {
                            Layout.fillWidth: true
                            visible: entryDelegate.modelData.rightSymbol && entryDelegate.modelData.rightSymbol.length > 0
                            symbol: entryDelegate.modelData.rightSymbol || ""
                            rate: view.source.rates[entryDelegate.modelData.rightSymbol]
                            lang: view.lang
                            numerals: view.numerals
                            unitScale: view.unitScale
                            labelStyle: view.labelStyle
                            showIcon: view.showIcon
                            iconSize: view.iconSize
                            fontDelta: view.fontDelta
                            showChange: view.showChange
                            showDeltaBar: view.showDeltaBar
                            priceColumnWidth: 0
                            viewLayout: "cards"
                            changeBadgeStyle: view.changeBadgeStyle
                            showPriceDifference: view.showPriceDifference
                            cardRadius: Math.min(16, view.widgetRadius)
                        }
                    }
                }
            }
        }

        // ── Empty State ──
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: view.empty
            spacing: Kirigami.Units.smallSpacing

            Item { Layout.fillHeight: true }

            Kirigami.Icon {
                Layout.alignment: Qt.AlignHCenter
                source: "view-financial-list"
                implicitWidth: Kirigami.Units.iconSizes.large
                implicitHeight: Kirigami.Units.iconSizes.large
                opacity: 0.45
            }

            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: Kirigami.Units.smallSpacing
                text: view.tr("emptyTitle")
                font.weight: Font.DemiBold
            }

            PlasmaComponents.Label {
                Layout.fillWidth: true
                Layout.leftMargin: Kirigami.Units.gridUnit
                Layout.rightMargin: Kirigami.Units.gridUnit
                text: view.tr("emptyBody")
                font: Kirigami.Theme.smallFont
                opacity: 0.7
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }

            PlasmaComponents.Button {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: Kirigami.Units.smallSpacing
                text: view.tr("openSettings")
                icon.name: "configure"
                onClicked: Plasmoid.internalAction("configure").trigger()
            }

            Item { Layout.fillHeight: true }
        }

        // ── Error Banner ──
        Notice {
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.smallSpacing
            visible: view.source.errorText.length > 0
            severity: "error"
            iconName: "network-disconnect-symbolic"
            title: view.tr("errorTitle")
            body: view.source.errorText
            actionText: view.tr("retry")
            onActionTriggered: view.source.refresh()
        }
    }
}
