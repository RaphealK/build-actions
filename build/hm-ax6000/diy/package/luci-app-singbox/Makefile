#
# luci-app-singbox - sing-box 轻量 LuCI 管理页
# 复用 sing-box 包自带的 /etc/init.d/sing-box 与 /etc/config/sing-box,不另建服务
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-singbox
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_LICENSE:=Apache-2.0
PKG_MAINTAINER:=RaphaelK

define Package/luci-app-singbox
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=4. Server
  TITLE:=sing-box 轻量管理页
  DEPENDS:=+sing-box +luci-base
  PKGARCH:=all
endef

define Package/luci-app-singbox/description
  LuCI page to manage sing-box: status, start/stop, autostart,
  config editor with sing-box check validation and log viewer.
endef

define Build/Compile
endef

define Package/luci-app-singbox/install
	$(INSTALL_DIR) $(1)/www/luci-static/resources/view/singbox
	$(INSTALL_DATA) $(CURDIR)/htdocs/luci-static/resources/view/singbox/main.js $(1)/www/luci-static/resources/view/singbox/main.js
	$(INSTALL_DIR) $(1)/usr/share/luci/menu.d
	$(INSTALL_DATA) $(CURDIR)/root/usr/share/luci/menu.d/luci-app-singbox.json $(1)/usr/share/luci/menu.d/luci-app-singbox.json
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) $(CURDIR)/root/usr/share/rpcd/acl.d/luci-app-singbox.json $(1)/usr/share/rpcd/acl.d/luci-app-singbox.json
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) $(CURDIR)/root/etc/uci-defaults/luci-app-singbox $(1)/etc/uci-defaults/luci-app-singbox
endef

$(eval $(call BuildPackage,luci-app-singbox))
