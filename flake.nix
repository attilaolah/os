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
    flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
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
          };
        };

        platform = system: builtins.elemAt (nixpkgs.lib.splitString "-" system) 1;
        platformHosts = p: (nixpkgs.lib.filterAttrs (_: value: (platform value.system) == p) hosts);
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
              building = "Dornhaus 8";
              email = "attila@dorn.haus";
              phone = "+41 79 247 25 10";
            };
            platform = platform system;
          };

        mkConfigs = generator: os: platform:
          nixpkgs.lib.mapAttrs' (
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
        # home-manager switch --flake .#home (or --flake .#nb1609)
        homeConfigurations = nixpkgs.lib.mapAttrs (name: config:
          home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs {
              inherit (config) system;
              config.allowUnfree = true;
            };
            modules = [./home-manager/home.nix];
            extraSpecialArgs = specialArgs config;
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
          ];
        };
      };
    });
}
