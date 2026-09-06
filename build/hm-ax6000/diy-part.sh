#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# DIY扩展二合一了，在此处可以增加插件
# 自行拉取插件之前请SSH连接进入固件配置里面确认过没有你要的插件再单独拉取你需要的插件
# 不要一下就拉取别人一个插件包N多插件的，多了没用，增加编译错误，自己需要的才好


# 后台IP设置
export Ipv4_ipaddr="192.168.31.1"            # 修改openwrt后台地址(填0为关闭)
export Netmask_netm="255.255.255.0"         # IPv4 子网掩码（默认：255.255.255.0）(填0为不作修改)
export Op_name="K-Wrt"                # 修改主机名称为OpenWrt-123(填0为不作修改)

# 内核和系统分区大小(不是每个机型都可用)
export Kernel_partition_size="0"            # 内核分区大小,每个机型默认值不一样 (填写您想要的数值,默认一般16,数值以MB计算，填0为不作修改),如果你不懂就填0
export Rootfs_partition_size="0"            # 系统分区大小,每个机型默认值不一样 (填写您想要的数值,默认一般300左右,数值以MB计算，填0为不作修改),如果你不懂就填0

# 默认主题设置
export Mandatory_theme="aurora"              # 将bootstrap替换您需要的主题为必选主题(可自行更改您要的,源码要带此主题就行,填写名称也要写对) (填写主题名称,填0为不作修改)
export Default_theme="aurora"                # 多主题时,选择某主题为默认第一主题 (填写主题名称,填0为不作修改)

# 旁路由选项
export Gateway_Settings="0"                 # 旁路由设置 IPv4 网关(填入您的网关IP为启用)(填0为不作修改)
export DNS_Settings="0"                     # 旁路由设置 DNS(填入DNS，多个DNS要用空格分开)(填0为不作修改)
export Broadcast_Ipv4="0"                   # 设置 IPv4 广播(填入您的IP为启用)(填0为不作修改)
export Disable_DHCP="0"                     # 旁路由关闭DHCP功能(1为启用命令,填0为不作修改)
export Disable_Bridge="0"                   # 旁路由去掉桥接模式(1为启用命令,填0为不作修改)
export Create_Ipv6_Lan="0"                  # 爱快+OP双系统时,爱快接管IPV6,在OP创建IPV6的lan口接收IPV6信息(1为启用命令,填0为不作修改)

# IPV6、IPV4 选择
export Enable_IPV6_function="0"             # 编译IPV6固件(1为启用命令,填0为不作修改)(如果跟Create_Ipv6_Lan一起启用命令的话,Create_Ipv6_Lan命令会自动关闭)
export Enable_IPV4_function="0"             # 编译IPV4固件(1为启用命令,填0为不作修改)(如果跟Enable_IPV6_function一起启用命令的话,此命令会自动关闭)

# 替换OpenClash的源码(默认master分支)
export OpenClash_branch="0"                 # OpenClash的源码分别有【master分支】和【dev分支】(填0为关闭,填1为使用master分支,填2为使用dev分支,填入1或2的时候固件自动增加此插件)

# 个性签名,默认增加年月日[$(TZ=UTC-8 date "+%Y.%m.%d")]
export Customized_Information="$(TZ=UTC-8 date "+%Y年%m月%d日 %H:%M By K")"

# 更换固件内核
export Replace_Kernel="0"                    # 更换内核版本,在对应源码的[target/linux/架构]查看patches-x.x,看看x.x有啥就有啥内核了(填入内核x.x版本号,填0为不作修改)

# 设置免密码登录(个别源码本身就没密码的)
export Password_free_login="1"               # 设置首次登录后台密码为空（进入openwrt后自行修改密码）(1为启用命令,填0为不作修改)

# 增加AdGuardHome插件和核心
export AdGuardHome_Core="0"                  # 编译固件时自动增加AdGuardHome插件和AdGuardHome插件核心,需要注意的是一个核心20多MB的,小闪存机子搞不来(1为启用命令,填0为不作修改)

# 开启NTFS格式盘挂载
export Automatic_Mount_Settings="0"          # 编译时加入开启NTFS格式盘挂载的所需依赖(1为启用命令,填0为不作修改)

