{
  config,
  lib,
  pkgs,
  _inputs,
  ...
}:
{
  imports = [
    _inputs.adnauseam.nixosModules.default
  ];

  environment = {
    systemPackages = lib.mkIf config.x.isGraphical (
      lib.mkBefore [
        _inputs.helium-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
      ]
    );
  };
}
