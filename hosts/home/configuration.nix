{pkgs, ...}: {
  imports = [
    ./boot.nix
    ./file_systems.nix
    ./fonts.nix
    ./hardware.nix
    ./networking.nix
    ./programs.nix
    ./services/autofs.nix
    ./services/blueman.nix
    ./services/davfs2.nix
    ./services/dbus.nix
    ./services/grafana.nix
    ./services/greetd.nix
    ./services/loki.nix
    ./services/nginx.nix
    ./services/openssh.nix
    ./services/pipewire.nix
    ./services/prometheus.nix
    ./services/promtail.nix
    ./services/tailscale.nix
    ./services/xserver/xkb.nix
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
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  sound.enable = true;

  nix = {
    package = pkgs.nixUnstable;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    slurp
    xdg-utils
  ];
}
