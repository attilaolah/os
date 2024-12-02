{
  description = "NixOS flakes for attilaolah's personal computers.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprlock,
    ...
  } @ inputs: let
    pkgs = import nixpkgs {inherit system;};
    system = "x86_64-linux";
    useGlobalPkgs = true;
    useUserPackages = true;
    username = "ao";
    email = "attila@dorn.haus";
  in {
    nixosConfigurations.home = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/home/configuration.nix
        (import ./hosts/home/overlays.nix)
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            inherit useGlobalPkgs useUserPackages;
            backupFileExtension = "bkp";
            extraSpecialArgs =
              inputs
              // {
                inherit system username email;
                desktop = true;
              };
            users.${username} = import ./home-manager/home.nix;
          };
        }
      ];
      specialArgs = {inherit inputs username email;};
    };

    # For applying local settings with:
    # home-manager switch --flake .#wsl
    homeConfigurations.wsl = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [./home-manager/home.nix];
      extraSpecialArgs = {
        inherit email;
        username = "olaa";
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
