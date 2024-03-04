{
  programs.git = {
    enable = true;

    userName = "Attila Oláh";
    userEmail = "attilaolah@gmail.com";
    signing = {
      signByDefault = true;
      key = "07E6C0643FD142C3";
    };
    aliases = {
      ci = "commit";
      co = "checkout";
    };
    extraConfig = {
      pull = {rebase = true;};
      push = {autoSetupRemote = true;};
      init = {defaultBranch = "main";};
    };
  };
}
