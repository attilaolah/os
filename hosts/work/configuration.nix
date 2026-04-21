{
  self,
  pkgs,
  system,
  ...
}: {
  imports = [
    ../home/nix.nix
    ../home/programs/fish.nix
  ];

  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    # $ darwin-rebuild changelog
    stateVersion = 6;
  };

  nixpkgs = {
    hostPlatform = system;
    config.allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    secretive
  ];
}
