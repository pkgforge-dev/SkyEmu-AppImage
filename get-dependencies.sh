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

echo "Building stable version of SkyEmu..."
echo "---------------------------------------------------------------"
REPO="https://github.com/skylersaleh/SkyEmu"
VERSION="$(curl -s https://api.github.com/repos/skylersaleh/SkyEmu/releases/latest | grep '"tag_name"' | cut -d '"' -f 4 | sed 's/^v//')"
git clone "$REPO" ./SkyEmu
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./SkyEmu
git checkout "$VERSION"
cmake . \
    -G 'Unix Makefiles' \
    -D CMAKE_BUILD_TYPE=Release \
    -D USE_SYSTEM_CURL=ON \
    -D USE_SYSTEM_OPENSSL=ON \
    -D USE_SYSTEM_SDL2=ON
make -j$(nproc)
mv -v bin/SkyEmu ../AppDir/bin
