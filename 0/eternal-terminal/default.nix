{
  _inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./service.nix ];
  services = {
    eternal-terminal = {
      enable = lib.mkDefault true;
    };
  };
}
