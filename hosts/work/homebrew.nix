{
  homebrew = {
    enable = true;

    onActivation = {
      # Uninstall packages not present in this config.
      # This is intentional. All Homebrew packages must be declared below.
      cleanup = "zap";
      # Do a full update & upgrade on activation.
      # This is a convenient way to remember to upgrade these packages.
      autoUpdate = true;
      upgrade = true;
    };

    # CLI tools:
    brews = [
      "mas" # Mac App Store CLI
    ];

    # GUI applications:
    casks = [
      "alt-tab"
      "font-jetbrains-mono-nerd-font"
      "ghostty"
      "programmer-dvorak"
    ];

    # Mac App Store apps:
    # Requires Apple ID login & the 'mas' brew.
    # masApps.Xcode = 497799835;
  };
}
