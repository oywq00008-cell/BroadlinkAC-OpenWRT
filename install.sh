#!/bin/sh
# BroadlinkAC manual installer for OpenWRT routers
# Run on your router: sh /tmp/broadlinkac_install.sh

set -e
INSTALL_DIR="/usr/lib/broadlinkac"

echo "=== BroadlinkAC OpenWRT Installer ==="
echo ""

# 1. Install Python deps
echo "[1/4] Installing system dependencies..."
opkg update
opkg install python3-light python3-urllib python3-json python3-math
opkg install python3-threading python3-datetime python3-re python3-socket
opkg install python3-ssl python3-gzip python3-broadlink python3-schedule
opkg install python3-pip

# 2. Install hvac_ir via pip
echo "[2/4] Installing hvac_ir..."
pip3 install hvac_ir

# 3. Copy files
echo "[3/4] Installing BroadlinkAC..."
mkdir -p "$INSTALL_DIR/broadlinkac_core"
mkdir -p "$INSTALL_DIR/protocols"
cp /tmp/broadlinkac_files/broadlinkac_service.py "$INSTALL_DIR/"
cp /tmp/broadlinkac_files/broadlinkac_core/*.py "$INSTALL_DIR/broadlinkac_core/"
cp /tmp/broadlinkac_files/protocols/*.py "$INSTALL_DIR/protocols/"

# 4. Init dirs
mkdir -p /root/.ac_controller/logs
if [ ! -f /root/.ac_controller/config.json ]; then
    echo '{"api_key":"","qw_host":"","devices":{},"current_device_mac":""}' > /root/.ac_controller/config.json
    echo "  Default config.json created — edit with your settings!"
fi

echo ""
echo "=== Done! ==="
echo "Start: python3 $INSTALL_DIR/broadlinkac_service.py &"
echo "Test:  python3 -c 'from broadlinkac_core import init; init(); print(\"OK\")'"
echo ""
echo "Scan devices from any computer with Agent:"
echo "  from broadlinkac_core import init, get_device_list"
echo "  init()"
echo "  for mac, name in get_device_list(): print(name, mac)"
