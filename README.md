This repo was created for experimenting with kanata and nix builds.
Read more why [here](https://github.com/NixOS/nixpkgs/pull/306546#issuecomment-2284484876)

Using `sw_vers` doesn't seem right to me. That's why all the forks + this.

The idea is to have feature flags that can be set when building the application.

## Flake Usage
Spawning a shell exposing kanata
```sh
nix shell github:alexandru0-dev/kanata-flake#kanata
```

Use this instead if you want that kanata is built using kext:
```sh
nix shell github:alexandru0-dev/kanata-flake#kanata-kext
```
