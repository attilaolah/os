{
  programs = {
    neovim = import ./neovim.nix;

    # Terminal:
    fish.enable = true;

    # Window manager:
    hyprland = {
      enable = true;
    };
    hyprlock.enable = true;

    # Misc. utilities:
    wireshark.enable = true;
  };
}
