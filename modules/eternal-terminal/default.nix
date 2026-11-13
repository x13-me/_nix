{ lib, ... }:
{
  imports = [ ./service.nix ];
  services = {
    eternal-terminal = {
      enable = lib.mkDefault true;
    };
  };
}
