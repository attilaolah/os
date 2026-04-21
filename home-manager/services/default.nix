{
  lib,
  platform,
  ...
}: {
  imports =
    [
      ./gpg_agent.nix
    ]
    ++ lib.lists.optionals (platform == "linux") [
      ./hypridle.nix
      ./hyprpaper
      ./swaync.nix
    ];
}
