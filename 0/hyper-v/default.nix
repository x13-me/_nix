{
  lib,
  pkgs,
  ...
}:

{
  environment = {
    systemPackages = with pkgs; [
      age-plugin-fido2-hmac
      deskflow
      fido2-manage
      fido2luks
      hdparm
      icoutils
      icu
      imagemagick
      kdiskmark
      libfido2
      polkit
      # polkit_gnome
      python3
      python313Packages.websockets
      smartmontools
    ];
  };

  hardware = {
    enableAllFirmware = lib.mkDefault true;
    enableAllHardware = lib.mkDefault true;
    enableRedistributableFirmware = lib.mkDefault true;
    intel-gpu-tools = {
      enable = lib.mkDefault true;
    };
    keyboard = {
      qmk = {
        enable = lib.mkDefault true;
      };
    };
    libftdi = {
      enable = lib.mkDefault true;
    };
    uinput = {
      enable = lib.mkDefault true;
    };
    usb-modeswitch = {
      enable = lib.mkDefault true;
    };
  };

  networking = {
    useDHCP = lib.mkDefault true;
  };

  security = {
    pam = {
      u2f = {
        control = "sufficient";
        enable = lib.mkDefault true;
        settings = {
          appid = "pam://x13.me";
          authfile = "/etc/u2f-mappings";
          cue = true;
          origin = "pam://x13.me";
        };
      };
    };
  };

  virtualisation = {
    hypervGuest = {
      enable = lib.mkDefault true;
    };
  };
}
