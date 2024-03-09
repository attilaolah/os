{
  description = "NixOS flakes for attilaolah's personal computers.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
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
    home-manager,
    hyprland,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.home = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/home/configuration.nix
        (import ./hosts/home/overlays.nix)
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ao = import ./home-manager/home.nix;
        }
      ];
      specialArgs = {inherit inputs;};
    };

    devShells.${system}.default = let
      pkgs = import nixpkgs {inherit system;};
    in
      pkgs.mkShell {
        buildInputs = with pkgs; [
          alejandra
          go-task
          nvd
          sops
        ];
      };
  };
}
