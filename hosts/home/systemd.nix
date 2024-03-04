{pkgs, ...}: {
  systemd = {
    tmpfiles.rules = [
      # AMD ROCm HIP location, as expected by some 3rd party apps.
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    # See here for explanation:
    # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how
    # https://github.com/sjcobb2022/nixos-config/blob/main/hosts/common/optional/greetd.nix
    services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      # Or else errors will spam the screen.
      StandardError = "journal";
      # Or else bootlogs will spam the screen.
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
