#!/usr/bin/env bash
set -euo pipefail

# ===== VARIABLES =====

DEFCONFIG=spaced_defconfig
KERNEL_NAME=Nebula
CLANG_DIR=clang
OUT=out
THREADS=$(nproc --all)
DATE=$(date +"%Y%m%d-%H")
IMAGE=$OUT/arch/arm64/boot/Image.gz-dtb

export ARCH=arm64
export LC_ALL=C
export USE_CCACHE=1
export KBUILD_BUILD_HOST=Nebula
export KBUILD_BUILD_USER=HELLINFIX

# ===== TOOLCHAIN =====

setup_clang() {

if [[ ! -x "$CLANG_DIR/bin/clang" ]]; then
    echo "[*] Fetching clang toolchain..."

    git clone --depth=1 https://gitlab.com/HELLINFIX/aosp-clang-17.0.0.git "$CLANG_DIR"

    pushd "$CLANG_DIR" >/dev/null
    bash <(curl -s https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman) --patch=glibc
    popd >/dev/null
fi

export PATH="$PWD/$CLANG_DIR/bin:$PATH"

}

# ===== CCACHE =====

setup_ccache() {

if command -v ccache >/dev/null; then
    echo "[*] Setting up ccache"

    export CC="ccache clang"
    export CXX="ccache clang++"

    ccache -M 100G
    ccache -z
else
    echo "[!] ccache not found"
fi

}

# ===== CLEAN BUILD OPTION =====

prepare_out() {

read -rp "Dirty build? (y/n): " build_type

case "$build_type" in
n|N)
    echo "[*] Performing clean build"
    rm -rf "$OUT"
    ;;
y|Y)
    echo "[*] Performing dirty build"
    ;;
*)
    echo "[!] Invalid input"
    exit 1
    ;;
esac

mkdir -p "$OUT"

}

# ===== BUILD =====

build_kernel() {

echo "[*] Starting kernel compilation..."

make -j"$THREADS" \
O="$OUT" \
ARCH=arm64 \
"$DEFCONFIG"

make -j"$THREADS" \
O="$OUT" \
LLVM=1 \
LLVM_IAS=1 \
CC=clang \
CONFIG_NO_ERROR_ON_MISMATCH=y \
2>&1 | tee build.log

}

# ===== ZIP =====

make_zip() {

if [[ ! -f "$IMAGE" ]]; then
    echo "[✗] Kernel image missing — build failed"
    exit 1
fi

echo "[✓] Kernel built successfully"

rm -rf AnyKernel

git clone --depth=1 https://github.com/HELLINFIX/AnyKernel3 AnyKernel

cp "$IMAGE" AnyKernel/

pushd AnyKernel >/dev/null

ZIPNAME="${KERNEL_NAME}-${DATE}.zip"

echo "[*] Creating flashable zip"

zip -r9 "$ZIPNAME" . -x "*.git*" "*.github*" "*.md"

echo "[*] Uploading build"

curl -s -F "file=@$ZIPNAME" https://store1.gofile.io/uploadFile

popd >/dev/null

echo "[✓] Build finished"

}

# ===== MAIN =====

setup_clang
setup_ccache
prepare_out
build_kernel
make_zip