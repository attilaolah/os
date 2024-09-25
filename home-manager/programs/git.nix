{config, ...}: {
  programs.git = {
    enable = true;

    userName = "Attila Oláh";
    userEmail = "attila@dorn.haus";
    signing = with config.programs.gpg; {
      signByDefault = enable;
      key = settings.default-key;
    };
    aliases = {
      ci = "commit";
      co = "checkout";
      l = ''
        !log() {
          git log \
            --pretty=format:"%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s" \
            --date=short \
            --decorate \
            --graph
        }
        log
      '';
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
