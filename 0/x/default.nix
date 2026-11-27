{ lib, ... }:
{
  options = {
    x = {
      isGraphical = lib.mkEnableOption "a graphical environment";
      isPhysical = lib.mkEnableOption "a physically used host";
    };
  };
}
