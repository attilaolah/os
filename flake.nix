{
  description = "NixOS flakes for attilaolah's personal computers.";

  inputs = {
    # NixOS
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Upstream devenv
    # Remove after 2.0 is merged into nixpkgs.
    devenv.url = "github:cachix/devenv";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    system = "x86_64-linux";
    useGlobalPkgs = true;
    useUserPackages = true;

    user = {
      username = "ao";
      fullname = "Attila Oláh";
      building = "Dornhaus 8";
      email = "attila@dorn.haus";
      phone = "+41 79 247 25 10";
    };
  in {
    nixosConfigurations.home = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/home/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            inherit useGlobalPkgs useUserPackages;
            backupFileExtension = "bkp";
            extraSpecialArgs =
              inputs
              // {
                inherit system user;
                desktop = true;
              };
            users.${user.username} = import ./home-manager/home.nix;
          };
        }
      ];
      specialArgs = {inherit inputs user;};
    };

    # For applying local settings with:
    # home-manager switch --flake .#home (or --flake .#headless)
    homeConfigurations = nixpkgs.lib.mapAttrs (name: extraSpecialArgs:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./home-manager/home.nix];
        inherit extraSpecialArgs;
      }) {
      home =
        inputs
        // {
          inherit system user;
          desktop = true;
        };
      headless =
        inputs
        // {
          inherit system;
          user = user // {username = "olaa";};
          desktop = false;
        };
    };

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        alejandra
        go-task
        nvd
        sops
      ];
    };
  };
}
