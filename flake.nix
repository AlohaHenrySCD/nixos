{
  description = "AlohaHenry's Asahi-NixOS & macOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # Keep the kernel toolchain independent of routine system package updates.
    # nixpkgs-kernel.url = "github:nixos/nixpkgs/8ce4ef6cb6f871616146b9fe26d2a5ae594e94fe";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nirimod = {
      url = "github:srinivasr/nirimod";
    };
    nixos-apple-silicon = {
      # Update this and nixpkgs-kernel only when intentionally rebuilding the kernel.
      # url = "github:tpwrules/nixos-apple-silicon/fb602d1f8c6d83dd652fecc3f468328f8864f0c1";
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
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
    kde-everforest = {
      url = "github:Serge2702/KDE-Everforest";
      flake = false;
    };
    # nirinit = {
    #   url = "github:amaanq/nirinit";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # frpc.url = "https://nya.globalslb.net/natfrp/client/frpc/0.51.0-sakura-14/frpc_linux_arm64";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nirimod,
      home-manager,
      nix-darwin,
      plasma-manager,
      # nirinit,
      # frpc,
      ...
    }:
    let
      mkNixos =
        {
          system,
          hostModules,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs;
          };

          modules = [
            hostModules
            home-manager.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                sharedModules = [
                  plasma-manager.homeModules.plasma-manager
                ];

                extraSpecialArgs = {
                  inherit inputs;
                };
                users.alohahenry.imports = [
                  ./home/home.nix
                  ./home/linux.nix
                ];
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        asahi = mkNixos {
          system = "aarch64-linux";
          hostModules = ./hosts/asahi;
        };

        x86_64 = mkNixos {
          system = "x86_64-linux";
          hostModules = ./hosts/x86_64;
        };
      };

      # macbook here is host name NEED MODIFY
      darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
              };
              users.alohahenry = {
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
