{ pkgs ? import <nixpkgs> {} }:

let
  # Combined tools and libraries for AMD64
  allLibs = with pkgs; [
    # LLVM/Clang toolchain
    llvmPackages_20.llvm
    llvmPackages_20.clang
    llvmPackages_20.lld
    llvmPackages_20.compiler-rt
    llvmPackages_20.libcxx
    llvmPackages_20.libcxxClang
    llvmPackages_20.bintools
    llvmPackages_20.clang-tools
    # System and third-party libraries (from library/lib)
    glibc glibc.dev glibc.static
    gcc-unwrapped gcc-unwrapped.lib gcc-unwrapped.out
    zlib zlib.dev zlib.static
    bzip2 bzip2.dev
    xz xz.dev
    libxml2 libxml2.dev libxml2.out
    expat expat.dev expat.out
    openssl openssl.dev openssl.out
    curl curl.dev curl.out
    pcre pcre.dev pcre.out
    pcre2 pcre2.dev pcre2.out
    jansson jansson.dev jansson.out
    sqlite sqlite.dev sqlite.out
    libpng libpng.dev libpng.out
    libjpeg libjpeg.dev libjpeg.out
    util-linux util-linux.dev util-linux.out
  ];

  # Create the sysroot structure
  sysroot = pkgs.stdenv.mkDerivation {
    name = "bazel-sysroot-llvm-amd64";
    version = "1.0.0";

    buildInputs = allLibs;

    buildCommand = ''
      # Create sysroot directory structure
      mkdir -p $out/sysroot/bin
      mkdir -p $out/sysroot/include
      mkdir -p $out/sysroot/lib

      # Copy LLVM tools
      echo "Copying LLVM tools..."
      if [ -d "${pkgs.llvmPackages_20.llvm}/bin" ]; then cp -r ${pkgs.llvmPackages_20.llvm}/bin/* $out/sysroot/bin/ || true; fi
      if [ -d "${pkgs.llvmPackages_20.clang}/bin" ]; then cp -r ${pkgs.llvmPackages_20.clang}/bin/* $out/sysroot/bin/ || true; fi
      if [ -d "${pkgs.llvmPackages_20.lld}/bin" ]; then cp -r ${pkgs.llvmPackages_20.lld}/bin/* $out/sysroot/bin/ || true; fi
      if [ -d "${pkgs.llvmPackages_20.compiler-rt}/bin" ]; then cp -r ${pkgs.llvmPackages_20.compiler-rt}/bin/* $out/sysroot/bin/ || true; fi
      if [ -d "${pkgs.llvmPackages_20.libcxx}/bin" ]; then cp -r ${pkgs.llvmPackages_20.libcxx}/bin/* $out/sysroot/bin/ || true; fi
      if [ -d "${pkgs.llvmPackages_20.libcxxClang}/bin" ]; then cp -r ${pkgs.llvmPackages_20.libcxxClang}/bin/* $out/sysroot/bin/ || true; fi
      if [ -d "${pkgs.llvmPackages_20.bintools}/bin" ]; then cp -r ${pkgs.llvmPackages_20.bintools}/bin/* $out/sysroot/bin/ || true; fi
      if [ -d "${pkgs.llvmPackages_20.clang-tools}/bin" ]; then cp -r ${pkgs.llvmPackages_20.clang-tools}/bin/* $out/sysroot/bin/ || true; fi

      # Copy include files (from LLVM and system/third-party)
      echo "Copying include files..."
      if [ -d "${pkgs.llvmPackages_20.llvm}/include" ]; then cp -r ${pkgs.llvmPackages_20.llvm}/include/* $out/sysroot/include/ || true; fi
      if [ -d "${pkgs.llvmPackages_20.clang}/include" ]; then cp -r ${pkgs.llvmPackages_20.clang}/include/* $out/sysroot/include/ || true; fi
      if [ -d "${pkgs.llvmPackages_20.libcxx}/include" ]; then cp -r ${pkgs.llvmPackages_20.libcxx}/include/* $out/sysroot/include/ || true; fi
      # System/third-party headers
      if [ -d "${pkgs.glibc.dev}/include" ]; then cp -r ${pkgs.glibc.dev}/include/* $out/sysroot/include/ || true; fi
      if [ -d "${pkgs.gcc-unwrapped.lib}/include" ]; then cp -r ${pkgs.gcc-unwrapped.lib}/include/* $out/sysroot/include/ || true; fi
      if [ -d "${pkgs.zlib.dev}/include" ]; then cp -r ${pkgs.zlib.dev}/include/* $out/sysroot/include/ || true; fi
      if [ -d "${pkgs.bzip2.dev}/include" ]; then cp -r ${pkgs.bzip2.dev}/include/* $out/sysroot/include/ || true; fi
      if [ -d "${pkgs.xz.dev}/include" ]; then cp -r ${pkgs.xz.dev}/include/* $out/sysroot/include/ || true; fi
      if [ -d "${pkgs.libxml2.dev}/include" ]; then cp -r ${pkgs.libxml2.dev}/include/* $out/sysroot/include/ || true; fi
      if [ -d "${pkgs.expat.dev}/include" ]; then cp -r ${pkgs.expat.dev}/include/* $out/sysroot/include/ || true; fi
      if [ -d "${pkgs.openssl.dev}/include" ]; then cp -r ${pkgs.openssl.dev}/include/* $out/sysroot/include/ || true; fi
      if [ -d "${pkgs.curl.dev}/include" ]; then cp -r ${pkgs.curl.dev}/include/* $out/sysroot/include/ || true; fi
      if [ -d "${pkgs.pcre.dev}/include" ]; then cp -r ${pkgs.pcre.dev}/include/* $out/sysroot/include/ || true; fi
      if [ -d "${pkgs.pcre2.dev}/include" ]; then cp -r ${pkgs.pcre2.dev}/include/* $out/sysroot/include/ || true; fi
      if [ -d "${pkgs.jansson.dev}/include" ]; then cp -r ${pkgs.jansson.dev}/include/* $out/sysroot/include/ || true; fi
      if [ -d "${pkgs.sqlite.dev}/include" ]; then cp -r ${pkgs.sqlite.dev}/include/* $out/sysroot/include/ || true; fi
      if [ -d "${pkgs.libpng.dev}/include" ]; then cp -r ${pkgs.libpng.dev}/include/* $out/sysroot/include/ || true; fi
      if [ -d "${pkgs.libjpeg.dev}/include" ]; then cp -r ${pkgs.libjpeg.dev}/include/* $out/sysroot/include/ || true; fi
      if [ -d "${pkgs.util-linux.dev}/include" ]; then cp -r ${pkgs.util-linux.dev}/include/* $out/sysroot/include/ || true; fi

      # Copy library files (from LLVM and system/third-party)
      echo "Copying library files..."
      if [ -d "${pkgs.llvmPackages_20.llvm}/lib" ]; then cp -r ${pkgs.llvmPackages_20.llvm}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.llvmPackages_20.clang}/lib" ]; then cp -r ${pkgs.llvmPackages_20.clang}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.llvmPackages_20.lld}/lib" ]; then cp -r ${pkgs.llvmPackages_20.lld}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.llvmPackages_20.compiler-rt}/lib" ]; then cp -r ${pkgs.llvmPackages_20.compiler-rt}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.llvmPackages_20.libcxx}/lib" ]; then cp -r ${pkgs.llvmPackages_20.libcxx}/lib/* $out/sysroot/lib/ || true; fi
      # System/third-party libraries
      if [ -d "${pkgs.glibc}/lib" ]; then cp -r ${pkgs.glibc}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.glibc.dev}/lib" ]; then cp -r ${pkgs.glibc.dev}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.glibc.static}/lib" ]; then cp -r ${pkgs.glibc.static}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.gcc-unwrapped.lib}/lib" ]; then cp -Lr ${pkgs.gcc-unwrapped.lib}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.gcc-unwrapped.out}/lib" ]; then cp -r ${pkgs.gcc-unwrapped.out}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.zlib}/lib" ]; then cp -r ${pkgs.zlib}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.zlib.dev}/lib" ]; then cp -r ${pkgs.zlib.dev}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.zlib.static}/lib" ]; then cp -r ${pkgs.zlib.static}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.bzip2}/lib" ]; then cp -r ${pkgs.bzip2}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.bzip2.dev}/lib" ]; then cp -r ${pkgs.bzip2.dev}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.xz}/lib" ]; then cp -r ${pkgs.xz}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.xz.dev}/lib" ]; then cp -r ${pkgs.xz.dev}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.libxml2}/lib" ]; then cp -r ${pkgs.libxml2}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.libxml2.dev}/lib" ]; then cp -r ${pkgs.libxml2.dev}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.libxml2.out}/lib" ]; then cp -r ${pkgs.libxml2.out}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.expat}/lib" ]; then cp -r ${pkgs.expat}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.expat.dev}/lib" ]; then cp -r ${pkgs.expat.dev}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.expat.out}/lib" ]; then cp -r ${pkgs.expat.out}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.openssl}/lib" ]; then cp -r ${pkgs.openssl}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.openssl.dev}/lib" ]; then cp -r ${pkgs.openssl.dev}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.openssl.out}/lib" ]; then cp -r ${pkgs.openssl.out}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.curl}/lib" ]; then cp -r ${pkgs.curl}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.curl.dev}/lib" ]; then cp -r ${pkgs.curl.dev}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.curl.out}/lib" ]; then cp -r ${pkgs.curl.out}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.pcre}/lib" ]; then cp -r ${pkgs.pcre}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.pcre.dev}/lib" ]; then cp -r ${pkgs.pcre.dev}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.pcre.out}/lib" ]; then cp -r ${pkgs.pcre.out}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.pcre2}/lib" ]; then cp -r ${pkgs.pcre2}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.pcre2.dev}/lib" ]; then cp -r ${pkgs.pcre2.dev}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.pcre2.out}/lib" ]; then cp -r ${pkgs.pcre2.out}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.jansson}/lib" ]; then cp -r ${pkgs.jansson}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.jansson.dev}/lib" ]; then cp -r ${pkgs.jansson.dev}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.jansson.out}/lib" ]; then cp -r ${pkgs.jansson.out}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.sqlite}/lib" ]; then cp -r ${pkgs.sqlite}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.sqlite.dev}/lib" ]; then cp -r ${pkgs.sqlite.dev}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.sqlite.out}/lib" ]; then cp -r ${pkgs.sqlite.out}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.libpng}/lib" ]; then cp -r ${pkgs.libpng}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.libpng.dev}/lib" ]; then cp -r ${pkgs.libpng.dev}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.libpng.out}/lib" ]; then cp -r ${pkgs.libpng.out}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.libjpeg}/lib" ]; then cp -r ${pkgs.libjpeg}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.libjpeg.dev}/lib" ]; then cp -r ${pkgs.libjpeg.dev}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.libjpeg.out}/lib" ]; then cp -r ${pkgs.libjpeg.out}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.util-linux}/lib" ]; then cp -r ${pkgs.util-linux}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.util-linux.dev}/lib" ]; then cp -r ${pkgs.util-linux.dev}/lib/* $out/sysroot/lib/ || true; fi
      if [ -d "${pkgs.util-linux.out}/lib" ]; then cp -r ${pkgs.util-linux.out}/lib/* $out/sysroot/lib/ || true; fi

      # Create GNU tool symlinks
      cd $out/sysroot/bin
      ln -sf clang gcc
      ln -sf clang cc
      ln -sf clang++ c++
      ln -sf clang-cpp cpp
      ln -sf llvm-ar ar
      ln -sf llvm-ar ranlib
      ln -sf llvm-as as
      ln -sf ld.lld ld
      ln -sf llvm-nm nm
      ln -sf llvm-objcopy objcopy
      ln -sf llvm-objdump objdump
      ln -sf llvm-strip strip
      ln -sf llvm-dwp dwp
      ln -sf llvm-c++filt c++filt
      ln -sf llvm-cov gcov

    # # Copy Bazel configuration file
    # cp ${./bazel/BUILD.bazel} $out/sysroot/BUILD.bazel
    # cp ${./bazel/cc_toolchain_config.bzl} $out/sysroot/cc_toolchain_config.bzl
    '';

    meta = with pkgs.lib; {
      description = "AMD64-specific LLVM tools for Bazel builds";
      homepage = "https://github.com/yourusername/bazel_sysroot_llvm_amd64";
      license = licenses.mit;
      platforms = [ "x86_64-linux" ];
    };
  };
in
sysroot