#!/bin/sh


# Make sure our shiny new arch is up-to-date
echo "Checking for system updates..."
sudo pacman -Syu

# Create a tmp-working-dir an navigate into it
mkdir -p /tmp/pacaur_install
cd /tmp/pacaur_install

# If you didn't install the "base-devil" group,
# we'll need those.
sudo pacman -S binutils make gcc fakeroot --noconfirm

# Install pacaur dependencies from arch repos
sudo pacman -S expac yajl git --noconfirm

# Install "cower" from AUR
curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=cower
makepkg PKGBUILD --skippgpcheck
sudo pacman -U cower*.tar.xz --noconfirm

# Install "pacaur" from AUR
curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=pacaur
makepkg PKGBUILD
sudo pacman -U pacaur*.tar.xz --noconfirm

# Clean up...
cd ~
rm -r /tmp/pacaur_install
