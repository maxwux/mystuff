#!/bin/bash
cd /tmp
VERSION=`curl http://googlechromereleases.blogspot.tw/search/label/Stable%20updates 2>/dev/null|grep "The Stable channel has been updated to "|head -n1|awk 'BEGIN {FS=">"} {print $5}'|awk 'BEGIN {FS=" "} {print $8}'`
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.rpm
I386MD5=`md5sum google-chrome-stable_current_i386.rpm |awk 'BEGIN {FS=" "} {print $1}'`
X64MD5=`md5sum google-chrome-stable_current_x86_64.rpm |awk 'BEGIN {FS=" "} {print $1}'`
rm PKGBUILD 2>/dev/null
rm google-chrome.install 2>/dev/null

cat << EOF >> PKGBUILD
# Maintainer: t3ddy  <t3ddy1988 "at" gmail {dot} com>
# Maintainer: maxwux  <maxwux "at" gmail {dot} com>
# Contributor: aur2ccr (http://ddg.gg/?q=!ccr+aur2ccr&t=chakra)
# Contributor: Lex Rivera aka x-demon <aur@x-demon.org>
# Contributor: Det <nimetonmaili at gmail a-dot com>
# Contributor: ruario

pkgname=google-chrome
pkgver=$VERSION   # Check for new Linux releases in: http://googlechromereleases.blogspot.com/search/label/Stable%20updates
pkgrel=1
pkgdesc="An attempt at creating a safer, faster, and more stable browser (Stable Channel)"
arch=('i686' 'x86_64')
url="http://www.google.com/chrome"
license=('custom:chrome')
depends=('alsa-lib' 'gconf' 'gtk2' 'hicolor-icon-theme' 'libpng12' 'libxslt' 'libxss' 'nss' 'ttf-dejavu' 'xdg-utils')
optdepends=('kdebase-kdialog: needed for file dialogs in KDE' 'openssl098: needed for built-in flash-plugin to work')
provides=("google-chrome=\$pkgver")
conflicts=('google-chrome')
install=\${pkgname}.install
_channel='stable'

if [ "\$CARCH" = "i686" ]; then
    _arch='i386'
    md5sums=('$I386MD5')
elif [ "\$CARCH" = "x86_64" ]; then
    _arch='x86_64'
    md5sums=('$X64MD5')
fi


source=("https://dl.google.com/linux/direct/google-chrome-stable_current_\${_arch}.rpm")


package() {
    msg "Preparing install"
    install -d "\$pkgdir"/{opt,usr/{bin,share/applications}}
    mv opt/google "\$pkgdir"/opt
    msg2 "Done preparing!"

    msg "Actual installation"
    ln -s /opt/google/chrome/google-chrome "\$pkgdir/usr/bin/"
    mv "\$pkgdir/opt/google/chrome/google-chrome.desktop" "\$pkgdir/usr/share/applications"
    
    # Udev workaround
    ln -s /usr/lib/libudev.so.1.0.1 "\$pkgdir/opt/google/chrome/libudev.so.0"

    # Adding man page
    if [ ! -e "\$srcdir/usr/share/man/man1/google-chrome.1.gz" ]; then
      gzip -9 "\$srcdir/usr/share/man/man1/google-chrome.1"
    fi
    install -Dm644 "\$srcdir/usr/share/man/man1/google-chrome.1.gz" "\$pkgdir/usr/share/man/man1/google-chrome.1.gz"

    # Symlinking icons to /usr/share/icons/hicolor/
    for i in 16x16 22x22 24x24 32x32 48x48 64x64 128x128 256x256; do
      mkdir -p "\$pkgdir/usr/share/icons/hicolor/\$i/apps/"
      ln -s /opt/google/chrome/product_logo_\${i/x*}.png "\$pkgdir/usr/share/icons/hicolor/\$i/apps/google-chrome.png"
    done

    # Fixing permissions of chrome-sandbox
    chmod 4755 "\$pkgdir/opt/google/chrome/chrome-sandbox"

    msg2 "Installation finished!"
}
EOF

cat << EOF2 >> google-chrome.install
post_install() {
        gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor
}

post_remove() {
        post_install
}
EOF2

makepkg --source -f
ccr-tools --submit google-chrome-$VERSION-1.src.tar.gz
