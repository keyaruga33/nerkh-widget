.pragma library

var DEFAULT_API = "http://nerkh.dns-dynamic.net"

// ── Catalog Definition ──
var CATALOG = [
    { symbol: "IR_GOLD_18K", type: "metal", icon: "IR_GOLD_18K.svg", en: "Gold 18K / gram", fa: "طلای ۱۸ عیار", decimals: 0 },
    { symbol: "IR_GOLD_24K", type: "metal", icon: "IR_GOLD_24K.svg", en: "Gold 24K / gram", fa: "طلای ۲۴ عیار", decimals: 0 },
    { symbol: "IR_GOLD_MELTED", type: "metal", icon: "IR_GOLD_MELTED.svg", en: "Melted gold", fa: "طلای آبشده", decimals: 0 },
    { symbol: "XAUUSD", type: "metal", icon: "XAUUSD.svg", en: "Gold ounce (XAU/USD)", fa: "انس جهانی طلا", decimals: 2 },
    { symbol: "XAGUSD", type: "metal", icon: "XAGUSD.svg", en: "Silver ounce (XAG/USD)", fa: "انس جهانی نقره", decimals: 2 },
    { symbol: "XPTUSD", type: "metal", icon: "XPTUSD.svg", en: "Platinum ounce (XPT/USD)", fa: "انس جهانی پلاتین", decimals: 2 },
    { symbol: "XPDUSD", type: "metal", icon: "XPDUSD.svg", en: "Palladium ounce (XPD/USD)", fa: "انس جهانی پالادیوم", decimals: 2 },
    { symbol: "XRHUSD", type: "metal", icon: "XRHUSD.svg", en: "Rhodium ounce (XRH/USD)", fa: "انس جهانی رودیم", decimals: 2 },
    { symbol: "IR_COIN_1G", type: "metal", icon: "IR_COIN_1G.svg", en: "1g coin", fa: "سکهٔ یک گرمی", decimals: 0 },
    { symbol: "IR_COIN_QUARTER", type: "metal", icon: "IR_COIN_QUARTER.svg", en: "Quarter coin", fa: "ربع سکه", decimals: 0 },
    { symbol: "IR_COIN_HALF", type: "metal", icon: "IR_COIN_HALF.svg", en: "Half coin", fa: "نیم سکه", decimals: 0 },
    { symbol: "IR_COIN_EMAMI", type: "metal", icon: "IR_COIN_EMAMI.svg", en: "Emami coin", fa: "سکهٔ امامی", decimals: 0 },
    { symbol: "IR_COIN_BAHAR", type: "metal", icon: "IR_COIN_BAHAR.svg", en: "Bahar Azadi coin", fa: "سکهٔ بهار آزادی", decimals: 0 },
    { symbol: "USD", type: "fiat", icon: "USD.svg", en: "US Dollar", fa: "دلار آمریکا", decimals: 0 },
    { symbol: "EUR", type: "fiat", icon: "EUR.svg", en: "Euro", fa: "یورو", decimals: 0 },
    { symbol: "AED", type: "fiat", icon: "AED.svg", en: "UAE Dirham", fa: "درهم امارات", decimals: 0 },
    { symbol: "GBP", type: "fiat", icon: "GBP.svg", en: "British Pound", fa: "پوند انگلیس", decimals: 0 },
    { symbol: "JPY", type: "fiat", icon: "JPY.svg", en: "Japanese Yen", fa: "ین ژاپن", decimals: 0 },
    { symbol: "KWD", type: "fiat", icon: "KWD.svg", en: "Kuwaiti Dinar", fa: "دینار کویت", decimals: 0 },
    { symbol: "AUD", type: "fiat", icon: "AUD.svg", en: "Australian Dollar", fa: "دلار استرالیا", decimals: 0 },
    { symbol: "CAD", type: "fiat", icon: "CAD.svg", en: "Canadian Dollar", fa: "دلار کانادا", decimals: 0 },
    { symbol: "CNY", type: "fiat", icon: "CNY.svg", en: "Chinese Yuan", fa: "یوان چین", decimals: 0 },
    { symbol: "TRY", type: "fiat", icon: "TRY.svg", en: "Turkish Lira", fa: "لیر ترکیه", decimals: 0 },
    { symbol: "SAR", type: "fiat", icon: "SAR.svg", en: "Saudi Riyal", fa: "ریال عربستان", decimals: 0 },
    { symbol: "CHF", type: "fiat", icon: "CHF.svg", en: "Swiss Franc", fa: "فرانک سوئیس", decimals: 0 },
    { symbol: "INR", type: "fiat", icon: "INR.svg", en: "Indian Rupee", fa: "روپیه هند", decimals: 0 },
    { symbol: "PKR", type: "fiat", icon: "PKR.svg", en: "Pakistani Rupee", fa: "روپیه پاکستان", decimals: 0 },
    { symbol: "IQD", type: "fiat", icon: "IQD.svg", en: "Iraqi Dinar", fa: "دینار عراق", decimals: 0 },
    { symbol: "SYP", type: "fiat", icon: "SYP.svg", en: "Syrian Pound", fa: "لیر سوریه", decimals: 0 },
    { symbol: "SEK", type: "fiat", icon: "SEK.svg", en: "Swedish Krona", fa: "کرون سوئد", decimals: 0 },
    { symbol: "QAR", type: "fiat", icon: "QAR.svg", en: "Qatari Riyal", fa: "ریال قطر", decimals: 0 },
    { symbol: "OMR", type: "fiat", icon: "OMR.svg", en: "Omani Rial", fa: "ریال عمان", decimals: 0 },
    { symbol: "BHD", type: "fiat", icon: "BHD.svg", en: "Bahraini Dinar", fa: "دینار بحرین", decimals: 0 },
    { symbol: "AFN", type: "fiat", icon: "AFN.svg", en: "Afghan Afghani", fa: "افغانی افغانستان", decimals: 0 },
    { symbol: "MYR", type: "fiat", icon: "MYR.svg", en: "Malaysian Ringgit", fa: "رینگیت مالزی", decimals: 0 },
    { symbol: "THB", type: "fiat", icon: "THB.svg", en: "Thai Baht", fa: "بات تایلند", decimals: 0 },
    { symbol: "RUB", type: "fiat", icon: "RUB.svg", en: "Russian Ruble", fa: "روبل روسیه", decimals: 0 },
    { symbol: "AZN", type: "fiat", icon: "AZN.svg", en: "Azerbaijani Manat", fa: "منات آذربایجان", decimals: 0 },
    { symbol: "AMD", type: "fiat", icon: "AMD.svg", en: "Armenian Dram", fa: "درام ارمنستان", decimals: 0 },
    { symbol: "GEL", type: "fiat", icon: "GEL.svg", en: "Georgian Lari", fa: "لاری گرجستان", decimals: 0 },
    { symbol: "KRW", type: "fiat", icon: "KRW.svg", en: "100 South Korean Won", fa: "۱۰۰ وون کره جنوبی", decimals: 0 },
    { symbol: "NOK", type: "fiat", icon: "NOK.svg", en: "Norwegian Krone", fa: "کرون نروژ", decimals: 0 },
    { symbol: "NZD", type: "fiat", icon: "NZD.svg", en: "New Zealand Dollar", fa: "دلار نیوزیلند", decimals: 0 },
    { symbol: "SGD", type: "fiat", icon: "SGD.svg", en: "Singapore Dollar", fa: "دلار سنگاپور", decimals: 0 },
    { symbol: "HKD", type: "fiat", icon: "HKD.svg", en: "Hong Kong Dollar", fa: "دلار هنگ‌کنگ", decimals: 0 },
    { symbol: "DKK", type: "fiat", icon: "DKK.svg", en: "Danish Krone", fa: "کرون دانمارک", decimals: 0 },
    { symbol: "TJS", type: "fiat", icon: "TJS.svg", en: "Tajikistani Somoni", fa: "سامانی تاجیکستان", decimals: 0 },
    { symbol: "TMT", type: "fiat", icon: "TMT.svg", en: "Turkmenistani Manat", fa: "منات ترکمنستان", decimals: 0 },
    { symbol: "KGS", type: "fiat", icon: "KGS.svg", en: "Kyrgyzstani Som", fa: "سوم قرقیزستان", decimals: 0 },
    { symbol: "BRL", type: "fiat", icon: "BRL.svg", en: "Brazilian Real", fa: "رئال برزیل", decimals: 0 },
    { symbol: "ARS", type: "fiat", icon: "ARS.svg", en: "Argentine Peso", fa: "پزو آرژانتین", decimals: 0 },
    { symbol: "USD_HAV", type: "fiat", icon: "USD_HAV.svg", en: "US Dollar (Remittance)", fa: "دلار حواله", decimals: 0 },
    { symbol: "USD_IST", type: "fiat", icon: "USD_IST.svg", en: "US Dollar (Istanbul)", fa: "دلار استانبول", decimals: 0 },
    { symbol: "USD_SULAYMANIYAH", type: "fiat", icon: "USD_SULAYMANIYAH.svg", en: "US Dollar (Sulaymaniyah)", fa: "دلار سلیمانیه", decimals: 0 },
    { symbol: "USD_HERAT", type: "fiat", icon: "USD_HERAT.svg", en: "US Dollar (Herat)", fa: "دلار هرات", decimals: 0 },
    { symbol: "EUR_HAV", type: "fiat", icon: "EUR_HAV.svg", en: "Euro (Remittance)", fa: "یورو حواله", decimals: 0 },
    { symbol: "EUR_IST", type: "fiat", icon: "EUR_IST.svg", en: "Euro (Istanbul)", fa: "یورو استانبول", decimals: 0 },
    { symbol: "USDT_IRT", type: "crypto", icon: "USDT_IRT.svg", en: "Tether / Toman", fa: "تتر / تومان", decimals: 0 },
    { symbol: "BTC", type: "crypto", icon: "BTC.svg", en: "Bitcoin", fa: "بیت‌کوین", decimals: 2 },
    { symbol: "ETH", type: "crypto", icon: "ETH.svg", en: "Ethereum", fa: "اتریوم", decimals: 2 },
    { symbol: "USDT", type: "crypto", icon: "USDT.svg", en: "Tether", fa: "تتر", decimals: 3 },
    { symbol: "XRP", type: "crypto", icon: "XRP.svg", en: "XRP", fa: "ریپل", decimals: 4 },
    { symbol: "BNB", type: "crypto", icon: "BNB.svg", en: "BNB", fa: "بی‌ان‌بی", decimals: 2 },
    { symbol: "SOL", type: "crypto", icon: "SOL.svg", en: "Solana", fa: "سولانا", decimals: 2 },
    { symbol: "USDC", type: "crypto", icon: "USDC.svg", en: "USD Coin", fa: "یو‌اس‌دی‌کوین", decimals: 3 },
    { symbol: "TRX", type: "crypto", icon: "TRX.svg", en: "TRON", fa: "ترون", decimals: 4 },
    { symbol: "DOGE", type: "crypto", icon: "DOGE.svg", en: "Dogecoin", fa: "دوج‌کوین", decimals: 4 },
    { symbol: "ADA", type: "crypto", icon: "ADA.svg", en: "Cardano", fa: "کاردانو", decimals: 4 },
    { symbol: "LINK", type: "crypto", icon: "LINK.svg", en: "Chainlink", fa: "چین‌لینک", decimals: 3 },
    { symbol: "XLM", type: "crypto", icon: "XLM.svg", en: "Stellar", fa: "استلار", decimals: 4 },
    { symbol: "AVAX", type: "crypto", icon: "AVAX.svg", en: "Avalanche", fa: "آوالانچ", decimals: 2 },
    { symbol: "SHIB", type: "crypto", icon: "SHIB.svg", en: "Shiba Inu", fa: "شیبا اینو", decimals: 6 },
    { symbol: "LTC", type: "crypto", icon: "LTC.svg", en: "Litecoin", fa: "لایت‌کوین", decimals: 2 },
    { symbol: "DOT", type: "crypto", icon: "DOT.svg", en: "Polkadot", fa: "پولکادات", decimals: 3 },
    { symbol: "UNI", type: "crypto", icon: "UNI.svg", en: "Uniswap", fa: "یونی‌سواپ", decimals: 3 },
    { symbol: "ATOM", type: "crypto", icon: "ATOM.svg", en: "Cosmos", fa: "کازموس", decimals: 3 },
    { symbol: "FIL", type: "crypto", icon: "FIL.svg", en: "Filecoin", fa: "فایل‌کوین", decimals: 3 },
    { symbol: "TON", type: "crypto", icon: "TON.svg", en: "Toncoin", fa: "تونکوین", decimals: 2 },
    { symbol: "NOT", type: "crypto", icon: "NOT.svg", en: "Notcoin", fa: "ناتکوین", decimals: 5 },
    { symbol: "PEPE", type: "crypto", icon: "PEPE.svg", en: "Pepe", fa: "پپه", decimals: 8 },
    { symbol: "NEAR", type: "crypto", icon: "NEAR.svg", en: "NEAR Protocol", fa: "نیر پروتکل", decimals: 2 },
    { symbol: "AAVE", type: "crypto", icon: "AAVE.svg", en: "Aave", fa: "آوه", decimals: 2 },
    { symbol: "CAKE", type: "crypto", icon: "CAKE.svg", en: "PancakeSwap", fa: "پنکیکسواپ", decimals: 3 },
    { symbol: "EOS", type: "crypto", icon: "EOS.svg", en: "EOS", fa: "ایاس", decimals: 4 },
    { symbol: "SAND", type: "crypto", icon: "SAND.svg", en: "The Sandbox", fa: "سندباکس", decimals: 4 },
    { symbol: "MANA", type: "crypto", icon: "MANA.svg", en: "Decentraland", fa: "دیسنترالند", decimals: 4 },
    { symbol: "GRT", type: "crypto", icon: "GRT.svg", en: "The Graph", fa: "گراف", decimals: 5 },
    { symbol: "XTZ", type: "crypto", icon: "XTZ.svg", en: "Tezos", fa: "تزوس", decimals: 4 },
    { symbol: "FLOW", type: "crypto", icon: "FLOW.svg", en: "Flow", fa: "فلو", decimals: 4 },
    { symbol: "AXS", type: "crypto", icon: "AXS.svg", en: "Axie Infinity", fa: "اکسی اینفینیتی", decimals: 3 },
    { symbol: "CHZ", type: "crypto", icon: "CHZ.svg", en: "Chiliz", fa: "چیلیز", decimals: 5 },
    { symbol: "ENJ", type: "crypto", icon: "ENJ.svg", en: "Enjin Coin", fa: "انجین کوین", decimals: 5 },
    { symbol: "ZEC", type: "crypto", icon: "ZEC.svg", en: "Zcash", fa: "زدکش", decimals: 2 },
    { symbol: "GALA", type: "crypto", icon: "GALA.svg", en: "Gala", fa: "گالا", decimals: 5 },
    { symbol: "LRC", type: "crypto", icon: "LRC.svg", en: "Loopring", fa: "لوپرینگ", decimals: 5 },
    { symbol: "BAT", type: "crypto", icon: "BAT.svg", en: "Basic Attention Token", fa: "بیسیک اتنشن توکن", decimals: 4 },
    { symbol: "ONE", type: "crypto", icon: "ONE.svg", en: "Harmony", fa: "هارمونی", decimals: 5 },
    { symbol: "ZEN", type: "crypto", icon: "ZEN.svg", en: "Horizen", fa: "هورایزن", decimals: 3 },
    { symbol: "CVC", type: "crypto", icon: "CVC.svg", en: "Civic", fa: "سیویک", decimals: 4 },
    { symbol: "STORJ", type: "crypto", icon: "STORJ.svg", en: "Storj", fa: "استورج", decimals: 4 }
]

