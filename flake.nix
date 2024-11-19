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

    lix-module = {
      # https://lix.systems
      # Include the below commit directly until the next release.
      # url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1.tar.gz";
      url = "https://git.lix.systems/lix-project/nixos-module/archive/81d9ff97c93289bb1592ae702d11173724a643fa.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
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

        # https://lix.systems
        lix-module.nixosModules.default
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