# 去除网络共享(autosamba)
export Disable_autosamba="0"                 # 去掉源码默认自选的luci-app-samba或luci-app-samba4(1为启用命令,填0为不作修改)

# 其他
export Ttyd_account_free_login="0"           # 设置ttyd免密登录(1为启用命令,填0为不作修改)
export Delete_unnecessary_items="1"          # 个别机型内一堆其他机型固件,删除其他机型的,只保留当前主机型固件(1为启用命令,填0为不作修改)
export Disable_53_redirection="1"            # 删除DNS强制重定向53端口防火墙规则(个别源码本身不带此功能)(1为启用命令,填0为不作修改)
export Cancel_running="0"                    # 取消路由器每天跑分任务(个别源码本身不带此功能)(1为启用命令,填0为不作修改)


# 晶晨CPU系列打包固件设置(不懂请看说明)
export amlogic_model="s905d"
export amlogic_kernel="6.1.120_6.12.15"
export auto_kernel="true"
export rootfs_size="512/2560"
export kernel_usage="stable"


# 修改插件名字
grep -rl '"终端"' . | xargs -r sed -i 's?"终端"?"TTYD"?g'
grep -rl '"TTYD 终端"' . | xargs -r sed -i 's?"TTYD 终端"?"TTYD"?g'
grep -rl '"网络存储"' . | xargs -r sed -i 's?"网络存储"?"NAS"?g'
grep -rl '"实时流量监测"' . | xargs -r sed -i 's?"实时流量监测"?"流量"?g'
grep -rl '"KMS 服务器"' . | xargs -r sed -i 's?"KMS 服务器"?"KMS激活"?g'
grep -rl '"USB 打印服务器"' . | xargs -r sed -i 's?"USB 打印服务器"?"打印服务"?g'
grep -rl '"Web 管理"' . | xargs -r sed -i 's?"Web 管理"?"Web管理"?g'
grep -rl '"管理权"' . | xargs -r sed -i 's?"管理权"?"改密码"?g'
grep -rl '"带宽监控"' . | xargs -r sed -i 's?"带宽监控"?"监控"?g'


# 整理固件包时候,删除您不想要的固件或者文件,让它不需要上传到Actions空间(根据编译机型变化,自行调整删除名称)
# 本机只用squashfs-sysupgrade.bin,其余全删(每行为子串匹配模式,不能含TARGET_BOARD字样)
cat >"$CLEAR_PATH" <<-EOF
packages
config.buildinfo
feeds.buildinfo
sha256sums
version.buildinfo
profiles.json
manifest
initramfs
bl2
ipk
EOF

# 在线更新时，删除不想保留固件的某个文件，在EOF跟EOF之间加入删除代码，记住这里对应的是固件的文件路径，比如： rm -rf /etc/config/luci
cat >>$DELETE <<-EOF
EOF

git clone  https://github.com/gdy666/luci-app-lucky.git package/lucky
git clone  https://github.com/linkease/istore.git package/luci-app-store
# luci-theme-aurora(eamonxg 源;Vite/Tailwind 现代主题,htdocs 已预编译,OpenWrt 直接装;最近提交 2026-08-03)
git clone https://github.com/eamonxg/luci-theme-aurora.git package/luci-theme-aurora
# luci-app-aurora-config(Aurora 主题的设置页,eamonxg 源;htdocs 预编译)
git clone https://github.com/eamonxg/luci-app-aurora-config.git package/luci-app-aurora-config
# tailscale不再单独安装(sing-box full版自带with_tailscale出站)
# sing-box管理页为自写的luci-app-singbox,在diy/package/luci-app-singbox,随源码树带入

