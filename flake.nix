{
  description = "NixOS flakes for attilaolah's personal computers.";

  inputs = {
    # renovate: datasource=github-releases depName=nixpkgs/nixos
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixos-unstable, ... }@inputs: {
    nixosConfigurations = {
      home = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (import ./hosts/home/configuration.nix)
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
