{
  description = "A devShell example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };
      in {
        devShells.default = with pkgs;
          mkShell {
            buildInputs = [
              openssl
              pkg-config
              eza
              fd
              rust-bin.beta.latest.default
              rust-analyzer
              clippy
              libxkbcommon
              lz4
              wayland-protocols
              wayland

              python312Packages.fastapi
              python312Packages.uvicorn
              python312Packages.transformers
              python312Packages.torch
              python312Packages.accelerate
              python312Packages.diffusers
              python312Packages.pillow
              python312Packages.pydantic
              basedpyright
              pkgs.python312Packages.black
              pkgs.python312Packages.pyserial
              pkgs.python312Packages.scipy
              pkgs.python312Packages.pip
              intel-graphics-compiler
              mkl
            ];

            shellHook = ''
              alias ls=eza
              alias find=fd
            '';
          };
        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
          pkgs.mkl
          pkgs.intel-ocl
          pkgs.intel-media-driver
          pkgs.intel-compute-runtime
          pkgs.level-zero
          pkgs.vpl-gpu-rt
          pkgs.openssl
          pkgs.zlib
          pkgs.stdenv.cc.cc.lib
        ];
        PKG_CONFIG_PATH =
          "${pkgs.wayland.dev}/lib/pkgconfig:${pkgs.wayland-protocols}/share/pkgconfig";
      });
}
