{config, ...}: {
  sops = {
    defaultSopsFile = ../../secrets/contact.yaml;
    gnupg.home = "${config.home.homeDirectory}/.gnupg";

    # Expected key in secrets/contact.yaml:
    # contact:
    #   email: you@example.com
    secrets."contact/email" = {};

    templates.git.content = ''
      [user]
        email = ${config.sops.placeholder."contact/email"}
    '';
  };
}
