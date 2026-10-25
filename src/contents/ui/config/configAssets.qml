import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import "../lib/Assets.js" as Assets
import "../lib/Translations.js" as Tr

KCM.SimpleKCM {
    id: page

    property string cfg_enabledAssets: ""
    property string cfg_enabledAssetsDefault: "USD,EUR,IR_GOLD_18K,IR_COIN_EMAMI,BTC,ETH,USDT"
    property string cfg_groupOrder: "fiat,metal,crypto"
    property string cfg_groupOrderDefault: "fiat,metal,crypto"
    property string cfg_language: "auto"

    readonly property string lang: {
        if (cfg_language === "fa" || cfg_language === "en")
            return cfg_language
        return Qt.locale().name.indexOf("fa") === 0 ? "fa" : "en"
    }

    function tr(key, args) { return Tr.t(lang, key, args) }

    readonly property var selected: Assets.parseList(cfg_enabledAssets)
    readonly property var groups: Assets.parseGroupOrder(cfg_groupOrder)

    function isOn(symbol) { return selected.indexOf(symbol) !== -1 }

    function _commit(list) { cfg_enabledAssets = list.join(",") }

    function add(symbol) {
        var list = Assets.parseList(cfg_enabledAssets)
        if (list.indexOf(symbol) === -1) {
            list.push(symbol)
            _commit(list)
        }
    }

    function remove(symbol) {
        var list = Assets.parseList(cfg_enabledAssets)
        var i = list.indexOf(symbol)
        if (i !== -1) {
            list.splice(i, 1)
            _commit(list)
        }
    }

    function setOn(symbol, on) { on ? add(symbol) : remove(symbol) }

    function moveAsset(symbol, delta) {
        var list = Assets.parseList(cfg_enabledAssets)
        var g = Assets.typeFor(symbol)
        var here = list.indexOf(symbol)
        if (here === -1)
            return
        var target = -1
        for (var j = here + delta; j >= 0 && j < list.length; j += delta) {
            if (Assets.typeFor(list[j]) === g) { target = j; break }
        }
        if (target === -1)
            return
        var tmp = list[here]
        list[here] = list[target]
        list[target] = tmp
        _commit(list)
    }

    function moveGroup(group, delta) {
        var order = Assets.parseGroupOrder(cfg_groupOrder)
        var i = order.indexOf(group)
        var j = i + delta
        if (i === -1 || j < 0 || j >= order.length)
            return
        var tmp = order[i]
        order[i] = order[j]
        order[j] = tmp
        cfg_groupOrder = order.join(",")
    }

    function groupTitle(g) {
        return g === "metal" ? tr("groupMetal")
             : (g === "crypto" ? tr("groupCrypto") : tr("groupFiat"))
    }

    function selectedOfGroup(g) {
        return selected.filter(function (s) { return Assets.typeFor(s) === g })
    }

    function matches(asset) {
        var q = search.text.trim().toLowerCase()
        if (q.length === 0)
            return true
        var qAlt = q.indexOf("-") !== -1 ? q.replace(/-/g, "_") : q.replace(/_/g, "-")
        var sym = asset.symbol.toLowerCase()
        return sym.indexOf(q) !== -1
            || sym.indexOf(qAlt) !== -1
            || asset.en.toLowerCase().indexOf(q) !== -1
            || asset.fa.indexOf(search.text.trim()) !== -1
    }

    LayoutMirroring.enabled: page.lang === "fa"
    LayoutMirroring.childrenInherit: true

    header: ColumnLayout {
        spacing: Kirigami.Units.smallSpacing

        RowLayout {
            Layout.fillWidth: true
            Layout.margins: Kirigami.Units.largeSpacing
            spacing: Kirigami.Units.smallSpacing

            Kirigami.SearchField {
                id: search
                Layout.fillWidth: true
            }

            QQC.Label {
                text: page.tr("cfgSelectedCount", page.selected.length)
                opacity: 0.6
            }

            QQC.ToolButton {
                text: page.tr("cfgSelectNone")
                enabled: page.selected.length > 0
                onClicked: page.cfg_enabledAssets = ""
            }
        }
    }

    ColumnLayout {
        spacing: Kirigami.Units.largeSpacing

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing
            visible: page.selected.length > 0 && search.text.trim().length === 0

            Kirigami.Heading {
                level: 3
                text: page.tr("cfgArrange")
            }

            QQC.Label {
                Layout.fillWidth: true
                text: page.tr("cfgArrangeHint")
                wrapMode: Text.WordWrap
                font.pointSize: Kirigami.Theme.smallFont.pointSize
                opacity: 0.7
            }

            Repeater {
                model: page.groups

                delegate: ColumnLayout {
                    id: groupBlock
                    required property string modelData
                    required property int index

                    readonly property var items: page.selectedOfGroup(modelData)

                    Layout.fillWidth: true
                    spacing: 0
                    visible: items.length > 0

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: Kirigami.Units.smallSpacing
                        spacing: Kirigami.Units.smallSpacing

                        Kirigami.Heading {
                            level: 4
                            opacity: 0.7
                            text: page.groupTitle(groupBlock.modelData)
                        }
                        Item { Layout.fillWidth: true }
                        QQC.ToolButton {
                            icon.name: "go-up"
                            display: QQC.AbstractButton.IconOnly
                            enabled: groupBlock.index > 0
                            QQC.ToolTip.text: page.tr("cfgMoveGroupUp")
                            QQC.ToolTip.visible: hovered
                            onClicked: page.moveGroup(groupBlock.modelData, -1)
                        }
                        QQC.ToolButton {
                            icon.name: "go-down"
                            display: QQC.AbstractButton.IconOnly
                            enabled: groupBlock.index < page.groups.length - 1
                            QQC.ToolTip.text: page.tr("cfgMoveGroupDown")
                            QQC.ToolTip.visible: hovered
                            onClicked: page.moveGroup(groupBlock.modelData, 1)
                        }
                    }

                    Kirigami.Separator { Layout.fillWidth: true }

                    Repeater {
                        model: groupBlock.items

                        delegate: RowLayout {
                            id: pick
                            required property var modelData
                            required property int index

                            Layout.fillWidth: true
                            spacing: Kirigami.Units.smallSpacing

                            Image {
                                source: Assets.iconFor(pick.modelData)
                                sourceSize.width: Kirigami.Units.iconSizes.small
                                sourceSize.height: Kirigami.Units.iconSizes.small
                                Layout.preferredWidth: Kirigami.Units.iconSizes.small
                                Layout.preferredHeight: Kirigami.Units.iconSizes.small
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                            }

                            QQC.Label {
                                Layout.fillWidth: true
                                text: Assets.nameFor(pick.modelData, page.lang)
                                elide: Text.ElideRight
                            }

                            QQC.Label {
                                text: pick.modelData
                                font.family: "monospace"
                                font.pointSize: Kirigami.Theme.smallFont.pointSize
                                opacity: 0.45
                            }

                            QQC.ToolButton {
                                icon.name: "go-up"
                                display: QQC.AbstractButton.IconOnly
                                enabled: pick.index > 0
                                onClicked: page.moveAsset(pick.modelData, -1)
                            }
                            QQC.ToolButton {
                                icon.name: "go-down"
                                display: QQC.AbstractButton.IconOnly
                                enabled: pick.index < groupBlock.items.length - 1
                                onClicked: page.moveAsset(pick.modelData, 1)
                            }
                            QQC.ToolButton {
                                icon.name: "list-remove"
                                display: QQC.AbstractButton.IconOnly
                                QQC.ToolTip.text: page.tr("cfgRemove")
                                QQC.ToolTip.visible: hovered
                                onClicked: page.remove(pick.modelData)
                            }
                        }
                    }
                }
            }
        }

        Kirigami.Heading {
            level: 3
            text: page.tr("cfgAddAssets")
        }

        Repeater {
            model: Assets.GROUP_ORDER

            delegate: ColumnLayout {
                id: groupDelegate
                required property string modelData

                readonly property var items: Assets.ofType(modelData)
                    .filter(function (a) { return page.matches(a) })

                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing
                visible: items.length > 0

                Kirigami.Heading {
                    level: 4
                    opacity: 0.7
                    text: page.groupTitle(groupDelegate.modelData)
                }

                Kirigami.Separator { Layout.fillWidth: true }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    columnSpacing: Kirigami.Units.largeSpacing
                    rowSpacing: 0

                    Repeater {
                        model: groupDelegate.items

                        delegate: RowLayout {
                            id: assetRow
                            required property var modelData

                            Layout.fillWidth: true
                            spacing: Kirigami.Units.smallSpacing

                            Image {
                                source: Assets.iconFor(assetRow.modelData.symbol)
                                sourceSize.width: Kirigami.Units.iconSizes.small
                                sourceSize.height: Kirigami.Units.iconSizes.small
                                Layout.preferredWidth: Kirigami.Units.iconSizes.small
                                Layout.preferredHeight: Kirigami.Units.iconSizes.small
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                            }

                            QQC.CheckBox {
                                Layout.fillWidth: true
                                text: page.lang === "fa" ? assetRow.modelData.fa
                                                         : assetRow.modelData.en
                                checked: page.isOn(assetRow.modelData.symbol)
                                onToggled: page.setOn(assetRow.modelData.symbol, checked)
                            }

                            QQC.Label {
                                text: assetRow.modelData.symbol
                                font.family: "monospace"
                                font.pointSize: Kirigami.Theme.smallFont.pointSize
                                opacity: 0.45
                            }
                        }
                    }
                }
            }
        }
    }
}
