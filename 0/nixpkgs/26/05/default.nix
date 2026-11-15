{ _inputs, ... }:
import ../../release-module.nix {
  flake = _inputs."nixpkgs-26_05";
  registryName = "nixpkgs-26_05";
  overlayName = "26.05";
}
