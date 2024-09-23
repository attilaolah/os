{config, ...}: {
  programs.git = {
    enable = true;

    userName = "Attila Oláh";
    userEmail = "attila.olah@netstal.com";
    signing = with config.programs.gpg; {
      signByDefault = enable;
      key = settings.default-key;
    };
    aliases = {
      ci = "commit";
      co = "checkout";
    };
    extraConfig = {
      pull.rebase = true;
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      advice.skippedCherryPicks = false;
      credential.helper = "cache --timeout=3600";
    };
  };
}
