{
  description = "bemenu";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      outputs = (flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = nixpkgs.outputs.legacyPackages.${system};
        in
        {
          packages.default = pkgs.callPackage ./default.nix { };

          devShells.default = (import nixpkgs {
            system = "x86_64-linux";
          }).mkShell {
            nativeBuildInputs = [
              pkgs.pkg-config
              pkgs.scdoc
            ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
              pkgs.wayland-scanner
            ];

            buildInputs = [
              pkgs.ncurses
              pkgs.clang-tools
            ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
              pkgs.cairo
              pkgs.fribidi
              pkgs.harfbuzz
              pkgs.libxkbcommon
              pkgs.pango
              # Wayland
              pkgs.wayland
              pkgs.wayland-protocols
              # X11
              pkgs.xorg.libX11
              pkgs.xorg.libXinerama
              pkgs.xorg.libXft
              pkgs.xorg.libXdmcp
              pkgs.xorg.libpthreadstubs
              pkgs.xorg.libxcb
            ];
          };
        }));
    in
    outputs;
}
