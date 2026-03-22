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
          python313Packages.opencv4
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
          python313Packages.pycryptodome
          uv
        ];

      };
    };
}
