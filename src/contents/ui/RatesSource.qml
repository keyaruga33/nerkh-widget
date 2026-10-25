import QtQuick
import "lib/Assets.js" as Assets

Item {
    id: source
    visible: false

    property string baseUrl: ""
    property string apiKey: ""
    property string authMethod: "auto"   // auto | bearer | header | query | none
    property var symbols: []
    property string cryptoBase: "USD"
    property string lang: "en"
    property int intervalMinutes: 5
    property bool autoRefresh: true
    property bool active: true            // false while the popup is hidden

    property var rates: ({})              // symbol → rate object
    property var partialErrors: []        // [{ symbol, code, message }]
    property double lastUpdated: 0        // ms epoch, 0 = never
    property double nextRefreshAt: 0      // ms epoch, 0 = no scheduled refresh
    property bool loading: false
    property string errorText: ""
    property bool hasData: Object.keys(rates).length > 0

    readonly property string effectiveBase:
        baseUrl.trim().length > 0 ? baseUrl.trim() : Assets.DEFAULT_API

    property string _etag: ""
    property int _attempt: 0
    property var _request: null

    readonly property var _backoffMs: [5000, 15000, 45000]

    signal finished(bool ok)

    function endpoint() {
        var base = effectiveBase.replace(/\/+$/, "")
        var query = [
            "symbols=" + encodeURIComponent(symbols.join(",")),
            "base=IRT",
            "crypto_base=" + encodeURIComponent(cryptoBase),
            "lang=" + encodeURIComponent(lang)
        ]
        var key = apiKey.trim()
        if (key.length > 0 && (authMethod === "query"))
            query.push("api_key=" + encodeURIComponent(key))
        return base + "/v1/rates?" + query.join("&")
    }

    function _applyAuth(xhr) {
        var key = apiKey.trim()
        if (key.length === 0 || authMethod === "none" || authMethod === "query")
            return
        if (authMethod === "bearer" || authMethod === "auto")
            xhr.setRequestHeader("Authorization", "Bearer " + key)
        if (authMethod === "header" || authMethod === "auto")
            xhr.setRequestHeader("X-API-Key", key)
    }

    function refresh() {
        if (symbols.length === 0) {
            rates = ({})
            partialErrors = []
            errorText = ""
            _cancelTimers()
            return
        }

        if (loading && _request)
            _request.abort()

        loading = true

        var xhr = new XMLHttpRequest()
        _request = xhr
        xhr.open("GET", endpoint())
        xhr.setRequestHeader("Accept", "application/json")
        _applyAuth(xhr)
        if (_etag.length > 0 && hasData)
            xhr.setRequestHeader("If-None-Match", _etag)

        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return
            source._request = null
            source.loading = false
            source._handle(xhr)
        }

        xhr.send()
    }

    function _handle(xhr) {
        if (xhr.status === 304) {
            errorText = ""
            _attempt = 0
            lastUpdated = Date.now()
            _reschedule()
            finished(true)
            return
        }

        if (xhr.status === 0) {
            _fail("no connection")
            return
        }

        var payload = null
        try {
            payload = JSON.parse(xhr.responseText)
        } catch (e) {
            payload = null
        }

        if (xhr.status >= 400) {
            _fail(payload && payload.error ? payload.error.message : ("HTTP " + xhr.status))
            return
        }

        if (!payload || payload.ok === false || !payload.rates) {
            _fail(payload && payload.error ? payload.error.message : "malformed response")
            return
        }

        var tag = xhr.getResponseHeader("ETag")
        if (tag)
            _etag = tag

        _ingest(payload)
        errorText = ""
        _attempt = 0
        lastUpdated = Date.now()
        _reschedule()
        finished(true)
    }

    function _fail(message) {
        errorText = message
        if (_attempt < _backoffMs.length) {
            retryTimer.interval = _backoffMs[_attempt]
            _attempt += 1
            retryTimer.restart()
            nextRefreshAt = Date.now() + retryTimer.interval
        } else {
            _attempt = 0
            _reschedule()
        }
        finished(false)
    }

    function _ingest(payload) {
        var map = {}
        var list = payload.rates || []

        for (var i = 0; i < list.length; ++i) {
            var r = list[i]
            if (!r || !r.symbol)
                continue

            var sym = String(r.symbol).toUpperCase()
            var price = Number(r.price)
            var prev = (r.prev_close === undefined || r.prev_close === null)
                ? NaN : Number(r.prev_close)

            var change = (r.change === undefined || r.change === null)
                ? (isNaN(prev) ? NaN : price - prev) : Number(r.change)

            var pct = (r.change_percent === undefined || r.change_percent === null)
                ? ((isNaN(prev) || prev === 0) ? NaN : (change / prev) * 100)
                : Number(r.change_percent)

            var dir = r.direction
            if (dir !== "up" && dir !== "down" && dir !== "flat")
                dir = isNaN(change) ? "flat" : (change > 0 ? "up" : (change < 0 ? "down" : "flat"))

            var updatedMs = Date.parse(r.updated_at)

            var rateData = {
                symbol: sym,
                type: r.type || Assets.typeFor(sym),
                name: r.name || Assets.nameFor(sym, "en"),
                nameFa: r.name_fa || Assets.nameFor(sym, "fa"),
                unit: r.unit || "IRT",
                decimals: (r.decimals === undefined || r.decimals === null)
                    ? Assets.decimalsFor(sym) : Number(r.decimals),
                price: price,
                change: change,
                changePercent: pct,
                direction: dir,
                updatedAt: isNaN(updatedMs) ? Date.now() : updatedMs,
                stale: r.stale === true
            }

            map[sym] = rateData
            if (sym.indexOf("_") !== -1)
                map[sym.replace(/_/g, "-")] = rateData
            else if (sym.indexOf("-") !== -1)
                map[sym.replace(/-/g, "_")] = rateData
        }

        rates = map
        partialErrors = Array.isArray(payload.errors) ? payload.errors : []
    }

    function _cancelTimers() {
        pollTimer.stop()
        retryTimer.stop()
        nextRefreshAt = 0
    }

    function _reschedule() {
        retryTimer.stop()
        if (!autoRefresh) {
            _cancelTimers()
            return
        }
        var ms = Math.max(1, intervalMinutes) * 60000
        pollTimer.interval = ms
        pollTimer.restart()
        nextRefreshAt = Date.now() + ms
    }

    Timer {
        id: pollTimer
        repeat: false
        running: false
        onTriggered: {
            if (source.active)
                source.refresh()
            else
                source._reschedule()
        }
    }

    Timer {
        id: retryTimer
        repeat: false
        running: false
        onTriggered: source.refresh()
    }

    property bool _ready: false

    onIntervalMinutesChanged: if (_ready) _reschedule()
    onAutoRefreshChanged: if (_ready) _reschedule()
    onSymbolsChanged: if (_ready) refresh()
    onCryptoBaseChanged: if (_ready) refresh()
    onLangChanged: if (_ready) refresh()
    onBaseUrlChanged: { _etag = ""; if (_ready) refresh() }
    onApiKeyChanged: if (_ready) refresh()
    onAuthMethodChanged: if (_ready) refresh()

    Component.onCompleted: {
        _ready = true
        refresh()
    }
}
