{pkgs, ...}: {
  imports = [
    ../home/fonts.nix
    ../home/programs.nix
    ../home/services/autofs.nix
    ../home/services/blueman.nix
    ../home/services/davfs2.nix
    ../home/services/dbus.nix
    ../home/services/greetd.nix
    ../home/services/gvfs.nix
    ../home/services/pipewire.nix
    ../home/services/tailscale.nix
    ../home/services/teleport.nix
    ../home/services/xserver/xkb.nix
    ../home/users.nix
    ../home/virtualisation/docker.nix
    ../home/virtualisation/podman.nix
    ./boot.nix
    ./file_systems.nix
    ./hardware.nix
    ./networking.nix
    ./systemd.nix
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
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  sound.enable = true;

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    slurp
    xdg-utils
  ];
}
