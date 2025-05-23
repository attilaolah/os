{
  programs = {
    # Terminal:
    fish.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

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

    # Misc. utilities:
    wireshark.enable = true;
  };
}
