{
  imports = [
    ./shell_abbrs.nix
    ./shell_aliases.nix
    ./functions.nix
    ./interactive_shell_init.nix
  ];

  programs.fish.enable = true;
}
