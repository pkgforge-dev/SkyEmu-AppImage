#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake          \
    pipewire-audio \
    pipewire-jack  \
    sdl2-compat

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

# Comment this out if you need an AUR package
#make-aur-package skyemu

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
echo "Building stable version of SkyEmu..."
echo "---------------------------------------------------------------"
REPO="https://github.com/skylersaleh/SkyEmu"
VERSION="$(curl -s https://api.github.com/repos/skylersaleh/SkyEmu/releases/latest | grep '"tag_name"' | cut -d '"' -f 4 | sed 's/^v//')"
git clone "$REPO" ./SkyEmu
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./SkyEmu
cmake . \
    -G 'Unix Makefiles' \
    -D CMAKE_BUILD_TYPE=Release \
    -D USE_SYSTEM_CURL=ON \
    -D USE_SYSTEM_OPENSSL=ON \
    -D USE_SYSTEM_SDL2=ON
make -j$(nproc)
mv -v bin/SkyEmu ../AppDir/bin
