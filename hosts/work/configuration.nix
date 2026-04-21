{
  self,
  pkgs,
  system,
  user,
  ...
}: {
  imports = [
    ../home/nix.nix
    ../home/programs/fish.nix
    ./homebrew.nix
  ];

  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    # $ darwin-rebuild changelog
    stateVersion = 6;
  };

  users.users."${user.username}".home = "/Users/${user.username}";

  nixpkgs = {
    hostPlatform = system;
    config.allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    secretive
  ];
}
