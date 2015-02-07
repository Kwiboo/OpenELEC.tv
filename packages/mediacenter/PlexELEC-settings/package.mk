################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="PlexELEC-settings"
PKG_VERSION="0.2.20"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="prop."
PKG_SITE="http://www.openelec.tv"
PKG_URL="$DISTRO_SRC/service.openelec.settings-$PKG_VERSION.zip"
PKG_DEPENDS_TARGET="toolchain Python connman pygobject dbus-python"
PKG_PRIORITY="optional"
PKG_SECTION=""
PKG_SHORTDESC="PlexELEC-settings: Settings dialog for PlexELEC"
PKG_LONGDESC="PlexELEC-settings: is a settings dialog for PlexELEC"

PKG_IS_ADDON="yes"
PKG_AUTORECONF="no"

if [ "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET setxkbmap"
else
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET bkeymaps"
fi

unpack() {
  rm -rf $BUILD/$PKG_NAME-$PKG_VERSION
  mkdir -p $BUILD/$PKG_NAME-$PKG_VERSION
  unzip -q $SOURCES/$PKG_NAME/service.openelec.settings-$PKG_VERSION.zip -d $BUILD/$PKG_NAME-$PKG_VERSION
}

make_target() {
 : # nothing todo
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/XBMC/addons/service.openelec.settings
    cp -R * $INSTALL/usr/share/XBMC/addons/service.openelec.settings

  mkdir -p $INSTALL/usr/lib/openelec
    cp $PKG_DIR/scripts/* $INSTALL/usr/lib/openelec

  # bluetooth is optional
    if [ ! "$BLUETOOTH_SUPPORT" = yes ]; then
      rm -f resources/lib/modules/bluetooth.py
    fi

  python -Wi -t -B $ROOT/$TOOLCHAIN/lib/python2.7/compileall.py $INSTALL/usr/share/XBMC/addons/service.openelec.settings/resources/lib/ -f
  rm -rf `find $INSTALL/usr/share/XBMC/addons/service.openelec.settings/resources/lib/ -name "*.py"`

  python -Wi -t -B $ROOT/$TOOLCHAIN/lib/python2.7/compileall.py $INSTALL/usr/share/XBMC/addons/service.openelec.settings/oe.py -f
  rm -rf $INSTALL/usr/share/XBMC/addons/service.openelec.settings/oe.py
}

post_install() {
  enable_service backup-restore.service
  enable_service factory-reset.service
}
