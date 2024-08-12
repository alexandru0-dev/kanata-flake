{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [
            (import ./overlay.nix)
          ];
          pkgs = import nixpkgs {
            inherit system overlays;
          };
        in
        with pkgs;
        {
          packages.default = packages.kanata;

          packages.kanata = pkgs.kanata;
          packages.kanata-kext = pkgs.kanata-kext;
        }
      );
}
