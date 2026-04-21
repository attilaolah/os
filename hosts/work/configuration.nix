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

    # Required for Homebrew integration.
    primaryUser = user.username;

    defaults.NSGlobalDomain = {
      # Show the menu bar (disable auto-hide).
      _HIHideMenuBar = false;
      # Keep key-repeat behavior consistent with Hyprland defaults.
      ApplePressAndHoldEnabled = false;
      # MacOS units: 40 -> ~600ms initial delay.
      InitialKeyRepeat = 40;
      # MacOS units are discrete; 3 is a closer default-feel match for 25/s.
      KeyRepeat = 3;
    };
  };

  users.users."${user.username}".home = "/Users/${user.username}";

  nixpkgs = {
    hostPlatform = system;
    config.allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    karabiner-elements
    secretive
  ];
}
