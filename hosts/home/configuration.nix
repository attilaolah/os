{ config, lib, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./file_systems.nix
    ./hardware.nix
    ./networking.nix
    ./programs.nix
    ./services.nix
    ./users.nix
  ];
  system.stateVersion = "23.11";
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    earlySetup = true;
    useXkbConfig = true; # use xkb.options
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

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
    package = pkgs.nixUnstable;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    neovim
  ];
}