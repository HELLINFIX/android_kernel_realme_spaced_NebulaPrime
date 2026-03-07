#!/bin/env bash

# Define compile function
function compile() {
  # Load environment variables
  source ~/.bashrc
  source ~/.profile

  # Set environment variables
  export LC_ALL=C
  export USE_CCACHE=1

  TANGGAL=$(date +"%Y%m%d-%H")
  export ARCH=arm64
  export KBUILD_BUILD_HOST=Nebula
  export KBUILD_BUILD_USER="HELLINFIX"

  # Allocate 100GB of memory to ccache
  ccache -M 100G

  # Install Kernel Dependencies
  sudo apt update
  sudo apt install -y libelf-dev libarchive-tools zstd flex bc ccache libc++-dev libc++abi-dev

  # Download clang if not present
  if [[ ! -d "clang" ]]; then git clone https://gitlab.com/HELLINFIX/aosp-clang-17.0.0.git clang
  cd clang
  bash <(curl -s https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman) --patch=glibc
  ls
  cd ..
  fi

  # create output directory and do a clean or dirty build
  read -p "Wanna do dirty build? (Y/N): " build_type
  if [[ $build_type == "N" || $build_type == "n" ]]; then
  echo Deleting out directory and doing clean Build
  rm -rf out && mkdir -p out
  fi
  if [[ $build_type == "Y" || $build_type == "y" ]]; then
  echo Warning :- Doing dirty build
  fi
  if ! [[ $build_type == "Y" || $build_type == "y" ]]; then
  if ! [[ $build_type == "N" || $build_type == "n" ]]; then
  echo Invalid Input , Read carefully before typing
  echo Trying to restart script
  . build.sh && exit
  fi
  fi

  # Build the kernel
  make -j$(nproc --all) O=out ARCH=arm64 spaced_defconfig

  # Add clang bin directory to PATH
  PATH="${PWD}/clang/bin:${PATH}"

  # Build the kernel with clang and log output
  make -j$(nproc --all) O=out CC="clang" LLVM=1 CONFIG_NO_ERROR_ON_MISMATCH=y 2>&1 | tee build.log
}

function zupload()
{
zimage=out/arch/arm64/boot/Image.gz-dtb
if ! [ -a $zimage ];
then
echo  " Failed to compile zImage, fix the errors first "
else
echo -e " Build succesful, generating flashable zip now "
rm -rf AnyKernel
git clone --depth=1 https://github.com/HELLINFIX/AnyKernel3 AnyKernel
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
cd AnyKernel
zip -r9 Nebula-${TANGGAL}.zip *
curl -F "file=@Nebula-${TANGGAL}.zip" https://store1.gofile.io/uploadFile
cd ../
fi
}

# Run functions
compile
zupload