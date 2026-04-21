{pkgs, ...}: {
  programs.gpg = {
    enable = true;
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [
      {
        source = pkgs.fetchurl {
          url = "https://github.com/attilaolah.gpg";
          hash = "sha256-ibRC4EuKw6dZByY/kgi0RdeGvQybLJfdHWZzr1TabfQ=";
        };
        trust = "ultimate";
      }
      {
        source = pkgs.fetchurl {
          url = "https://github.com/web-flow.gpg";
          hash = "sha256-bor2h/YM8/QDFRyPsbJuleb55CTKYMyPN4e9RGaj74Q=";
        };
        trust = "full";
      }
    ];
    settings.default-key = "07E6C0643FD142C3";
  };
}
