#!/bin/bash

# Megnézi higy sudo vagy-e
if [ "$EUID" -ne 0 ]; then
	echo -e "\n ⛔sudo-val futtasd te bolond🥱 ⛔ \n"
	exit 1
fi

echo -e "
╔─────────────────────────────────────────────────────────╗
│                                                         │
│  ██████╗ ██╗  ██╗ ██████╗██████╗     ██╗   ██╗██╗  ██╗  │
│  ██╔══██╗██║  ██║██╔════╝██╔══██╗    ██║   ██║██║  ██║  │
│  ██║  ██║███████║██║     ██████╔╝    ██║   ██║███████║  │
│  ██║  ██║██╔══██║██║     ██╔═══╝     ╚██╗ ██╔╝╚════██║  │
│  ██████╔╝██║  ██║╚██████╗██║          ╚████╔╝      ██║  │
│  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝           ╚═══╝       ╚═╝  │
│                                                         │
╚─────────────────────────────────────────────────────────╝
"
#Megnézi ha telepítve van a 'isc-dhcp-server' akkor skip the ha nincs akkor letülti
if apt list --installed | grep -qw isc-dhcp-server; then
    echo -e "\n ✅isc-dhcp-server már telepítve van ✅ \n"
else
	echo "Installing isc-dhcp-server..."
	sudo apt update
	sudo apt install isc-dhcp-server -y
	echo "Kész ✅"
fi

#DHCPv4 szórási interfész bekérése
read -p "Add meg az interfészt amin szeretnéd szórni a DHCP ip címetket (🚫BRIDGE KÁRTY TILOS🚫)" DHCP_INTERFACE

# Ugye ne legyen üres
if [ -z "$DHCP_INTERFACE" ]; then
    echo "🚫Ha nem adsz meg interface nevet akkor nem fog működni!🚫"
    exit 1
fi

#Interfész kicserélése  konfigurációs fájlban
sed -i "s/^INTERFACESv4=.*/INTERFACESv4=\"$DHCP_INTERFACE\"/" /etc/default/isc-dhcp-server

cat <<EOF > /home/sr/scripts/test_dhcp
subnet 192.168.1.0 netmask 255.255.255.0 {
    range 192.168.1.100 192.168.1.200;
    option routers 192.168.1.1;
    option domain-name-servers 8.8.8.8, 8.8.4.4;  # Example DNS servers
    option broadcast-address 192.168.1.255;
    default-lease-time 600;
    max-lease-time 7200;
}
EOF

