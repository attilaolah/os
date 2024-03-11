{
  self,
  inputs,
  homemgr,
  ...
}:
  let
    specialArgs = {inherit inputs self;};
    in
{
  flake.nixosConfigurations.home =    inputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      modules = [
        ./home
        {
          home-manager = {
            users.ao.imports = homemgr."ao@home";
            extraSpecialArgs = specialArgs;
          };
        }
      ];
    };
}
