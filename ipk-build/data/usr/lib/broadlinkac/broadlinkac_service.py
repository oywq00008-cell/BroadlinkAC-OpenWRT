#!/usr/bin/env python3
"""BroadlinkAC OpenWRT service — background scheduler loop"""
import sys, os
sys.path.insert(0, '/usr/lib/broadlinkac')

from broadlinkac_core import init
init()

# Keep running — scheduler handles everything
try:
    while True:
        import time
        time.sleep(60)
except KeyboardInterrupt:
    pass
