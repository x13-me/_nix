{ lib, ... }:
{
  options = {
    x = {
      isGraphical = lib.mkEnableOption "a graphical environment";
    };
  };
}
