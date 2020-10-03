############################
# 1. Install Dependencies  #
############################
apt update
apt upgrade

apt-get install -y \
	apt-utils \
	build-essential cmake pkg-config \
	git \
	ncurses-dev libreadline-dev libedit-dev \
	libgoogle-perftools-dev \
	libunwind-dev \
	libgmp-dev \
	libssl-dev \
	unixodbc-dev \
	zlib1g-dev libarchive-dev \
	libossp-uuid-dev \
	libxext-dev libice-dev libjpeg-dev libxinerama-dev libxft-dev \
	libxpm-dev libxt-dev \
	libdb-dev \
	libpcre3-dev \
	libyaml-dev \
	python3

############################
# 1. Build ZLib   #
############################

wget https://zlib.net/zlib-1.2.11.tar.gz -O "$HOME/zlib-1.2.11.tar.gz"
tar -xf "$HOME/zlib-1.2.11.tar.gz" -C "$HOME"
cd "$HOME/zlib-1.2.11"
emconfigure ./configure
emmake make

########################################################
# 2.  Build Emscripten   
########################################################

cd $HOME
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh

########################################################
# 4.  Build SWIPL       
########################################################

cd $HOME
git clone https://github.com/SWI-Prolog/swipl-devel.git
cd swipl-devel
git submodule update --init
#
# 4.a. Build 'Development' Build...
#
mkdir build
cd build
cmake -DSWIPL_PACKAGES_JAVA=OFF ..
make
make install
#
# 4.a. Build 'WASM' 'Development' Build...
#
cd $HOME/swipl-devel
mkdir build.wasm
cd build.wasm

cmake -DCMAKE_TOOLCHAIN_FILE=$HOME/emsdk/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake \
      -DCMAKE_BUILD_TYPE=Release \
		  -DZLIB_LIBRARY=$HOME/zlib-1.2.11/libz.a \
		  -DZLIB_INCLUDE_DIR=$HOME/zlib-1.2.11 \
      -DMULTI_THREADED=OFF \
      -DUSE_SIGNALS=OFF \
      -DUSE_GMP=OFF \
      -DBUILD_SWIPL_LD=OFF \
      -DSWIPL_PACKAGES=OFF \
      -DINSTALL_DOCUMENTATION=OFF \
      -DSWIPL_NATIVE_FRIEND=build \
      -G "Unix Makefiles" ..

emmake make
