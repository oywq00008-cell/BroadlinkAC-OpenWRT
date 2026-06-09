local m, s, o

m = Map("broadlinkac", translate("Broadlink AC"),
    translate("AI-powered smart AC controller for Broadlink RM series"))

s = m:section(TypedSection, "settings", translate("Global Settings"))
s.anonymous = true
s.addremove = false

o = s:option(Value, "api_key", translate("QWeather API Key"))
o = s:option(Value, "qw_host", translate("QWeather Host"))
o.datatype = "host"
o = s:option(Value, "baidu_key", translate("Baidu API Key"))
o.rmempty = true
o = s:option(ListValue, "weather_provider", translate("Weather Provider"))
o:value("qweather", "QWeather"); o:value("baidu", "Baidu")

o = s:option(Value, "location_lat", translate("Latitude"))
o.datatype = "float"
o = s:option(Value, "location_lon", translate("Longitude"))
o.datatype = "float"
o = s:option(Value, "location_name", translate("Location Name"))

o = s:option(ListValue, "typhoon_provider", translate("Typhoon Provider"))
o:value("nmc", "NMC (NW Pacific)"); o:value("nhc", "NHC (N. Atlantic)")

o = s:option(Value, "typhoon_alert_km", translate("Storm Alert Distance (km)"))
o.datatype = "range(100,5000)"

o = s:option(Flag, "typhoon_alert_enabled", translate("Alert Popup"))
o = s:option(Flag, "typhoon_ac_off", translate("Auto-Shutdown <100km"))

o = s:option(Flag, "enabled", translate("Enable Service"))

return m
