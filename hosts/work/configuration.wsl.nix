{
  lib,
  pkgs,
  ...
}: let
  domain = "localhost";
  sanIps = ["::1" "127.0.4.43" "127.0.0.1"];
  sanDns = [domain "wsl.localhost"];

  pki = {
    ca = "${certs}/ca.crt";
    crt = "${certs}/tls.crt";
    key = "${certs}/tls.key";
  };

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
      step certificate create "${domain}" tls.crt tls.key \
        --san=${lib.concatStringsSep " --san=" (sanDns ++ sanIps)} \
        --ca=ca.crt --ca-key=ca.key --expires=10y \
        --kty=EC --curve=P-256 --no-password --insecure
      certificate create "${domain}" tls.crt tls.key \
        --san=${lib.concatStringsSep " --san=" (sanDns ++ sanIps)} \
        --ca=ca.crt --ca-key=ca.key --not-after=${toString (10 * 365 * 24)}h \
        --kty=EC --curve=P-256 --no-password --insecure
    '';
in {
  imports = [
    <nixos-wsl/modules>
  ];

  wsl = {
    enable = true;
    defaultUser = "olaa";
    interop.includePath = false;
    wslConf.interop.appendWindowsPath = false;
  };

  system.stateVersion = "24.05";

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];

    trusted-users = ["root" "olaa"];

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

  programs = {
    fish.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  virtualisation.docker.enable = true;

  users = {
    defaultUserShell = pkgs.fish;

    users = {
      olaa = {
        isNormalUser = true;
        description = "Attila O.,,,,attila.olah@netstal.com"; # GECOS
        group = "olaa";
        extraGroups = [
          "docker"
          "wheel" # for sudo
        ];
      };
    };

    groups.olaa = {};
  };

  security = {
    polkit.enable = true;
    sudo.execWheelOnly = true;
    pki.certificates = [(builtins.readFile pki.ca)];
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    package = pkgs.nginxQuic;

    virtualHosts."localhost" = {
      serverAliases = sanIps ++ sanDns;
      sslCertificate = pki.crt;
      sslCertificateKey = pki.key;
      forceSSL = true;
      kTLS = true;
      quic = true;

      locations."/" = {
        proxyPass = "http://[::1]:8080";
        proxyWebsockets = true;
      };
    };
  };

  environment = {
    etc = with pki; {
      "tls/ca.crt".source = ca;
      "tls/tls.crt".source = crt;
      "tls/tls.key".source = key;
    };
    systemPackages = with pkgs; [
      fish
    ];
  };
}
