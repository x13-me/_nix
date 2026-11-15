{
  description = "x13.me Nix modules flake";

  inputs = {
    "nixpkgs-26_05" = {
      url = "github:NixOS/nixpkgs/nixos-26.05";
    };
    # "nixpkgs-26.11" = {
    #   url = "github:NixOS/nixpkgs/nixos-26.11";
    # };
    "nixpkgs-unstable" = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    adnauseam = {
      inputs.nixpkgs.follows = "nixpkgs-26_05";
      url = "github:x13-me/AdNauseam-nix-store";
    };
    arbel-ssh-askpass = {
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      url = "git+https://forgejo.spacetime.technology/arbel/ssh-askpass";
    };
    armbian-kernel = {
      inputs.nixpkgs.follows = "nixpkgs-26_05";
      url = "github:x13-me/armbian-kernel";
    };
    atuin = {
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      url = "github:atuinsh/atuin";
    };
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    };
    helium-nix = {
      url = "https://flakehub.com/f/x/helium-nix/*";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs-26_05";
      url = "github:nix-community/home-manager";
    };
    nh = {
      url = "github:nix-community/nh?ref=v4.5.0";
    };
    nix-post-build-hook-queue = {
      url = "github:newam/nix-post-build-hook-queue";
    };
    nixocaine = {
      inputs.nixpkgs.follows = "nixpkgs-26_05";
      url = "https://git.madhouse-project.org/iocaine/nixocaine/archive/stable.tar.gz";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    nixos-wsl = {
      url = "github:x13-me/NixOS-WSL/main";
    };
    opencode-desktop = {
      inputs.nixpkgs.follows = "nixpkgs-26_05";
      url = "github:x13-me/opencode-desktop-nix";
    };
    panafan = {
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      url = "github:x13-me/panafan?ref=main";
    };
    picoforge = {
      url = "github:librekeys/picoforge";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
    };
    zeditor = {
      url = "github:zed-industries/zed";
    };
  };

  outputs =
    {
      self,
      nixpkgs-unstable,
      ...
    }@inputs:
    let
      nixpkgs = inputs."nixpkgs-26_05";

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      modNames = [
        "eternal-terminal"
        "helium"
        "nixpkgs/26/05"
        # "nixpkgs/26/11"
        "nixpkgs/unstable"
        "x"
      ];

      mkMod = modName: {
        imports = nixpkgs.lib.optionals (modName != "x") [ ./0/x ] ++ [ ./0/${modName} ];
        _module.args = {
          _inputs = inputs;
        };
      };

      modules = nixpkgs.lib.genAttrs modNames mkMod;
    in
    {
      nixosModules = modules // {
        default = {
          imports = map (modName: ./0/${modName}) modNames;
          _module.args = {
            _inputs = inputs;
          };
        };
      };

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
