{pkgs, ...}: {
  programs.gpg = {
    enable = true;
    mutableKeys = false;
    mutableTrust = false;
    # NOTE: Rotating any of these keys requires a hash update.
    # This is fine as these keys are not expected to change that often.
    publicKeys = [
      {
        source = pkgs.fetchurl {
          url = "https://github.com/attilaolah.gpg";
          hash = "sha256-uSo7GvgnEK97thekH6uio8WTbHlqI+Tg/kT1OEreNF0=";
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
