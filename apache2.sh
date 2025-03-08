#!/bin/bash

# Megnézi hogy sudo-val van-e futtatva
if [ "$EUID" -ne 0 ]; then
	echo -e "\n ⛔sudo-val futtasd te bolond🥱 ⛔ \n"
	exit 1
fi

if $(whcich apache2); then
	echo -e "\n Már telepítve van az apache2 \n"
else
	apt update && apt install apache2 -y && systemctl enable apache2 && systemctl status apache2
fi
