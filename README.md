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

After this we can run configure and compile:

```sh
cd "$HOME/swipl-devel/src"
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

## Usage

Please see "Foreign Language Interface" (FLI) in the SWI-Prolog manual. A very limited
set of function findings into JavaScript can be seen in the demo.
The bindings use [cwrap][cwrap] from Emscripten.

[cwrap]:https://kripken.github.io/emscripten-site/docs/api_reference/preamble.js.html#cwrap

General workflow:

 * Set up a stub [Module object][module] with `noInitialRun: true` and other options.
 * Set up FLI bindings in `Module.onRuntimeInitialized`.
 * Use the bindings to call `PL_initialise`.
 * Set up the location for standard library.
 * Use the [FS API][fs] to write code files into the virtual filesystem.
 * Load the code files from SWI-Prolog side using `consult/1` or a similar way.
 * Interact with SWI-Prolog through its FLI.

[module]:https://kripken.github.io/emscripten-site/docs/api_reference/module.html
[fs]:https://kripken.github.io/emscripten-site/docs/api_reference/Filesystem-API.html

### Demo

See `example/index.html` as a simple example. It can be found online at
<http://demos.rlaanemets.com/swi-prolog-wasm/example/>. The commented code
inside the demo provides the documentation.

To test it out locally, you need to serve the files through an HTTP server.

## TODO

 * Provide full set of bindings?
 * A way to call JavaScript from SWI-Prolog.
 * Compile and add useful packages.
 * Provide a mechanism to load packs?
 * Easier way to turn Prolog terms into JS objects?
 * See where WebAssembly goes and what interfaces
   could be added (direct DOM access?).

## License

SWI-Prolog is covered with the Simplified BSD license. See <http://www.swi-prolog.org/license.html>

zlib is covered with the zlib license. See <https://zlib.net/zlib_license.html>

