#!/bin/sh
# BroadlinkAC one-click installer for OpenWRT routers
# Usage: bash install.sh  (or copy IPK + this script to router, then bash install.sh)
#
# 自动处理: opkg 依赖 + hvac_ir (pip) + IPK 主体

set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IPK="$(ls "$SCRIPT_DIR"/broadlinkac_*.ipk 2>/dev/null | head -1)"

if [ -z "$IPK" ]; then
    echo "ERROR: 找不到 *.ipk 文件，请把 install.sh 跟 .ipk 放同一目录"
    exit 1
fi

echo "=== BroadlinkAC OpenWRT 一键安装器 ==="
echo "IPK: $(basename "$IPK")"
echo ""

# 1. opkg 依赖
echo "[1/3] 装 opkg 依赖..."
opkg update
opkg install python3-light python3-pip python3-urllib python3-json \
           python3-broadlink python3-schedule 2>/dev/null || true

# 2. IPK 主体
echo "[2/3] 装插件 IPK..."
opkg install "$IPK" --force-depends || opkg install "$IPK"

# 3. hvac_ir (pip)
echo "[3/3] 装 hvac_ir (pip)..."
pip3 install hvac_ir --break-system-packages 2>/dev/null || \
pip3 install hvac_ir 2>/dev/null || \
echo "WARNING: pip3 install hvac_ir 失败，请手动 pip3 install hvac_ir"

echo ""
echo "=== 安装完成 ==="
LAN_IP=$(uci get network.lan.ipaddr 2>/dev/null || echo "192.168.1.1")
echo "浏览器打开: http://$LAN_IP/cgi-bin/luci/admin/services/broadlinkac"
echo "或扫描局域网设备: 桌面端 Agent 用 'from broadlinkac_core import get_device_list'"
echo ""
