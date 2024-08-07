{
  config,
  pkgs,
  ...
}: {
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.fish;

    # Generate a password using:
    # nix-shell --run "mkpasswd -m SHA-512 -s" -p mkpasswd
    users = {
      root.initialHashedPassword = "$6$chB8XnZbQno6p5Zp$IE6xp/WGQYYwZGgAkQE9juhofD./R2ITPryZftBellWbeRKUtGBjBGOER6g9Qym.oDiMpkPc7OFOE4fxAV.fd/";

      ao = {
        isNormalUser = true;
        description = "Attila O.,,,"; # GECOS
        initialHashedPassword = "$6$SI1H.i.JWUuxp0fV$isfHYRqlDVGmtxPA/wmz7aTSA9Ifs7HSRcAiwxBwoCZmDOx7hgn/NlvucF33NqNZp0tABWv3HUHlZxYJSh7NH.";
        group = "ao";
        extraGroups =
          [
            "input" # for /dev/input/* access
            "wheel" # for sudo
          ]
          ++ (
            if config.virtualisation.docker.enable
            then ["docker"] # non-rootless
            else []
          )
          ++ (
            if config.virtualisation.podman.enable
            then ["podman"] # non-rootless
            else []
          )
          ++ (
            if config.virtualisation.virtualbox.host.enable
            then ["vboxusers"]
            else []
          )
          ++ (
            if config.programs.wireshark.enable
            then ["wireshark"]
            else []
          );
        openssh.authorizedKeys.keys = [
          # https://github.com/attilaolah.keys
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIiR17IcWh8l3OxxKSt+ODrUMLU98ZoJ+XvcR17iX9/P"
          # Pixel 7, temporary key
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfD87bfG50ZUVNMtf1EAMcNDne5H+qELuLZL6919lyd"
        ];
      };
    };

    groups.ao = {};
  };
}