# sing-box升级到最新正式版(覆盖feed里的旧版;版本号/源码哈希每次编译自动获取)
# 新版要求更高Go时不动feed工具链(其自举链编不了新Go),改为开启GOTOOLCHAIN自动切换,编译期按go.mod自动拉取官方预编译Go
SB_MK="feeds/packages/net/sing-box/Makefile"
GP_MK="feeds/packages/lang/golang/golang-package.mk"
SB_VER="$(git ls-remote --tags --refs -q https://github.com/SagerNet/sing-box "v*" 2>/dev/null |sed 's|.*refs/tags/v||' |grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' |sort -V |tail -1)"
if [ -f "$SB_MK" ] && [ -n "$SB_VER" ]; then
	curl -sL "https://codeload.github.com/SagerNet/sing-box/tar.gz/v${SB_VER}" -o /tmp/sb-tar.tar.gz
	SB_HASH="$(sha256sum /tmp/sb-tar.tar.gz |cut -d' ' -f1)"
	rm -f /tmp/sb-tar.tar.gz
	sed -i "s/^PKG_VERSION:=.*/PKG_VERSION:=$SB_VER/" "$SB_MK"
	sed -i "s/^PKG_HASH:=.*/PKG_HASH:=$SB_HASH/" "$SB_MK"
	echo "已把sing-box升级到v$SB_VER(源码哈希$SB_HASH)"
	# 开启Go工具链自动切换(golang-package.mk默认锁local,新版sing-box会因Go过旧而编译失败)
	if [ -f "$GP_MK" ] && grep -q "GOTOOLCHAIN=local" "$GP_MK"; then
		sed -i "s/GOTOOLCHAIN=local/GOTOOLCHAIN=auto/" "$GP_MK"
		echo "已开启GOTOOLCHAIN自动切换"
	else
		echo "警告:未找到GOTOOLCHAIN=local,若sing-box编译报Go版本过旧需人工检查"
	fi
	# 仅本地构建(LOCAL_BUILD=1):工具链/模块下载走goproxy.cn,绕开dl.google.com不可达
	if [ "${LOCAL_BUILD:-0}" = "1" ] && grep -q "GOENV=off" "$GP_MK" && ! grep -q "GOPROXY=" "$GP_MK"; then
		sed -i "s|\tGOENV=off \\\\|\tGOENV=off \\\\\n\tGOPROXY=https://goproxy.cn,direct \\\\|" "$GP_MK"
		echo "已注入GOPROXY=goproxy.cn(本地构建)"
	fi
	# UPX压缩编译产物(约减70%体积);在包的eval前注入Build/Compile覆盖,编译后压缩
	command -v upx >/dev/null 2>&1 || sudo apt-get install -y -qq upx-ucl >/dev/null 2>&1
	if command -v upx >/dev/null 2>&1; then
		if ! grep -q "upx" "$SB_MK"; then
			awk '
			/^\$\(eval \$\(call BuildPackage,sing-box\)\)$/ && !ins {
				print "define Build/Compile"
				print "\t$(call GoPackage/Build/Compile)"
				print "\tupx --best --lzma $(GO_PKG_BUILD_BIN_DIR)/sing-box"
				print "endef"
				print ""
				ins=1
			}
			{ print }
			' "$SB_MK" > "$SB_MK.tmp" && mv "$SB_MK.tmp" "$SB_MK"
			echo "已注入UPX压缩步骤到sing-box编译"
		fi
	else
		echo "警告:upx未安装成功,跳过sing-box压缩"
	fi
else
	echo "警告:未找到feeds里的sing-box包或未取到最新版本号,跳过sing-box升级"
fi

# 首开机强制修改后台IP/掩码/主机名(上游common对mt798x源码的sed机制失效,这里用uci-defaults兜底)
# 复用上方Ipv4_ipaddr/Netmask_netm/Op_name的值,填0则维持源码默认
if [ -n "$Ipv4_ipaddr" ] && [ "$Ipv4_ipaddr" != "0" ] || [ -n "$Op_name" ] && [ "$Op_name" != "0" ]; then
	mkdir -p files/etc/uci-defaults
	{
		echo '#!/bin/sh'
		echo '# 首开机把后台IP/主机名改成diy-part.sh里设置的值(上游sed机制在本源码失效的兜底)'
		if [ -n "$Ipv4_ipaddr" ] && [ "$Ipv4_ipaddr" != "0" ]; then
			echo "uci set network.lan.ipaddr='$Ipv4_ipaddr'"
			if [ -n "$Netmask_netm" ] && [ "$Netmask_netm" != "0" ]; then
				echo "uci set network.lan.netmask='$Netmask_netm'"
			fi
		fi
		if [ -n "$Op_name" ] && [ "$Op_name" != "0" ]; then
			echo "uci set system.@system[0].hostname='$Op_name'"
		fi
		echo 'uci commit network'
		echo 'uci commit system'
	} >files/etc/uci-defaults/99-zzz-lan-ip
	echo "已生成 files/etc/uci-defaults/99-zzz-lan-ip(后台IP=$Ipv4_ipaddr 主机名=$Op_name)"
