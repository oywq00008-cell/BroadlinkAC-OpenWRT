module("luci.controller.broadlinkac", package.seeall)

function index()
    entry({"admin", "services", "broadlinkac"},
        alias("admin", "services", "broadlinkac", "settings"),
        _("Broadlink AC"), 60).dependent = true

    entry({"admin", "services", "broadlinkac", "settings"},
        cbi("broadlinkac"), _("Settings"), 10)

    entry({"admin", "services", "broadlinkac", "status"},
        template("broadlinkac/status"), _("Status"), 20)
end
