{
  lib,
  pkgs,
  user,
  ...
}: let
  domain = "localhost";
  sanIps = ["::1" "127.0.4.43" "127.0.0.1"];
  sanDns = [domain "home"];

  # Generate CA cert (public) and certificate file path
  caCrt = pkgs.writeText "ca.crt" ''
    -----BEGIN CERTIFICATE-----
    MIIBkTCB+wIJAKHHCi2dKbBOMA0GCSqGSIb3DQEBCwUAMBExDzANBgNVBAMMBkxP
    Q0FMIENBMB4XDTI0MDMzMDAwMDAwMFoXDTM0MDMyOTAwMDAwMFowETEPMA0GA1UE
    AwwGTE9DQUwgQ0EwXDANBgkqhkiG9w0BAQEFAANLADBIAkEA0X0uJ5V0f3J7k4zv
    3qH7vQ6l0wXZ1bJr2h3e4f5g6h7i8j9k0l1m2n3o4p5q6r7s8t9u0v1w2x3y4z5
    AqABAgMBAAEwDQYJKoZIhvcNAQELBQADQQDJc4e6e4e4e4e4e4e4e4e4e4e4e4e4
    e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e4eQ
    -----END CERTIFICATE-----
  '';
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
    # Use certificateFiles for file paths, certificates for PEM strings
    pki.certificateFiles = [ caCrt ];
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

  # Generate TLS key and certificate together at activation time
  # This ensures the key and cert are paired and the key never enters the Nix store
  system.activationScripts.generateTlsCerts = ''
    # Generate TLS private key with secure permissions (0600)
    install -D -m 0600 /dev/null /etc/tls/tls.key

    # Generate a self-signed certificate with the same key
    openssl req -x509 -newkey ed25519 \
      -keyout /etc/tls/tls.key \
      -out /etc/tls/tls.crt \
      -days 3650 \
      -nodes \
      -subj "/CN=localhost" \
      -addext "subjectAltName=DNS:localhost,DNS:home,IP:127.0.0.1,IP:::1,IP:127.0.4.43" \
      2>/dev/null

    # Ensure key has correct permissions (openssl may not set 0600 with -nodes)
    chmod 0600 /etc/tls/tls.key
  '';
}
