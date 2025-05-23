{
  lib,
  pkgs,
  username,
  ...
}: let
  domain = "localhost";
  sanIps = ["::1" "127.0.4.43" "127.0.0.1"];
  sanDns = [domain "home"];

  certs =
    pkgs.runCommand "mkcert"
    {nativeBuildInputs = [pkgs.step-cli];}
    ''
      mkdir -p $out
      cd $out

      # Root CA
      step certificate create "LOCAL CA" ca.crt ca.key \
        --profile=root-ca --no-password --insecure

      # Server certificate & key
      echo step certificate create "${domain}" tls.crt tls.key \
        --san=${lib.concatStringsSep " --san=" (sanDns ++ sanIps)} \
        --ca=ca.crt --ca-key=ca.key --expires=10y \
        --kty=EC --curve=P-256 --no-password --insecure
      step certificate create "${domain}" tls.crt tls.key \
        --san=${lib.concatStringsSep " --san=" (sanDns ++ sanIps)} \
        --ca=ca.crt --ca-key=ca.key --not-after=${toString (10 * 365 * 24)}h \
        --kty=EC --curve=P-256 --no-password --insecure
    '';
in {
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
    ./services/hypridle.nix
    ./services/nginx.nix
    ./services/openssh.nix
    ./services/pipewire.nix
    ./services/printing.nix
    ./services/rpcbind.nix
    ./services/tailscale.nix
    ./services/xserver.nix
    ./systemd.nix
    ./users.nix
    ./virtualisation/docker.nix
    ./virtualisation/podman.nix
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
    pki.certificates = [(builtins.readFile "${certs}/ca.crt")];
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

  environment = {
    etc = {
      "tls/tls.crt".source = "${certs}/tls.crt";
      "tls/tls.key".source = "${certs}/tls.key";
      "tls/ca.crt".source = "${certs}/ca.crt";
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
}
