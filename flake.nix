{
  description = "NixOS flakes for attilaolah's personal computers.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://lix.systems
    lix-module = {
      # Include PR below until a new release is tagged.
      # https://git.lix.systems/lix-project/nixos-module/pulls/34
      # url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      url = "https://git.lix.systems/lix-project/nixos-module/archive/0dda9887467c1ac338d277e358e7eb86e08d34b4.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-unstable,
    home-manager,
    hyprlock,
    lix-module,
    ...
  } @ inputs: let
    pkgs = import nixpkgs {inherit system;};
    system = "x86_64-linux";
    useGlobalPkgs = true;
    useUserPackages = true;
    username = "ao";
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
                inherit system username;
                desktop = true;
              };
            users.${username} = import ./home-manager/home.nix;
          };
        }

        # https://lix.systems
        lix-module.nixosModules.default
      ];
      specialArgs = {inherit inputs username;};
    };

    # For applying local settings with:
    # home-manager switch --flake .#wsl
    homeConfigurations.wsl = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [./home-manager/home.nix];
      extraSpecialArgs = {
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
