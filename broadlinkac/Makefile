include $(TOPDIR)/rules.mk

PKG_NAME:=broadlinkac
PKG_VERSION:=3.0
PKG_RELEASE:=1
PKG_LICENSE:=MIT
PKG_MAINTAINER:=oywq00008-cell

include $(INCLUDE_DIR)/package.mk

define Package/broadlinkac
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=BroadlinkAC — AI Smart AC Controller
  DEPENDS:=+python3-light +python3-urllib +python3-json +python3-math +python3-threading +python3-datetime +python3-re +python3-socket +python3-ssl +python3-gzip +python3-broadlink +python3-schedule
  URL:=https://github.com/oywq00008-cell/BroadlinkAC-For-Agent
endef

define Package/broadlinkac/description
  AI-powered smart AC controller for Broadlink RM series IR blasters.
  Supports 17 AC brands, dual weather sources, NMC/NHC typhoon & hurricane tracking,
  and automatic shutdown on storm approach (<100km).
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./files/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	true
endef

define Package/broadlinkac/install
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) $(PKG_BUILD_DIR)/etc/config/broadlinkac $(1)/etc/config/

	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(CP) $(PKG_BUILD_DIR)/etc/uci-defaults/99-broadlinkac $(1)/etc/uci-defaults/

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/init.d/broadlinkac $(1)/etc/init.d/

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(CP) $(PKG_BUILD_DIR)/usr/lib/lua/luci/controller/broadlinkac.lua $(1)/usr/lib/lua/luci/controller/

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(CP) $(PKG_BUILD_DIR)/usr/lib/lua/luci/model/cbi/broadlinkac.lua $(1)/usr/lib/lua/luci/model/cbi/

	$(INSTALL_DIR) $(1)/usr/lib/broadlinkac
	$(CP) $(PKG_BUILD_DIR)/usr/lib/broadlinkac/*.py $(1)/usr/lib/broadlinkac/
	$(CP) -r $(PKG_BUILD_DIR)/usr/lib/broadlinkac/broadlinkac_core $(1)/usr/lib/broadlinkac/
	$(CP) -r $(PKG_BUILD_DIR)/usr/lib/broadlinkac/protocols $(1)/usr/lib/broadlinkac/
endef

$(eval $(call BuildPackage,broadlinkac))
