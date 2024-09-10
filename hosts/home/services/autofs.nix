{
  pkgs,
  username,
  ...
}: {
  services.autofs = {
    enable = true;
    autoMaster = let
      config = pkgs.writeText "auto" ''
        mycloud -fstype=davfs,conf=/home/${username}/.config/davfs.conf,uid=1000 :https\://webdav.mycloud.ch
      '';
    in ''
      /home/${username}/mnt file:${config}
    '';
  };
}
