{
  description = "Simple flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          python313
          basedpyright
          python313Packages.requests
          python313Packages.numpy
          python313Packages.matplotlib
          python313Packages.black
          python313Packages.flask
          python313Packages.jupyter-core
          python313Packages.jupyter-client
          python313Packages.ipython
          python313Packages.tkinter
          python313Packages.rasterio
          python313Packages.pwntools
          python313Packages.pyqt5
          python313Packages.duckdb
          python313Packages.pyarrow
          python313Packages.altair
          python313Packages.rapidfuzz
          marimo
          qt5.qtbase
          qt5.qtwayland
          libxcb
          uv
          python313Packages.python-dotenv
          mpremote
          micropython
        ];
        shellHook = ''
          export QT_QPA_PLATFORM_PLUGIN_PATH="${pkgs.qt5.qtbase.bin}/lib/qt-${pkgs.qt5.qtbase.version}/plugins/platforms"
          export LD_LIBRARY_PATH=${
            pkgs.lib.makeLibraryPath [
              pkgs.libxcb
              pkgs.libGL
              pkgs.glib
              pkgs.stdenv.cc.cc.lib
            ]
          }:$LD_LIBRARY_PATH
        '';
      };
    };
}
