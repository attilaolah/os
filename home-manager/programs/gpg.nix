{
  programs.gpg = {
    enable = true;
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [
      {
        source = ./gpg.asc;
        trust = "ultimate";
      }
      {
        source = builtins.fetchurl {
          url = "https://github.com/web-flow.gpg";
          sha256 = "sha256:117gldk49gc76y7wqq6a4kjgkrlmdsrb33qw2l1z9wqcys3zd2kf";
        };
        trust = "full";
      }
    ];
    settings.default-key = "07E6C0643FD142C3";
  };
}
