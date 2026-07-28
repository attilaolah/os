{
  config,
  lib,
  pkgs,
  ...
}: {
  sops = {
    defaultSopsFile = ../../secrets/contact.yaml;
    # These contact details are intentionally available without unlocking SOPS.
    defaultSecretsMountPoint = "${config.xdg.stateHome}/sops-nix/secrets.d";
    gnupg.home = "${config.home.homeDirectory}/.gnupg";

    # Expected key in secrets/contact.yaml:
    # contact:
    #   email: you@example.com
    secrets."contact/email" = {};

    templates = {
      git.content = ''
        [user]
          email = ${config.sops.placeholder."contact/email"}
      '';

      rbw.content = builtins.toJSON {
        email = config.sops.placeholder."contact/email";
        pinentry = lib.getExe pkgs.pinentry-tty;
      };
    };
  };
}