// ── Group Order ──
var DEFAULT_GROUP_ORDER = ["fiat", "metal", "crypto"]
var GROUP_ORDER = DEFAULT_GROUP_ORDER

// ── Index & Lookup Helpers ──
var _index = null

function _byIndex() {
    if (_index === null) {
        _index = {}
        for (var i = 0; i < CATALOG.length; ++i) {
            var item = CATALOG[i]
            _index[item.symbol] = item
            if (item.symbol.indexOf("_") !== -1)
                _index[item.symbol.replace(/_/g, "-")] = item
            else if (item.symbol.indexOf("-") !== -1)
                _index[item.symbol.replace(/-/g, "_")] = item
        }
    }
    return _index
}

function canonicalSymbol(symbol) {
    if (!symbol) return ""
    var s = String(symbol).trim().toUpperCase()
    var item = _byIndex()[s]
    return item ? item.symbol : s
}

function bySymbol(symbol) {
    if (!symbol)
        return null
    var s = String(symbol).trim().toUpperCase()
    var hit = _byIndex()[s]
    if (hit !== undefined)
        return hit
    var alt = s.indexOf("-") !== -1 ? s.replace(/-/g, "_") : s.replace(/_/g, "-")
    hit = _byIndex()[alt]
    return hit === undefined ? null : hit
}

