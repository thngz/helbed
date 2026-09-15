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
          python313Packages.opencv4Full
          python313Packages.scipy
          python313Packages.sympy
          python313Packages.numpy
          python313Packages.matplotlib
          python313Packages.black
          python313Packages.flask
          python313Packages.fastecdsa
          python313Packages.jupyter-core
          python313Packages.jupyter-client
          python313Packages.ipython
          python313Packages.tkinter
          python313Packages.rasterio
          python313Packages.pycryptodome
          python313Packages.pwntools
          python313Packages.pyqt5
          
          qt5.qtbase
          qt5.qtwayland
          libxcb
          python313Packages.torchWithRocm
          #python313Packages.torchvision
          uv
          python313Packages.python-dotenv
          python313Packages.ultralytics
          python313Packages.imageio
          python313Packages.av
          python313Packages.imageio-ffmpeg
          rocmPackages.rocrand
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
