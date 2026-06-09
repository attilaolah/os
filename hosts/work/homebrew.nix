{
  homebrew = {
    enable = true;

    onActivation = {
      # All Homebrew packages must be declared below.
      cleanup = "check";
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
      "karabiner-elements"
      "programmer-dvorak"
      "secretive"
      "tigervnc"
    ];

    # Mac App Store apps:
    # Requires Apple ID login & the 'mas' brew.
    # masApps.Xcode = 497799835;
  };
}
