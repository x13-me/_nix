{ _inputs, ... }:
import ../release-module.nix {
  flake = _inputs."nixpkgs-26_11";
  registryName = "nixpkgs-26_11";
  overlayName = "26.11";
}
