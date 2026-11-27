{ config, lib, ... }:
{
  programs = {
    yubikey-touch-detector = {
      enable = lib.mkDefault config.x.isGraphical;
    };
  };
}
