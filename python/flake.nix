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
          libxcb
          python313Packages.torchvision
          graphviz
          uv
        ];
        shellHook = ''
          export QT_QPA_PLATFORM_PLUGIN_PATH="${pkgs.qt5.qtbase.bin}/lib/qt-${pkgs.qt5.qtbase.version}/plugins/platforms"
        '';
      };
    };
}
