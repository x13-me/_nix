{ _inputs, ... }:
import ../release-module.nix {
  flake = _inputs.nixpkgs-unstable;
  registryName = "nixpkgs-unstable";
  overlayName = "unstable";
}
