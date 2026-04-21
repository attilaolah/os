{
  homebrew = {
    enable = true;

    onActivation = {
      # Uninstall packages not present in this config.
      cleanup = "zap";
      # Do a full update & upgrade on activation.
      autoUpdate = true;
      upgrade = true;
    };

    # CLI tools:
    brews = [
      "mas" # Mac App Store CLI
    ];

    # GUI applications:
    casks = [
      "font-jetbrains-mono-nerd-font"
      "ghostty"
      "programmer-dvorak"
    ];

    # Mac App Store apps:
    # Requires Apple ID login & the 'mas' brew.
    # masApps.Xcode = 497799835;
  };
}
