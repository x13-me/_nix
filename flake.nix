{
  description = "x13.me Nix modules flake";

  inputs = {
    "nixpkgs-26.05" = {
      url = "github:NixOS/nixpkgs/nixos-26.05";
    };
    # "nixpkgs-26.11" = {
    #   url = "github:NixOS/nixpkgs/nixos-26.11";
    # };
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs-unstable,
      ...
    }@inputs:
    let
      nixpkgs = inputs."nixpkgs-26.05";

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      modNames = [
        "eternal-terminal"
        "nixpkgs/26.05"
        # "nixpkgs/26.11"
        "nixpkgs/unstable"
      ];

      mkMod = modName: {
        imports = [ ./modules/${modName} ];
        _module.args = inputs // {
          inherit inputs;
        };
      };

      modules = nixpkgs.lib.genAttrs modNames mkMod;
    in
    {
      nixosModules = modules // {
        default = {
          imports = map (modName: ./modules/${modName}) modNames;
          _module.args = inputs // {
            inherit inputs;
          };
        };
      };

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
