{ inputs, ... }:
import ../release-module.nix {
  flake = inputs."nixpkgs-26.11";
  registryName = "nixpkgs-26.11";
  overlayName = "26.11";
}
