{
  config,
  pkgs,
  username,
  ...
}: let
  filterGroups = attrs: builtins.attrNames (pkgs.lib.filterAttrs (_: v: v) attrs);
in {
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.fish;

    # Generate a password using:
    # nix-shell --run "mkpasswd -m SHA-512 -s" -p mkpasswd
    users = {
      root.initialHashedPassword = "$6$chB8XnZbQno6p5Zp$IE6xp/WGQYYwZGgAkQE9juhofD./R2ITPryZftBellWbeRKUtGBjBGOER6g9Qym.oDiMpkPc7OFOE4fxAV.fd/";

      "${username}" = {
        isNormalUser = true;
        description = "Attila O.,,,,attila@dorn.haus"; # GECOS
        initialHashedPassword = "$6$SI1H.i.JWUuxp0fV$isfHYRqlDVGmtxPA/wmz7aTSA9Ifs7HSRcAiwxBwoCZmDOx7hgn/NlvucF33NqNZp0tABWv3HUHlZxYJSh7NH.";
        group = username;
        extraGroups = with config;
          filterGroups {
            input = true; # for /dev/input/* access
            wheel = true; # for sudo
            scanner = hardware.sane.enable;
            lp = services.printing.enable;
            docker = virtualisation.docker.enable;
            podman = virtualisation.podman.enable;
            vboxusers = virtualisation.virtualbox.host.enable;
            wireshark = programs.wireshark.enable;
          };
        openssh.authorizedKeys.keys = [
          pkgs.fetchurl
          {
            url = "https://github.com/attilaolah.keys";
            hash = pkgs.lib.fakeHash;
          }
          # Pixel 7, temporary key
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfD87bfG50ZUVNMtf1EAMcNDne5H+qELuLZL6919lyd"
        ];
      };
    };

    groups.${username} = {};
  };
}
