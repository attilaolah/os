{
  imports = [
    ./fish.nix
    ./neovim.nix
  ];
  programs = {
    # Window manager:
    hyprland.enable = true;
    hyprlock.enable = true;

    # Misc. utilities:
    wireshark.enable = true;
  };
}
