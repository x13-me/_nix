{ config, lib, ... }:
let
  mappingType = lib.types.submodule {
    options = {
      keyHandle = lib.mkOption {
        type = lib.types.str;
        description = "base64 key handle of the credential";
      };
      publicKey = lib.mkOption {
        type = lib.types.str;
        description = "base64 public key of the credential";
      };
      algorithm = lib.mkOption {
        type = lib.types.str;
        default = "es256";
      };
      presence = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "require user presence (touch) per authentication";
      };
      pin = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "require PIN (user verification) per authentication";
      };
    };
  };

  renderMapping =
    name: m:
    let
      flags = lib.optional m.presence "+presence" ++ lib.optional m.pin "+pin";
    in
    "${name}:${m.keyHandle},${m.publicKey},${m.algorithm}"
    + lib.optionalString (flags != [ ]) ("," + lib.concatStringsSep "," flags);

  lines = lib.concatLists (
    lib.mapAttrsToList (
      name: user: map (renderMapping name) (user.u2f.mappings or [ ])
    ) config.users.users
  );
in
{
  options = {
    users = {
      users = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              u2f = {
                mappings = lib.mkOption {
                  type = lib.types.listOf mappingType;
                  default = [ ];
                  description = "pam-u2f credentials for this user, rendered into /etc/u2f-mappings";
                };
              };
            };
          }
        );
      };
    };
  };

  config = lib.mkIf (lines != [ ]) {
    environment = {
      etc = {
        "u2f-mappings" = {
          text = lib.concatStringsSep "\n" lines + "\n";
        };
      };
    };
  };
}
