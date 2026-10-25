import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import "../lib/Assets.js" as Assets
import "../lib/Format.js" as Fmt
import "../lib/Ui.js" as Ui

MouseArea {
    id: row

    // ── Properties ──
    required property string symbol
    property var rate: undefined
    property string lang: "en"
    property string numerals: "latin"
    property string unitScale: "toman"
    property string labelStyle: "name"
    property bool showIcon: true
    property string iconSize: "small"
    property int fontDelta: 0
    property bool showChange: true
    property bool showDeltaBar: true
    property real saturationPercent: 3.0
    property int priceColumnWidth: 0
    property string viewLayout: "list"
    property string changeBadgeStyle: "pill"
    property bool showPriceDifference: false
    property int cardRadius: 8

    // ── Computed Properties ──
    readonly property int iconPx: Ui.iconPx(iconSize, Kirigami.Units.iconSizes)
    readonly property int basePt: Kirigami.Theme.defaultFont.pointSize + Ui.fontDelta(fontDelta)

    readonly property bool hasRate: rate !== undefined && rate !== null
    readonly property real pct: hasRate && !isNaN(rate.changePercent) ? rate.changePercent : 0
    readonly property string direction: hasRate ? rate.direction : "flat"
    readonly property color moveColor: direction === "up"
        ? Kirigami.Theme.positiveTextColor
        : (direction === "down" ? Kirigami.Theme.negativeTextColor
                                : Kirigami.Theme.disabledTextColor)

    readonly property real displayPrice: hasRate
        ? Fmt.scalePrice(rate.price, rate.unit, unitScale) : NaN
    readonly property string priceText: hasRate
        ? Fmt.formatNumber(displayPrice, rate.decimals, numerals) : "—"
    readonly property string unitText: hasRate
        ? Fmt.unitLabel(rate.unit, unitScale, lang) : ""

    implicitHeight: {
        if (viewLayout === "compact")
            return Math.max(Kirigami.Units.gridUnit * 1.6, iconPx + 4)
        if (viewLayout === "cards")
            return Math.max(Kirigami.Units.gridUnit * 2.3, iconPx + Kirigami.Units.smallSpacing * 3)
        return Math.max(Kirigami.Units.gridUnit * 2, iconPx + Kirigami.Units.smallSpacing * 2)
    }

    hoverEnabled: true
    acceptedButtons: Qt.NoButton

    // ── Tooltip ──
    PlasmaCore.ToolTipArea {
        anchors.fill: parent
        mainText: Assets.nameFor(row.symbol, row.lang) + "  ·  " + Assets.canonicalSymbol(row.symbol)
        subText: row.hasRate
            ? (row.priceText + " " + row.unitText
               + (isNaN(row.pct) ? "" : "   " + Fmt.formatPercent(row.pct, row.numerals))
               + "\n" + Fmt.relativeTime(row.rate.updatedAt, row.lang, row.numerals))
            : ""
    }

    // ── Background & Card Frame ──
    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: row.viewLayout === "cards" ? 0 : -Kirigami.Units.smallSpacing
        anchors.rightMargin: row.viewLayout === "cards" ? 0 : -Kirigami.Units.smallSpacing
        anchors.topMargin: row.viewLayout === "cards" ? 2 : 0
        anchors.bottomMargin: row.viewLayout === "cards" ? 2 : 0
        radius: row.viewLayout === "cards" ? row.cardRadius : Kirigami.Units.smallSpacing

        color: {
            if (row.viewLayout === "cards")
                return Qt.alpha(Kirigami.Theme.highlightColor, row.containsMouse ? 0.16 : 0.07)
            return Kirigami.Theme.highlightColor
        }
        border.color: row.viewLayout === "cards"
            ? Qt.alpha(Kirigami.Theme.highlightColor, row.containsMouse ? 0.40 : 0.15)
            : "transparent"
        border.width: row.viewLayout === "cards" ? 1 : 0
        opacity: row.viewLayout === "cards" ? 1.0 : (row.containsMouse ? 0.10 : 0)

        Behavior on opacity {
            NumberAnimation { duration: Kirigami.Units.shortDuration }
        }
        Behavior on color {
            ColorAnimation { duration: Kirigami.Units.shortDuration }
        }
    }

    // ── Content Row ──
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: row.viewLayout === "cards" ? Kirigami.Units.smallSpacing * 1.5 : 0
        anchors.rightMargin: row.viewLayout === "cards" ? Kirigami.Units.smallSpacing * 1.5 : 0
        spacing: Kirigami.Units.smallSpacing

        // ── Delta Indicator Bar ──
        Item {
            Layout.preferredWidth: (row.showDeltaBar && row.changeBadgeStyle !== "pill") ? 3 : 0
            Layout.fillHeight: true
            visible: row.showDeltaBar && row.changeBadgeStyle !== "pill"

            Rectangle {
                width: 3
                radius: 1.5
                color: row.moveColor
                opacity: row.hasRate ? 0.9 : 0.25
                anchors.horizontalCenter: parent.horizontalCenter

                readonly property real half: parent.height / 2 - 3
                readonly property real magnitude: Math.min(1,
                    Math.abs(row.pct) / row.saturationPercent)

                height: Math.max(2, magnitude * half)
                y: row.direction === "down"
                    ? parent.height / 2
                    : parent.height / 2 - height

                Behavior on height {
                    NumberAnimation {
                        duration: Kirigami.Units.longDuration
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }

        // ── Asset Icon ──
        Image {
            source: Assets.iconFor(row.symbol)
            visible: row.showIcon
            sourceSize.width: row.iconPx
            sourceSize.height: row.iconPx
            Layout.preferredWidth: visible ? row.iconPx : 0
            Layout.preferredHeight: row.iconPx
            Layout.leftMargin: visible ? (row.viewLayout === "cards" ? 0 : Kirigami.Units.smallSpacing) : 0
            fillMode: Image.PreserveAspectFit
            smooth: true
            asynchronous: true
            cache: true
            mirror: false
            opacity: row.hasRate ? 1 : 0.4
        }

        // ── Asset Label ──
        PlasmaComponents.Label {
            text: Assets.labelFor(row.symbol, row.lang, row.labelStyle)
            font.pointSize: row.basePt
            elide: Text.ElideRight
            maximumLineCount: 1
            Layout.fillWidth: true
            Layout.leftMargin: row.showIcon ? 0 : Kirigami.Units.smallSpacing
            opacity: row.hasRate && !row.rate.stale ? 1 : 0.55
        }

        // ── Price Column ──
        ColumnLayout {
            spacing: 0
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

            RowLayout {
                spacing: Kirigami.Units.smallSpacing / 2
                Layout.alignment: Qt.AlignRight

                PlasmaComponents.Label {
                    id: priceLabel
                    text: row.priceText
                    font.bold: true
                    font.pointSize: row.basePt + 1
                    horizontalAlignment: Text.AlignRight
                    Layout.preferredWidth: (row.viewLayout === "list" && row.priceColumnWidth > 0)
                        ? row.priceColumnWidth : implicitWidth
                    opacity: row.hasRate && !row.rate.stale ? 1 : 0.55
                }

                PlasmaComponents.Label {
                    text: row.unitText
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    opacity: 0.5
                    visible: text.length > 0
                }
            }

            PlasmaComponents.Label {
                visible: row.showPriceDifference && row.hasRate && !isNaN(row.rate.change) && row.rate.change !== 0
                text: (row.rate.change > 0 ? "+" : "") + Fmt.formatNumber(
                    Fmt.scalePrice(row.rate.change, row.rate.unit, row.unitScale),
                    row.rate.decimals, row.numerals)
                font.pointSize: Kirigami.Theme.smallFont.pointSize - 2
                color: row.moveColor
                horizontalAlignment: Text.AlignRight
                Layout.alignment: Qt.AlignRight
            }
        }

        // ── Change Badge / Pill ──
        Rectangle {
            id: changePill
            visible: row.showChange && row.hasRate && row.changeBadgeStyle === "pill"
            Layout.preferredWidth: pillContent.implicitWidth + Kirigami.Units.smallSpacing * 1.6
            Layout.preferredHeight: Math.max(Kirigami.Units.gridUnit * 1.1, pillContent.implicitHeight + 4)
            Layout.alignment: Qt.AlignVCenter
            radius: Kirigami.Units.smallSpacing
            color: Qt.alpha(row.moveColor, 0.15)
            border.color: Qt.alpha(row.moveColor, 0.45)
            border.width: 1

            RowLayout {
                id: pillContent
                anchors.centerIn: parent
                spacing: 2

                PlasmaComponents.Label {
                    text: row.direction === "up" ? "▲" : (row.direction === "down" ? "▼" : "")
                    font.pointSize: Kirigami.Theme.smallFont.pointSize - 3
                    color: row.moveColor
                    visible: text.length > 0
                }

                PlasmaComponents.Label {
                    text: Fmt.formatPercent(row.pct, row.numerals)
                    font.pointSize: Kirigami.Theme.smallFont.pointSize - 1
                    font.bold: true
                    color: row.moveColor
                }
            }
        }

        // ── Change Simple Text ──
        PlasmaComponents.Label {
            text: row.hasRate ? Fmt.formatPercent(row.pct, row.numerals) : ""
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            color: row.moveColor
            horizontalAlignment: Text.AlignRight
            Layout.preferredWidth: Kirigami.Units.gridUnit * 3
            Layout.leftMargin: Kirigami.Units.smallSpacing
            visible: row.showChange && row.changeBadgeStyle === "text"
        }
    }
}
