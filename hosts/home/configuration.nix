{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./boot.nix
    ./file_systems.nix
    ./fonts.nix
    ./hardware.nix
    ./networking.nix
    ./programs.nix
    ./services/avahi.nix
    ./services/blueman.nix
    ./services/davfs2.nix
    ./services/dbus.nix
    ./services/gvfs.nix
    ./services/openssh.nix
    ./services/pipewire.nix
    ./services/printing.nix
    ./services/tailscale.nix
    ./services/xserver.nix
    ./systemd.nix
    ./users.nix
    ./virtualisation/docker.nix
    ./virtualisation/podman.nix
    ./virtualisation/virtualbox.nix
  ];
  system.stateVersion = "23.11";
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
      "https://devenv.cachix.org" # devenv.sh
      "https://nixpkgs-python.cachix.org" # devenv.sh python
    ];
    trusted-public-keys = [
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
