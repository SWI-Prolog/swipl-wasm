# SWI-Prolog ported to WebAssembly

This repository contains instructions to compile a Prolog
implementation SWI-Prolog (<http://swi-prolog.org>) to
WebAssembly.

## Compilation

These compilation instructions assume Linux-based
host machine. The resulting WebAssembly binary is
platform-independent.

### Preparation

You need to download the Emscripten compiler. Follow
the instruction on its [homepage][em-install].

[em-install]:http://kripken.github.io/emscripten-site/docs/getting_started/downloads.html

After the successful installation load the Emscripten
environment into the current terminal session (asjust path):

```sh
source ./emsdk_env.sh
```

### Dependencies

SWI-Prolog depends on zlib. To compile it to WebAssembly:

```sh
wget https://zlib.net/zlib-1.2.11.tar.gz -O "$HOME/zlib-1.2.11.tar.gz"
tar -xf "$HOME/zlib-1.2.11.tar.gz" -C "$HOME"
cd "$HOME/zlib-1.2.11"
emconfigure ./configure
emmake make
```

This will download and build zlib into the `zlib-1.2.11`
subdirectory in your home directory.

### Build SWI-Prolog

```sh
git clone https://github.com/rla/swipl-devel.git "$HOME/swipl-devel"
cd "$HOME/swipl-devel"
git fetch
git checkout wasm
./prepare
```

This will ask:

```
Do you want me to run git submodule update --init? [Y/n]
```

As we are not yet building packages, say "n".

If it asks:

```
Could not find documentation.  What do you want to do?
```

Then say "3". We do not need documentation to build it.

After this we can run autoconf, configure and compile:

```
cd "$HOME/swipl-devel/src"
autoconf
LDFLAGS=-L"$HOME/zlib-1.2.11" \
  LIBS=-lzlib \
  CPPFLAGS=-I"$HOME/zlib-1.2.11" \
  COFLAGS=-O3 emconfigure ./configure \
    --disable-mt \
    --disable-gmp \
    --disable-custom-flags
emmake make
```

This will build the necessary 3 files in `$HOME/swipl-devel/src`.
See "Distribution".


## Distribution

Binary distribution (in the `dist` directory) contains
the files:

 * `swipl-web.wasm` - binary distribution of SWI-Prolog executable.
 * `swipl-web.dat` - necessary files to initialize the runtime and the library.
 * `swipl-web.js` - JavaScript wrapper that loads the wasm code and prepares the
   virtual filesystem with the runtime initialization file and the library.

