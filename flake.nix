{
  description = "NixOS flakes for attilaolah's personal computers.";

  inputs = {
    # Nix packages
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Nix-Darwin
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home-Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # SOPS integration
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake-Parts
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({...}: let
      inherit (nixpkgs) lib;
    in {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      imports = [
        inputs.home-manager.flakeModules.home-manager
      ];

      flake = let
        hosts = {
          home = {
            system = "x86_64-linux";
            username = "ao";
            ncores = 20;
          };
          work = {
            hostname = "nb1609";
            system = "aarch64-darwin";
            username = "olaa";
            ncores = 10;
          };
        };

        platform = system: builtins.elemAt (lib.splitString "-" system) 1;
        platformHosts = p: (lib.filterAttrs (_: value: (platform value.system) == p) hosts);
        specialArgs = {
          ncores,
          system,
          username,
          ...
        }:
          inputs
          // {
            inherit ncores system;
            user = {
              inherit username;
              fullname = "Attila Oláh";
            };
            platform = platform system;
          };

        mkConfigs = generator: os: platform:
          lib.mapAttrs' (
            name: value: {
              name = value.hostname or name;
              value = generator.lib."${os}System" {
                inherit (value) system;
                modules = [
                  ./hosts/${name}/configuration.nix
                  home-manager."${os}Modules".home-manager
                  {
                    home-manager = {
                      backupFileExtension = "bkp";
                      extraSpecialArgs = specialArgs value;
                      sharedModules = [
                        inputs."sops-nix".homeManagerModules.sops
                      ];
                      users.${value.username} = import ./home-manager/home.nix;
                      useGlobalPkgs = true;
                      useUserPackages = true;
                    };
                  }
                ];
                specialArgs = specialArgs value;
              };
            }
          ) (platformHosts platform);
      in {
        nixosConfigurations = mkConfigs nixpkgs "nixos" "linux";
        darwinConfigurations = mkConfigs nix-darwin "darwin" "darwin";

        # Expose the home-manager configurations directly.
        # This allows one to apply only the home-manager config without switching the system config by running:
        # home-manager switch --flake .#hostname (e.g. --flake .#home)
        homeConfigurations =
          lib.mapAttrs' (name: config: {
            name = config.hostName or config.hostname or name;
            value = home-manager.lib.homeManagerConfiguration {
              pkgs = import nixpkgs {
                inherit (config) system;
                config.allowUnfree = true;
              };
              modules = [
                inputs."sops-nix".homeManagerModules.sops
                ./home-manager/home.nix
              ];
              extraSpecialArgs = specialArgs config;
            };
          })
          hosts;
      };

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            alejandra
            go-task
            pkgs.home-manager
            nvd
            sops
          ];
        };
      };
    });
}
