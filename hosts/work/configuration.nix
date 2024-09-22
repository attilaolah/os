{
  pkgs,
  username,
  ...
}: {
  imports = [
    ../home/fonts.nix
    ../home/programs.nix
    # ../home/services/autofs.nix
    # ../home/services/avahi.nix
    # ../home/services/blueman.nix
    # ../home/services/davfs2.nix
    # ../home/services/dbus.nix
    # ../home/services/gvfs.nix
    # ../home/services/openssh.nix
    # ../home/services/pipewire.nix
    # ../home/services/printing.nix
    # ../home/services/tailscale.nix
    # ../home/services/teleport.nix
    ../home/services/xserver/xkb.nix
    ../home/users.nix
    # ../home/virtualisation/docker.nix
    # ../home/virtualisation/podman.nix
    # ../home/virtualisation/virtualbox.nix
    ./boot.nix
    ./file_systems.nix
    ./hardware.nix
  ];
  system.stateVersion = "24.05";
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    earlySetup = true;
    useXkbConfig = true; # use xkb.options
  };

  security = {
    polkit.enable = true;
    sudo.execWheelOnly = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];

    trusted-users = [username];
    extra-substituters = [
      "https://cache.lix.systems" # lix.systems
      "https://devenv.cachix.org" # devenv.sh
      "https://nixpkgs-python.cachix.org" # devenv.sh python
    ];
    trusted-public-keys = [
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    slurp
    xdg-utils
  ];
}
