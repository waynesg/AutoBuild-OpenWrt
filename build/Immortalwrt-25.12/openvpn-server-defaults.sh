#!/bin/sh

# openvpn-openssl owns /etc/config/openvpn on 25.12.  Initialise the server
# section at first boot instead of shipping a second copy of that file.
if ! uci -q get openvpn.myvpn >/dev/null; then
	uci -q batch <<-'EOF' >/dev/null
		set openvpn.myvpn=openvpn
		set openvpn.myvpn.enabled='0'
		set openvpn.myvpn.proto='tcp-server'
		set openvpn.myvpn.port='1194'
		set openvpn.myvpn.ddns='example.com'
		set openvpn.myvpn.dev='tun'
		set openvpn.myvpn.topology='subnet'
		set openvpn.myvpn.server='10.8.0.0 255.255.255.0'
		set openvpn.myvpn.comp_lzo='adaptive'
		set openvpn.myvpn.ca='/etc/openvpn/pki/ca.crt'
		set openvpn.myvpn.dh='/etc/openvpn/pki/dh.pem'
		set openvpn.myvpn.cert='/etc/openvpn/pki/server.crt'
		set openvpn.myvpn.key='/etc/openvpn/pki/server.key'
		set openvpn.myvpn.persist_key='1'
		set openvpn.myvpn.persist_tun='1'
		set openvpn.myvpn.user='nobody'
		set openvpn.myvpn.group='nogroup'
		set openvpn.myvpn.max_clients='10'
		set openvpn.myvpn.keepalive='10 120'
		set openvpn.myvpn.verb='3'
		set openvpn.myvpn.status='/var/log/openvpn_status.log'
		set openvpn.myvpn.log='/tmp/openvpn.log'
		add_list openvpn.myvpn.push='route 192.168.1.0 255.255.255.0'
		add_list openvpn.myvpn.push='comp-lzo adaptive'
		add_list openvpn.myvpn.push='redirect-gateway def1 bypass-dhcp'
		add_list openvpn.myvpn.push='dhcp-option DNS 192.168.1.1'
		commit openvpn
	EOF
fi

if [ "$(uci -q get network.vpn0.ifname)" = "tun0" ]; then
	uci set network.vpn0.device='tun0'
	uci delete network.vpn0.ifname
	uci commit network
fi

exit 0
