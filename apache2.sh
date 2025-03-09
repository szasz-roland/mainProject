#!/bin/bash

# Csomaglista frissítése
sudo apt update

# Telepítés 
sudo apt install apache2 -y

# Engedélyezés és indítás
sudo systemctl enable apache2
sudo systemctl start apache2

# Ellenőrzés
if command -v apache2 >/dev/null 2>&1; then
	echo "Apache2 telepítve"
	sudo systemctl status apache2
	exit 0
else
	echo -e "Apache2 telepítés nem sikerült...\n OLVASD EL A HIBÁT!"
	exit 1
fi
