{
  description = "NixOS flakes for attilaolah's personal computers.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-unstable,
    nixos-generators,
    home-manager,
    hyprland,
    ...
  } @ inputs: let
    pkgs = import nixpkgs {inherit system;};
    system = "x86_64-linux";
    useGlobalPkgs = true;
    useUserPackages = true;
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
            users.ao = import ./home-manager/home.nix;
            extraSpecialArgs = {desktop = true;};
          };
        }
      ];
      specialArgs = {inherit inputs;};
    };

    roam = nixos-generators.nixosGenerate {
      inherit system;
      format = "do";
      modules = [
        ./hosts/roam/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            inherit useGlobalPkgs useUserPackages;
            users.ao = import ./home-manager/home.nix;
            extraSpecialArgs = {desktop = false;};
          };
        }
      ];
      specialArgs = {inherit inputs;};
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
