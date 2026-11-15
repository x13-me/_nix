{
  config,
  lib,
  pkgs,
  _inputs,
  ...
}:
let
  enable = config.x.isGraphical;
in
{
  imports = [
    _inputs.adnauseam.nixosModules.default
  ];

  environment = {
    systemPackages = lib.mkIf enable (
      lib.mkBefore [
        _inputs.helium-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
      ]
    );
  };
}
