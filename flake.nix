{
  inputs = {
#    nixpkgs.url = "github:NixOS/nixpkgs/273796ebd7699e8cd8c07651372f1042ae7cd596";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          kanata = pkgs.callPackage ./kanata {};
        in
        rec {
          packages.default = packages.kanata;

          packages.kanata = kanata;
        }
      );
}
