{
  config,
  pkgs,
  ...
}: let
  configDir =
    if pkgs.stdenv.hostPlatform.isDarwin then "Library/Application Support" else config.xdg.configHome;
in {
  programs.rbw = {
    enable = true;
  };

  home.file."${configDir}/rbw/config.json".source =
    config.lib.file.mkOutOfStoreSymlink config.sops.templates.rbw.path;
}
