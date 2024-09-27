{
  config,
  email,
  lib,
  ...
}: {
  programs.git = {
    enable = true;

    userName = "Attila Oláh";
    userEmail = email;
    signing = with config.programs.gpg; {
      signByDefault = enable;
      key = settings.default-key;
    };
    aliases = {
      ci = "commit";
      co = "checkout";
      l = lib.concatStringsSep " " [
        "!git log"
        "--pretty=format:\"%C(yellow)%h %Cred%ad %Cblue%al%Cgreen%d %Creset%s\""
        "--date=short"
        "--decorate"
        "--graph"
        "\"$@\""
      ];
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
