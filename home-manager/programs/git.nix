{
  config,
  email,
  lib,
  ...
}: {
  programs.git = {
    enable = true;

    signing = with config.programs.gpg; {
      signByDefault = enable;
      key = settings.default-key;
    };
    settings = {
      user = {
        inherit email;
        name = "Attila Oláh";
      };
      alias = let
        fmtl = lib.concatStringsSep " " [
          "%C(yellow)%h%C(reset)"
          "%C(bold cyan)%ad%C(reset)"
          "%C(blue)%aL%C(reset)"
          "%s%C(auto)%d%C(reset)"
        ];
        fmtll = lib.concatStringsSep " " [
          "%C(yellow)%h%C(reset)"
          "%C(bold cyan)%aD%C(reset)"
          "%C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n"
          "      " # pad to abbrev-commit length
          "%C(white)%s%C(reset)"
          "%C(dim white)- %an [%aL]%C(reset)"
        ];
      in {
        ci = "commit";
        co = "checkout";
        l = lib.concatStringsSep " " [
          "!git log"
          "--pretty=format:\"${fmtl}\""
          "--date=short"
          "--decorate"
          "--graph"
          "\"$@\""
        ];
        ll = lib.concatStringsSep " " [
          "!git log"
          "--format=format:\"${fmtll}\""
          "--abbrev-commit"
          "--decorate"
          "--graph"
        ];
      };

      pull.rebase = true;
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      log.mailmap = true;
      advice.skippedCherryPicks = false;
      credential.helper = "cache --timeout=${toString (60 * 60 * 8)}";
    };
  };
}
