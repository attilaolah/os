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
        extraGroups = filterGroups {
          input = true; # for /dev/input/* access
          wheel = true; # for sudo
          scanner = config.hardware.sane.enable;
          lp = config.services.printing.enable;
          docker = config.virtualisation.docker.enable;
          podman = config.virtualisation.podman.enable;
          vboxusers = config.virtualisation.virtualbox.host.enable;
          wireshark = config.programs.wireshark.enable;
        };
        openssh.authorizedKeys.keys = [
          # https://github.com/attilaolah.keys
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIiR17IcWh8l3OxxKSt+ODrUMLU98ZoJ+XvcR17iX9/P"
          # Pixel 7, temporary key
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfD87bfG50ZUVNMtf1EAMcNDne5H+qELuLZL6919lyd"
        ];
      };
    };

    groups.${username} = {};
  };
}
