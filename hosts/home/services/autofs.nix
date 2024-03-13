{pkgs, ...}: {
  services.autofs = {
    enable = true;
    autoMaster = let
      config = pkgs.writeText "auto" ''
        mycloud -fstype=davfs,conf=/home/ao/.config/davfs.conf,uid=1000 :https\://webdav.mycloud.ch
      '';
    in ''
      /home/ao/mnt file:${config}
    '';
  };
}
