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
    _1password.enable = true;

    # Window manager:
    hyprland.enable = true;

    # GUI programs:
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["ao"];
    };
    wireshark.enable = true;
  };
}
