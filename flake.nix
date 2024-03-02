{
  description = "NixOS flakes.";

  inputs = {
    # renovate: datasource=github-releases depName=nixpkgs/nixos
    nixpkgs.url = "nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      format = "raw-efi";
      modules = [
        ./configuration.nix
      ];
    };
  };
}
