{
  imports = [
    ./shell_abbrs.nix
    ./functions.nix
    ./interactive_shell_init.nix
  ];

  programs.fish.enable = true;
}
