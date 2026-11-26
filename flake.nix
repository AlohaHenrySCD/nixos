{
  description = "AlohaHenry's Asahi-NixOS & macOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    steam-asahi = {
      url = "github:sm-idk/steam-asahi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Update these pins deliberately; see hosts/asahi/kernel.nix.
    nixpkgs-kernel.url = "github:nixos/nixpkgs/f9a75f41be3a74eab55d3a7679d34ad6cc0da977";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon/5de1c7ae865d645a3ebcc7d2ba5a13b9b50c0c16";
      inputs.nixpkgs.follows = "nixpkgs-kernel";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kde-everforest = {
      url = "github:Serge2702/KDE-Everforest";
      flake = false;
    };
    nirinit = {
      url = "github:amaanq/nirinit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
    # frpc.url = "https://nya.globalslb.net/natfrp/client/frpc/0.51.0-sakura-14/frpc_linux_arm64";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      plasma-manager,
      # frpc,
      ...
    }:
    let
      constants = import ./constants.nix;
      sharedTheme =
        { pkgs, ... }:
        let
          theme = import ./theme.nix { inherit pkgs; };
        in
        {
          nixpkgs.overlays = [ self.overlays.default ];
          _module.args.theme = theme;
          home-manager.extraSpecialArgs.theme = theme;
        };
      mkNixos =
        {
          system,
          hostModules,
          hostHomeModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs constants;
          };

          modules = [
            hostModules
            sharedTheme
            home-manager.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                sharedModules = [
                  plasma-manager.homeModules.plasma-manager
                  inputs.sops-nix.homeManagerModules.sops
                ];

                extraSpecialArgs = {
                  inherit inputs constants;
                };
                users.${constants.username}.imports = [
                  ./home/home.nix
                  ./home/linux.nix
                ]
                ++ hostHomeModules;
              };
            }
          ];
        };
    in
    {
      overlays.default = import ./overlays;

      packages = nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" ] (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfreePredicate = pkg: nixpkgs.lib.getName pkg == "jetbrains-sans";
          };
        in
        self.overlays.default (pkgs.extend self.overlays.default) pkgs
      );

      nixosConfigurations = {
        asahi = mkNixos {
          system = "aarch64-linux";
          hostModules = ./hosts/asahi;
          hostHomeModules = [ ./hosts/asahi/home.nix ];
        };

        asahi-debug = mkNixos {
          system = "aarch64-linux";
          hostModules = ./hosts/asahi-debug;
          hostHomeModules = [ ./hosts/asahi/home.nix ];
        };

        x86_64 = mkNixos {
          system = "x86_64-linux";
          hostModules = ./hosts/x86_64;
        };
      };

      # macbook here is host name NEED MODIFY
      darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs constants;
        };
        modules = [
          sharedTheme
          ./darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
              ];
              extraSpecialArgs = {
                inherit inputs constants;
              };
              users.${constants.username} = {
                imports = [
                  ./home/home.nix
                  ./home/darwin.nix
                ];
              };
            };
          }
        ];
      };

      formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixfmt-rfc-style;
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;
    };
}
