[中文](README.md) / [English](README_EN.md)

# BroadlinkAC-OpenWRT

> OpenWRT router plugin for fully automatic air conditioning control via Broadlink RM. Weather-aware, storm-protected, 24/7 unattended operation.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![OpenWRT](https://img.shields.io/badge/OpenWRT-21%2B-blue.svg)]()
[![Python](https://img.shields.io/badge/Python-3.8%2B-green.svg)]()
[![Release](https://img.shields.io/badge/Release-v3.2-blue)](https://github.com/oywq00008-cell/BroadlinkAC-OpenWRT/releases)

## ✨ Features

- 🎛️ **LuCI Control Panel** — Web UI for AC control, device config, log viewing
- 🌤️ **Dual Weather Source** — Baidu + QWeather, auto-fallback + stale-cache rescue
- 🌀 **Storm Auto-Protection** — Force-shutdown all ACs when storm < 100km
- ⏰ **Multi-Group Schedule Templates** — Separate weekday/weekend schedules with time slots
- 🌡️ **Standalone Temp Rules** — Shared by scheduling and auto-adjust, weather-based decisions
- 🏷️ **Multi-Device Management** — Auto-dedup same-model devices, custom nicknames
- 🛡️ **Built-in hvac_ir** — 13 IR protocols bundled, zero pip dependencies
- 📥 **Log Download** — 14-day date grid + Markdown file download

## 📸 Screenshots

| Dashboard | Schedule Templates |
|-----------|-------------------|
| ![](主界面.png) | ![](定时.png) |

| Temperature Rules | Device Settings |
|-------------------|-----------------|
| ![](规则.png) | ![](设备设置.png) |

## 🚀 Quick Start

### Option A: IPK (Recommended)

Download `broadlinkac_3.2-1_all.ipk` from [Releases](https://github.com/oywq00008-cell/BroadlinkAC-OpenWRT/releases).

Open your router's LuCI web interface → System → Software → Upload Package, select the IPK file. Done.

### Option B: .run Installer

Download `BroadlinkAC-3.2.zip` from [Releases](https://github.com/oywq00008-cell/BroadlinkAC-OpenWRT/releases), extract it:

```bash
# Upload to router
scp broadlinkac_3.2.run root@your-router-ip:/tmp/

# Install
ssh root@your-router-ip "bash /tmp/broadlinkac_3.2.run"
```

> See `使用说明.txt` inside the ZIP for detailed steps (macOS / Windows / Linux).

### First-Time Setup

Open `http://your-router-ip/cgi-bin/luci/admin/services/broadlinkac`

1. Fill in QWeather API Key in Settings ([free sign-up](https://github.com/oywq00008-cell/BroadlinkAC-OpenWRT/blob/main/docs/使用指南.md))
2. Search and select your city location
3. Click **Scan Devices** to discover Broadlink RM
4. Select your AC brand in device settings

## 🎛️ Supported Brands

Gree, Midea, Hualing, Xiaomi, Haier, Hisense, Hitachi, Daikin, Mitsubishi, Panasonic, Fujitsu, AUX, Ballu, Carrier, Hyundai, Fuego

## 🔗 Sister Project

**[BroadlinkAC-For-Agent](https://github.com/oywq00008-cell/BroadlinkAC-For-Agent)** — Cross-platform desktop GUI + AI Agent interface (Windows / macOS / Linux).

Both projects share core algorithms, evolving independently:
- Desktop: interactive UI + rich user controls
- Router: 24/7 unattended + automatic response

## 📝 License

MIT — see [LICENSE](LICENSE)

## 🙏 Acknowledgments

- IR protocols: [python-broadlink](https://github.com/mjg59/python-broadlink) + [hvac_ir](https://github.com/shprota/hvac_ir)
- Weather data: Baidu Maps Open Platform + QWeather
- Storm data: China NMC + US NHC
