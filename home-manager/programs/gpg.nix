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
    ];
    settings.default-key = "07E6C0643FD142C3";
  };
}
