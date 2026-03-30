{
  lib,
  pkgs,
  user,
  ...
}: let
  domain = "localhost";
  sanIps = ["::1" "127.0.4.43" "127.0.0.1"];
  sanDns = [domain "home"];

  # Generate certificates using NixOS built-in function
  # Public certificates stored in Nix store (read-only, acceptable)
  certs = pkgs.certificates.generateCertificate {
    subjectKey = pkgs.lib.fileContents ./tls.key;
    subjectAltNames = {
      ips = sanIps;
      dns = sanDns;
    };
    validFrom = "now";
    validUntil = "10 years";
  };

  caCrt = pkgs.writeText "ca.crt" certs.ca.crt;
  tlsCrt = pkgs.writeText "tls.crt" certs.crt;

  # Private key must NOT be stored in Nix store (world-readable)
  # Generate it at activation time with secure permissions (0600)
in {
  imports = [
    ./boot.nix
    ./file_systems.nix
    ./fonts.nix
    ./hardware.nix
    ./networking.nix
    ./programs
    ./services
    ./systemd.nix
    ./users.nix
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
  };

  console = {
    earlySetup = true;
    useXkbConfig = true; # use xkb.options
  };

  security = {
    polkit.enable = true;
    sudo.execWheelOnly = true;
    pki.certificates = [caCrt];
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-wlr
    ];
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];

    trusted-users = [user.username];
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

  environment = {
    etc = {
      "tls/tls.crt".source = tlsCrt;
      "tls/ca.crt".source = caCrt;
    };
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

  # Activation script to generate TLS private key with proper permissions
  system.activationScripts.generateTlsKey = ''
    # Generate TLS private key with secure permissions (0600)
    install -D -m 0600 /dev/null /etc/tls/tls.key
    openssl genpkey -algorithm ED25519 -out /etc/tls/tls.key 2>/dev/null
  '';
}