fi

# 首开机写入DHCP静态租约(表在下方维护:格式"名字|MAC|IP",一行一台,带#的行和空行跳过)
DHCP_STATIC="
nas|AA:BB:CC:DD:EE:01|192.168.31.10
atv|AA:BB:CC:DD:EE:02|192.168.31.20
"
if [ -n "$(echo "$DHCP_STATIC" |tr -d '[:space:]#' )" ]; then
	mkdir -p files/etc/uci-defaults
	{
		echo '#!/bin/sh'
		echo '# 首开机写入DHCP静态租约(表在diy-part.sh的DHCP_STATIC里维护)'
		echo "$DHCP_STATIC" | while IFS='|' read -r n m i; do
			case "$n" in ''|'#'*) continue ;; esac
			printf "uci add dhcp host\nuci set dhcp.@host[-1].name='%s'\nuci set dhcp.@host[-1].mac='%s'\nuci set dhcp.@host[-1].ip='%s'\n" "$n" "$m" "$i"
		done
		echo 'uci commit dhcp'
	} >files/etc/uci-defaults/99-zzz-dhcp-static
	echo "已生成 files/etc/uci-defaults/99-zzz-dhcp-static(静态租约$(echo "$DHCP_STATIC" |grep -v '^[[:space:]]*#' |grep -c '|')条)"
fi

# 首开机自定义WiFi名称/密码(密码走GitHub Secret: WIFI_PASSWORD,真实密码不写进仓库)
# 下方SSID自行修改,留空""则不改对应频段的名称;加密方式要WPA2/WPA3混合就把psk2改成sae-mixed
WIFI_SSID_2G="KsRouter"
WIFI_SSID_5G="KsRouter-5G"
WIFI_ENC="psk2"
if [ -n "$WIFI_PASSWORD" ]; then
	wifi_esc() { printf '%s' "$1" | sed 's/[&|]/\\&/g'; }
	mkdir -p files/etc/uci-defaults
	cat >files/etc/uci-defaults/99-wifi-custom <<'WIFIEOF'
#!/bin/sh
# 首开机把无线改为自定义名称/密码(编译期由Secret注入生成,真实密码不进代码仓库)
[ -f /etc/config/wireless ] || exit 1
for iface in $(uci show wireless 2>/dev/null | sed -n 's/^\(wireless\.[^.]*\)=wifi-iface$/\1/p'); do
	[ "$(uci -q get "$iface".mode)" = "ap" ] || continue
	dev=$(uci -q get "$iface".device)
	case "$(uci -q get "wireless.$dev".band)" in
		5g|5G) [ -n '__SSID5G__' ] && uci set "$iface".ssid='__SSID5G__' ;;
		*)     [ -n '__SSID2G__' ] && uci set "$iface".ssid='__SSID2G__' ;;
	esac
	[ -n '__ENC__' ] && uci set "$iface".encryption='__ENC__'
	uci set "$iface".key='__PASS__'
done
uci commit wireless
WIFIEOF
	sed -i -e "s|__SSID2G__|$(wifi_esc "$WIFI_SSID_2G")|g" \
		-e "s|__SSID5G__|$(wifi_esc "$WIFI_SSID_5G")|g" \
		-e "s|__ENC__|$(wifi_esc "$WIFI_ENC")|g" \
		-e "s|__PASS__|$(wifi_esc "$WIFI_PASSWORD")|g" \
		files/etc/uci-defaults/99-wifi-custom
	echo "已生成 files/etc/uci-defaults/99-wifi-custom(WiFi自定义)"
fi
