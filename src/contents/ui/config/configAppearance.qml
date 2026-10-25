import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import "../lib/Assets.js" as Assets
import "../lib/Translations.js" as Tr

KCM.SimpleKCM {
    id: page

    // ── Configuration Properties ──
    property string cfg_language: "auto"
    property string cfg_languageDefault: "auto"
    property string cfg_numerals: "auto"
    property string cfg_numeralsDefault: "auto"
    property string cfg_unitScale: "toman"
    property string cfg_unitScaleDefault: "toman"
    property string cfg_cryptoBase: "USD"
    property string cfg_cryptoBaseDefault: "USD"

    property string cfg_labelStyle: "name"
    property string cfg_labelStyleDefault: "name"
    property alias cfg_showIcon: showIcon.checked
    property bool cfg_showIconDefault: true
    property string cfg_iconSize: "small"
    property string cfg_iconSizeDefault: "small"
    property int cfg_fontDelta: 0
    property int cfg_fontDeltaDefault: 0

    property alias cfg_showChange: showChange.checked
    property alias cfg_showDeltaBar: showDeltaBar.checked
    property alias cfg_showGroupLabels: showGroupLabels.checked

    property int cfg_widgetOpacity: 100
    property int cfg_widgetOpacityDefault: 100
    property string cfg_backgroundStyle: "system"
    property string cfg_backgroundStyleDefault: "system"
    property int cfg_widgetRadius: 12
    property int cfg_widgetRadiusDefault: 12
    property string cfg_viewLayout: "list"
    property string cfg_viewLayoutDefault: "list"
    property alias cfg_cardBorder: cardBorder.checked
    property bool cfg_cardBorderDefault: false
    property string cfg_changeBadgeStyle: "pill"
    property string cfg_changeBadgeStyleDefault: "pill"
    property alias cfg_showSearchBar: showSearchBar.checked
    property bool cfg_showSearchBarDefault: true
    property alias cfg_showPriceDifference: showPriceDifference.checked
    property bool cfg_showPriceDifferenceDefault: false
    property alias cfg_showTimestamp: showTimestamp.checked
    property bool cfg_showTimestampDefault: true

    property string cfg_compactSymbol: "USD"
    property string cfg_compactSymbolDefault: "USD"
    property string cfg_compactDisplayMode: "single"
    property string cfg_compactDisplayModeDefault: "single"
    property int cfg_compactCycleInterval: 5
    property int cfg_compactCycleIntervalDefault: 5
    property alias cfg_compactShowChange: compactShowChange.checked
    property bool cfg_compactShowChangeDefault: true
    property alias cfg_showCompactUnit: showCompactUnit.checked
    property bool cfg_showCompactUnitDefault: true

    property string cfg_enabledAssets: ""

    // ── Translation ──
    readonly property string lang: {
        if (cfg_language === "fa" || cfg_language === "en")
            return cfg_language
        return Qt.locale().name.indexOf("fa") === 0 ? "fa" : "en"
    }

    function tr(key, args) { return Tr.t(lang, key, args) }

    LayoutMirroring.enabled: page.lang === "fa"
    LayoutMirroring.childrenInherit: true

    Kirigami.FormLayout {

        // ── Language & Regional Settings ──
        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgLanguage")
            textRole: "label"
            valueRole: "value"
            model: [
                { value: "auto", label: page.tr("cfgLangAuto") },
                { value: "fa",   label: page.tr("cfgLangFa") },
                { value: "en",   label: page.tr("cfgLangEn") }
            ]
            Component.onCompleted: currentIndex = indexOfValue(page.cfg_language)
            onActivated: page.cfg_language = currentValue
        }

        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgNumerals")
            textRole: "label"
            valueRole: "value"
            model: [
                { value: "auto",    label: page.tr("cfgNumAuto") },
                { value: "latin",   label: page.tr("cfgNumLatin") },
                { value: "persian", label: page.tr("cfgNumPersian") }
            ]
            Component.onCompleted: currentIndex = indexOfValue(page.cfg_numerals)
            onActivated: page.cfg_numerals = currentValue
        }

        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgUnitScale")
            textRole: "label"
            valueRole: "value"
            model: [
                { value: "toman", label: page.tr("cfgToman") },
                { value: "rial",  label: page.tr("cfgRial") }
            ]
            Component.onCompleted: currentIndex = indexOfValue(page.cfg_unitScale)
            onActivated: page.cfg_unitScale = currentValue
        }

        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgCryptoBase")
            textRole: "label"
            valueRole: "value"
            model: [
                { value: "USD", label: "USD" },
                { value: "IRT", label: page.tr("cfgToman") }
            ]
            Component.onCompleted: currentIndex = indexOfValue(page.cfg_cryptoBase)
            onActivated: page.cfg_cryptoBase = currentValue
        }

        // ── Customization & Appearance ──
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: page.tr("cfgCustomization")
        }

        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgBackgroundStyle")
            textRole: "label"
            valueRole: "value"
            model: [
                { value: "system",      label: page.tr("cfgBgSystem") },
                { value: "translucent", label: page.tr("cfgBgTranslucent") },
                { value: "glass",       label: page.tr("cfgBgGlass") },
                { value: "card",        label: page.tr("cfgBgCard") },
                { value: "frameless",   label: page.tr("cfgBgFrameless") }
            ]
            Component.onCompleted: currentIndex = Math.max(0, indexOfValue(page.cfg_backgroundStyle))
            onActivated: page.cfg_backgroundStyle = currentValue
        }

        RowLayout {
            Kirigami.FormData.label: page.tr("cfgWidgetOpacity")
            spacing: Kirigami.Units.smallSpacing

            QQC.Slider {
                id: opacitySlider
                from: 10
                to: 100
                stepSize: 5
                value: page.cfg_widgetOpacity
                onMoved: page.cfg_widgetOpacity = Math.round(value)
            }

            QQC.Label {
                text: Math.round(opacitySlider.value) + "%"
                Layout.preferredWidth: Kirigami.Units.gridUnit * 2.5
            }
        }

        RowLayout {
            Kirigami.FormData.label: page.tr("cfgWidgetRadius")
            spacing: Kirigami.Units.smallSpacing

            QQC.Slider {
                id: radiusSlider
                from: 0
                to: 32
                stepSize: 1
                value: page.cfg_widgetRadius
                onMoved: page.cfg_widgetRadius = Math.round(value)
            }

            QQC.Label {
                text: Math.round(radiusSlider.value) + " px"
                Layout.preferredWidth: Kirigami.Units.gridUnit * 2.5
            }
        }

        QQC.CheckBox {
            id: cardBorder
            text: page.tr("cfgCardBorder")
        }

        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgViewLayout")
            textRole: "label"
            valueRole: "value"
            model: [
                { value: "list",    label: page.tr("cfgLayoutList") },
                { value: "cards",   label: page.tr("cfgLayoutCards") },
                { value: "grid",    label: page.tr("cfgLayoutGrid") },
                { value: "compact", label: page.tr("cfgLayoutCompact") }
            ]
            Component.onCompleted: currentIndex = Math.max(0, indexOfValue(page.cfg_viewLayout))
            onActivated: page.cfg_viewLayout = currentValue
        }

        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgChangeBadgeStyle")
            textRole: "label"
            valueRole: "value"
            model: [
                { value: "pill", label: page.tr("cfgBadgePill") },
                { value: "text", label: page.tr("cfgBadgeText") },
                { value: "bar",  label: page.tr("cfgBadgeBar") }
            ]
            Component.onCompleted: currentIndex = Math.max(0, indexOfValue(page.cfg_changeBadgeStyle))
            onActivated: page.cfg_changeBadgeStyle = currentValue
        }

        QQC.CheckBox {
            id: showSearchBar
            text: page.tr("cfgShowSearchBar")
        }

        QQC.CheckBox {
            id: showPriceDifference
            text: page.tr("cfgShowPriceDiff")
        }

        QQC.CheckBox {
            id: showTimestamp
            text: page.tr("cfgShowTimestamp")
        }

        // ── Element Appearance ──
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: page.tr("cfgAppearance")
        }

        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgLabelStyle")
            textRole: "label"
            valueRole: "value"
            model: [
                { value: "name",   label: page.tr("cfgLabelName") },
                { value: "symbol", label: page.tr("cfgLabelSymbol") },
                { value: "both",   label: page.tr("cfgLabelBoth") }
            ]
            Component.onCompleted: currentIndex = indexOfValue(page.cfg_labelStyle)
            onActivated: page.cfg_labelStyle = currentValue
        }

        QQC.CheckBox {
            id: showIcon
            text: page.tr("cfgShowIcon")
        }

        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgIconSize")
            enabled: showIcon.checked
            textRole: "label"
            valueRole: "value"
            model: [
                { value: "small",  label: page.tr("cfgSizeSmall") },
                { value: "medium", label: page.tr("cfgSizeMedium") },
                { value: "large",  label: page.tr("cfgSizeLarge") }
            ]
            Component.onCompleted: currentIndex = indexOfValue(page.cfg_iconSize)
            onActivated: page.cfg_iconSize = currentValue
        }

        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgFontSize")
            textRole: "label"
            valueRole: "value"
            model: [
                { value: -1, label: page.tr("cfgSizeSmall") },
                { value: 0,  label: page.tr("cfgSizeNormal") },
                { value: 2,  label: page.tr("cfgSizeLarge") },
                { value: 4,  label: page.tr("cfgSizeHuge") }
            ]
            Component.onCompleted: currentIndex = Math.max(0, indexOfValue(page.cfg_fontDelta))
            onActivated: page.cfg_fontDelta = currentValue
        }

        QQC.CheckBox {
            id: showChange
            text: page.tr("cfgShowChange")
        }

        QQC.CheckBox {
            id: showDeltaBar
            text: page.tr("cfgShowDeltaBar")
        }

        QQC.CheckBox {
            id: showGroupLabels
            text: page.tr("cfgShowGroupLabels")
        }

        // ── Panel Representation Settings ──
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: page.tr("cfgPanelDisplay")
        }

        QQC.ComboBox {
            Kirigami.FormData.label: page.tr("cfgCompactDisplayMode")
            textRole: "label"
            valueRole: "value"
            model: [
                { value: "single", label: page.tr("cfgCompactSingle") },
                { value: "cycle",  label: page.tr("cfgCompactCycle") }
            ]
            Component.onCompleted: currentIndex = Math.max(0, indexOfValue(page.cfg_compactDisplayMode))
            onActivated: page.cfg_compactDisplayMode = currentValue
        }

        QQC.ComboBox {
            id: compactCombo
            Kirigami.FormData.label: page.tr("cfgCompactSymbol")
            visible: page.cfg_compactDisplayMode === "single"

            readonly property var options: {
                var list = Assets.parseList(page.cfg_enabledAssets)
                if (list.length === 0)
                    list = ["USD"]
                return Assets.sorted(list)
            }

            model: options
            displayText: currentIndex >= 0
                ? Assets.nameFor(options[currentIndex], page.lang) : ""

            delegate: QQC.ItemDelegate {
                required property int index
                required property string modelData
                width: compactCombo.width
                text: Assets.nameFor(modelData, page.lang)
                icon.source: Assets.iconFor(modelData)
                highlighted: compactCombo.highlightedIndex === index
            }

            function sync() {
                var i = options.indexOf(page.cfg_compactSymbol)
                currentIndex = i >= 0 ? i : 0
                if (i < 0 && options.length > 0)
                    page.cfg_compactSymbol = options[0]
            }

            Component.onCompleted: sync()
            onOptionsChanged: sync()
            onActivated: page.cfg_compactSymbol = options[currentIndex]
        }

        RowLayout {
            Kirigami.FormData.label: page.tr("cfgCompactCycleInterval")
            visible: page.cfg_compactDisplayMode === "cycle"
            spacing: Kirigami.Units.smallSpacing

            QQC.SpinBox {
                id: cycleSpin
                from: 2
                to: 60
                value: page.cfg_compactCycleInterval
                onValueModified: page.cfg_compactCycleInterval = value
            }

            QQC.Label {
                text: page.tr("cfgCompactCycleSeconds")
            }
        }

        QQC.CheckBox {
            id: compactShowChange
            text: page.tr("cfgCompactShowChange")
        }

        QQC.CheckBox {
            id: showCompactUnit
            text: page.tr("cfgShowCompactUnit")
        }
    }
}
