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
  } @ inputs: let
    # pkgs = import nixpkgs {
    #   inherit system;
    #   config.allowUnfree = true;
    # };
    userinfo = {
      fullname = "Attila Oláh";
      building = "Dornhaus 8";
      email = "attila@dorn.haus";
      phone = "+41 79 247 25 10";
    };

    hosts = {
      home = {
        hostname = "home";
        system = "x86_64-linux";
        user.username = "ao";
        ncores = 20;
      };
      work = {
        hostname = "nb1609";
        system = "aarch64-darwin";
        user.username = "olaa";
      };
    };

    specialArgs = {
      ncores,
      system,
      user,
      ...
    }:
      inputs
      // {
        inherit ncores system;
        user = userinfo // user;
        platform = builtins.elemAt (nixpkgs.lib.splitString "-" system) 1;
      };
  in
    flake-parts.lib.mkFlake {inherit inputs;} (top @ {
      config,
      withSystem,
      moduleWithSystem,
      ...
    }: {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      imports = [
        inputs.home-manager.flakeModules.home-manager
      ];

      flake = {
        nixosConfigurations."${hosts.home.hostname}" = nixpkgs.lib.nixosSystem {
          inherit (hosts.home) system;
          modules = [
            ./hosts/home/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                backupFileExtension = "bkp";
                extraSpecialArgs = specialArgs hosts.home;
                users.${hosts.home.user.username} = import ./home-manager/home.nix;
                useGlobalPkgs = true;
                useUserPackages = true;
              };
            }
          ];
          specialArgs = specialArgs hosts.home;
        };

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
            sops
          ];
        };
      };
    });
}
#
#   {
#     nixosConfigurations."${hosts.home.hostname}" = nixpkgs.lib.nixosSystem {
#       inherit (hosts.home) system;
#       modules = [
#         ./hosts/home/configuration.nix
#         home-manager.nixosModules.home-manager
#         {
#           home-manager = {
#             inherit useGlobalPkgs useUserPackages;
#             backupFileExtension = "bkp";
#             extraSpecialArgs = specialArgs hosts.home;
#             users.${hosts.home.username} = import ./home-manager/home.nix;
#           };
#         }
#       ];
#       specialArgs = specialArgs hosts.home;
#     };
#
#     darwinConfigurations."${hosts.work.hostname}" = nix-darwin.lib.darwinSystem {
#       modules = [./work/configuration.nix];
#       specialArgs = specialArgs hosts.work;
#     };
#
#     # For applying local settings with:
#     # home-manager switch --flake .#home (or --flake .#nb1609)
#     homeConfigurations = nixpkgs.lib.mapAttrs (name: extraSpecialArgs:
#       home-manager.lib.homeManagerConfiguration {
#         inherit pkgs extraSpecialArgs;
#         modules = [./home-manager/home.nix];
#       }) {
#       # TODO: map further.
#       "${hosts.home.hostname}" = specialArgs hosts.home;
#       "${hosts.work.hostname}" = specialArgs hosts.work;
#     };
#
#     # TODO: flake-parts per system!
#     devShells."x86_64-linux".default = pkgs.mkShell {
#       buildInputs = with pkgs; [
#         alejandra
#         go-task
#         pkgs.home-manager
#         nvd
#         sops
#       ];
#     };
#   };
# }

