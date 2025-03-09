#!/bin/bash

# Csomaglista frissítése
sudo apt update

# add-apt-repository-t tartalmazó csomag telepítése
sudo apt install -y software-properties-common

# Repository csomaglitához adás majd csomaglista frissítése
sudo add-apt-repository ppa:ondrej/php
sudo apt update

# Telepítése
install_php_version() {
    local version=$1
    sudo apt install -y php$version php$version-cli php$version-common php$version-mysql php$version-zip php$version-gd php$version-mbstring php$version-curl php$version-xml php$version-bcmath
}

for version in 7.3 7.4 8.0 8.1 8.2 8.3 8.4; do
    echo "PHP $version és modulok telepítése..."
    install_php_version $version
done

echo "PHP verziók és hozzájuk tartozó modulok telepítve!"

# Ellenőrzés
for version in 7.3 7.4 8.0 8.1 8.2 8.3 8.4; do
	if command -v php$version-cli >/dev/null 2>&1; then
        echo "PHP $version telepítve."
    else
        echo "PHP $version NINCS telepítve."
    fi
done
