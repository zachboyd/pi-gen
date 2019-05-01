#!/bin/bash -e

install -v -d					"${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d"
install -v -m 644 files/wait.conf		"${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d/"

install -v -d					"${ROOTFS_DIR}/etc/wpa_supplicant"
install -v -m 600 files/wpa_supplicant.conf	"${ROOTFS_DIR}/etc/wpa_supplicant/"

if [ -v WPA_COUNTRY ]; then
	echo "country=${WPA_COUNTRY}" >> "${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant.conf"
fi

if [ -v WPA_ESSID ] && [ -v WPA_PASSWORD ]; then
on_chroot <<EOF
wpa_passphrase "${WPA_ESSID}" "${WPA_PASSWORD}" >> "/etc/wpa_supplicant/wpa_supplicant.conf"
EOF
fi

echo "\ninterface eth0\nstatic ip_address=192.168.1.50/24\nstatic routers=192.168.1.1\nstatic domain_name_servers=192.168.1.1 8.8.8.8" >> "${ROOTFS_DIR}/etc/dhcpcd.conf"
echo "net.ipv6.conf.all.disable_ipv6 = 1" > "${ROOTFS_DIR}/etc/sysctl.d/local.conf"
