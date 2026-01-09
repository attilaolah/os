{
  programs = {
    neovim = import ./neovim.nix;

    # Terminal:
    fish.enable = true;

    # Window manager:
    uwsm = {
      enable = true;
      waylandCompositors.hyprland = {
        prettyName = "Hyprland";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    hyprlock.enable = true;

    # Misc. utilities:
    wireshark.enable = true;
  };
}
