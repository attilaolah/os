{pkgs, ...}: let
  home = import ../home/programs.nix {inherit pkgs;};
in {
  programs = with home.programs; {
    inherit fish neovim nix-index _1password;
  };
}
