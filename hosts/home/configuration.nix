{pkgs, ...}: {
  imports = [
    ./boot.nix
    ./file_systems.nix
    ./fonts.nix
    ./hardware.nix
    ./networking.nix
    ./nix.nix
    ./programs
    ./services
    ./systemd.nix
    ./users
    ./virtualisation/docker.nix
    ./virtualisation/podman.nix
  ];
  system.stateVersion = "23.11";
  time.timeZone = "Europe/Zurich";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "de_CH.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
    extraLocales = [
      "de_DE.UTF-8/UTF-8"
    ];
  };

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
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-wlr
    ];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      cudaCapabilities = ["8.6"];
    };
    overlays = [
      (_final: prev: {
        cudaPackages = prev.lib.recurseIntoAttrs prev.cudaPackages_13_2;
        suitesparse = prev.suitesparse.override {
          # SuiteSparse 5.13.0 is not compatible with the CUDA 13 stdenv, but
          # it is pulled into the desktop closure through GEGL/GIMP.
          enableCuda = false;
        };
      })
    ];
  };

  environment = {
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      NIXOS_OZONE_WL = "1"; # Wayland for Chrom{e,ium}
      QT_QPA_PLATFORM = "wayland";
    };
    systemPackages = with pkgs; [
      git
      slurp
      xdg-utils
    ];
  };
}
