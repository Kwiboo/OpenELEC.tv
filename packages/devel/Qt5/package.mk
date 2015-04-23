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

PKG_NAME="Qt5"
PKG_VERSION="5.4.1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://qt-project.org"
PKG_URL="http://download.qt.io/archive/qt/5.4/${PKG_VERSION}/submodules/qt5-opensource-src-${PKG_VERSION}.tar.xz http://download.qt.io/archive/qt/5.4/${PKG_VERSION}/submodules/qtbase-opensource-src-${PKG_VERSION}.tar.xz "
PKG_DEPENDS_TARGET="toolchain glib zlib libressl libpng"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="Qt Open Source Edition"
PKG_LONGDESC="Qt Open Source Edition"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

if [ "$KODIPLAYER_DRIVER" = "bcm2835-driver" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET bcm2835-driver"
fi

TARGET_CONFIGURE_OPTS=""
PKG_CONFIGURE_OPTS_TARGET="-verbose \
                    -prefix /usr \
                    -hostprefix ${ROOT}/${TOOLCHAIN} \
                    -sysroot ${SYSROOT_PREFIX} \
                    -release \
                    -opensource \
                    -confirm-license \
                    -no-accessibility \
                    -no-sql-sqlite \
                    -no-qml-debug \
                    -no-mtdev \
                    -no-gif \
                    -no-libjpeg \
                    -no-freetype \
                    -no-harfbuzz \
                    -no-xinput2 \
                    -no-xcb-xlib \
                    -no-pulseaudio \
                    -no-alsa \
                    -no-gtkstyle \
                    -no-widgets \
                    -no-rpath \
                    -no-nis \
                    -no-cups \
                    -no-iconv \
                    -no-evdev \
                    -no-icu \
                    -no-pch \
                    -no-dbus \
                    -no-xcb \
                    -no-eglfs \
                    -no-directfb \
                    -no-linuxfb \
                    -no-kms \
                    -no-egl \
                    -no-opengl \
                    -no-openvg \
                    -force-pkg-config \
                    -device linux-openelec-g++ \
                    -device-option CROSS_COMPILE=$TARGET_PREFIX \
                    -device-option TARGET_CFLAGS=\\\"\$TARGET_CFLAGS\\\" \
                    -device-option TARGET_CXXFLAGS=\\\"\$TARGET_CXXFLAGS\\\" \
                    -device-option TARGET_LDFLAGS=\\\"\$TARGET_LDFLAGS\\\" \
                    -optimized-qmake \
                    -make libs"

unpack() {
  rm -rf $PKG_BUILD
  mkdir -p $PKG_BUILD
  tar xJf $SOURCES/$PKG_NAME/qt5-opensource-src-${PKG_VERSION}.tar.xz -C $PKG_BUILD --strip-components=1
  mkdir -p $PKG_BUILD/qtbase
  tar xJf $SOURCES/$PKG_NAME/qtbase-opensource-src-${PKG_VERSION}.tar.xz -C $PKG_BUILD/qtbase --strip-components=1
}

pre_configure_target() {
# Qt5 fails to build in subdirs
  cd $ROOT/$PKG_BUILD
    rm -rf .$TARGET_NAME

# setup Qt5 env vars
  unset CC CXX AR OBJCOPY STRIP CFLAGS CXXFLAGS CPPFLAGS LDFLAGS LD RANLIB
  export TARGET_PREFIX TARGET_CFLAGS TARGET_CXXFLAGS TARGET_LDFLAGS
  export PKG_CONFIG_PATH="$TARGET_PKG_CONFIG_LIBDIR"
}

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/lib
    cp -P $SYSROOT_PREFIX/usr/lib/libQt5Core.so* $INSTALL/usr/lib
    cp -P $SYSROOT_PREFIX/usr/lib/libQt5Network.so* $INSTALL/usr/lib
    cp -P $SYSROOT_PREFIX/usr/lib/libQt5Gui.so* $INSTALL/usr/lib
}
