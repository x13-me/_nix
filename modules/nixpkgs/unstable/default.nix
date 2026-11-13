{ inputs, ... }:
import ../release-module.nix {
  flake = inputs.nixpkgs-unstable;
  registryName = "nixpkgs-unstable";
  overlayName = "unstable";
}
