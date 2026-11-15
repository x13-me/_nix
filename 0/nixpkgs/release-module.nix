{
  flake,
  registryName,
  overlayName,
}:
{
  nix = {
    registry = {
      ${registryName} = {
        inherit flake;
      };
    };
  };

  nixpkgs = {
    overlays = [
      (_final: prev: {
        ${overlayName} = import flake {
          inherit (prev.stdenv.hostPlatform) system;
          config.allowUnfree = true;
        };
      })
    ];
  };
}
