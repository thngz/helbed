{
  inputs = {
    # nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/ros1-25.05";
    nix-ros-overlay.url = "github:thngz/nix-ros-overlay/ros1-25.05";
    # nix-ros-overlay.url = "path:/home/gkiviv/projects/ros/nix-ros-overlay/ros1-25.05";
    # nix-ros-overlay.url = "git+file:///home/gkiviv/projects/ros/nix-ros-overlay?ref=ros1-25.05";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs"; # IMPORTANT!!!
  };
  outputs = { self, nix-ros-overlay, nixpkgs }:
    nix-ros-overlay.inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            nix-ros-overlay.overlays.default
            # (final: prev: {
            #   # protobuf_23 = prev.protobuf_25; # alias removed version
            #   # protobuf = prev.protobuf_25;
            #   # protobuf = prev.protobuf_24; # or protobuf_24 if 25 unavailable
            #   # boost = prev.boost186;
            #   # rosPackages = prev.rosPackages // {
            #   #   humble = prev.rosPackages.humble.overrideScope
            #   #     (rosSelf: rosSuper: {
            #   #       # gazebo = final.gazebo_11;
            #   #       protobuf = prev.protobuf_24;
            #   #       # gazebo-ros = rosSuper.gazebo-ros.overrideAttrs ({
            #   #       #   propagatedBuildInputs ? [], ...
            #   #       # }: {
            #   #       #   propagatedBuildInputs = propagatedBuildInputs ++ [ final.qt5.qtbase ];
            #   #       # });
            #   #     });
            #   # };
            # })
          ];
          config = {

            permittedInsecurePackages =
              [ "freeimage-3.18.0-unstable-2024-04-18" ];

          };
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.colcon
            #pkgs.qt5.qtbase
            (pkgs.python312.withPackages (ps: [ ps.transforms3d ]))
            (with pkgs.rosPackages.humble;
              buildEnv {
                paths = [
                  desktop
                  joint-state-publisher-gui
                  xacro
                  ament-cmake-python
                  python-cmake-module
                  #gazebo 
                  ament-cmake-core
                  diff-drive-controller
                  plotjuggler
                  gazebo-ros-pkgs
                  plotjuggler-ros
                  image-proc
                  tf-transformations
                  slam-toolbox
                  navigation2
                  # transforms3d
                ];
              })

            (with pkgs.rosPackages.jazzy;
              buildEnv {
                paths = [
                  gazebo

                ];
              })
            pkgs.basedpyright
            pkgs.python312Packages.black
            pkgs.python312Packages.opencv4
            pkgs.python312Packages.transforms3d
            # pkgs.python312Packages.pip
          ];
        };
      });
  nixConfig = {
    extra-substituters = [ "https://ros.cachix.org" ];
    extra-trusted-public-keys =
      [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  };
}
