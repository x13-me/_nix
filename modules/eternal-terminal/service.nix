{
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  ...
}:
let
  cfg = config.services.eternal-terminal;

  settingsFormat = pkgs.formats.ini { };
  defaultSettings = {
    Debug = {
      logdirectory = "/var/log/eternal-terminal";
      logsize = 20971520;
      silent = 0;
      telemetry = false;
      verbose = 0;
    };
  };
  mergedSettings = lib.recursiveUpdate defaultSettings cfg.settings;
  effectiveSettings = lib.recursiveUpdate mergedSettings {
    Networking.port = cfg.port;
  };
  configFile = settingsFormat.generate "et.cfg" effectiveSettings;
in
{
  disabledModules = [ "services/networking/eternal-terminal.nix" ];

  options = {
    services = {
      eternal-terminal = {
        enable = lib.mkEnableOption "Eternal Terminal server";

        package = lib.mkOption {
          type = lib.types.package;
          default = nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.eternal-terminal;
          defaultText = lib.literalExpression "inputs.nixpkgs-unstable.legacyPackages.\${pkgs.stdenv.hostPlatform.system}.eternal-terminal";
          description = "Eternal Terminal package to use.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 2022;
          description = "TCP port for the Eternal Terminal server.";
        };

        openFirewall = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to open `port` in the firewall.";
        };

        settings = lib.mkOption {
          inherit (settingsFormat) type;
          default = { };
          example = {
            Debug.serverfifo = "/run/etserver.fifo";
            Networking.bind_ip = "0.0.0.0";
          };
          description = ''
            Extra `et.cfg` settings grouped by INI section. Merged over the
            module defaults; `port` always wins for `Networking.port`.
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # The remote `et` client runs `etterminal` on this host via ssh.
    environment.systemPackages = [ cfg.package ];

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    systemd.services."eternal-terminal" = {
      description = "Eternal Terminal";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${lib.getExe' cfg.package "etserver"} --cfgfile=${configFile} --logtostdout";
        LogsDirectory = "eternal-terminal";
        Restart = "on-failure";
        Type = "simple";
      };
    };
  };
}