function iconFor(symbol) {
    var a = bySymbol(symbol)
    return "../../icons/" + (a ? a.icon : "generic.svg")
}

function nameFor(symbol, lang) {
    var a = bySymbol(symbol)
    if (!a)
        return String(symbol)
    return lang === "fa" ? a.fa : a.en
}

function labelFor(symbol, lang, style) {
    var sym = canonicalSymbol(symbol)
    if (style === "symbol")
        return sym
    var name = nameFor(sym, lang)
    if (style === "both" && name !== sym)
        return name + "  ·  " + sym
    return name
}

function typeFor(symbol) {
    var a = bySymbol(symbol)
    return a ? a.type : "fiat"
}

function decimalsFor(symbol) {
    var a = bySymbol(symbol)
    return a ? a.decimals : 0
}

function ofType(type) {
    return CATALOG.filter(function (a) { return a.type === type })
}

function parseList(s) {
    if (!s)
        return []
    return String(s).split(",")
        .map(function (x) { return canonicalSymbol(x) })
        .filter(function (x) { return x.length > 0 })
}

function parseGroupOrder(s) {
    var out = []
    var list = parseList(s).map(function (x) { return x.toLowerCase() })
    for (var i = 0; i < list.length; ++i)
        if (DEFAULT_GROUP_ORDER.indexOf(list[i]) !== -1 && out.indexOf(list[i]) === -1)
            out.push(list[i])
    for (var j = 0; j < DEFAULT_GROUP_ORDER.length; ++j)
        if (out.indexOf(DEFAULT_GROUP_ORDER[j]) === -1)
            out.push(DEFAULT_GROUP_ORDER[j])
    return out
}

function sortedBy(symbols, groupOrderStr) {
    var groups = parseGroupOrder(groupOrderStr)
    var rank = {}
    for (var i = 0; i < groups.length; ++i)
        rank[groups[i]] = i

    var indexed = symbols.map(function (s, i) { return { s: canonicalSymbol(s), i: i } })
    indexed.sort(function (a, b) {
        var ga = rank[typeFor(a.s)]
        var gb = rank[typeFor(b.s)]
        if (ga === undefined) ga = 99
        if (gb === undefined) gb = 99
        if (ga !== gb)
            return ga - gb
        return a.i - b.i
    })
    return indexed.map(function (x) { return x.s })
}

function sorted(symbols) {
    return sortedBy(symbols, "")
}
