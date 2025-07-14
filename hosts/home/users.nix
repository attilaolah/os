{
  config,
  pkgs,
  username,
  email,
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
        description = "Attila O.,,,,${email}"; # GECOS
        initialHashedPassword = "$6$SI1H.i.JWUuxp0fV$isfHYRqlDVGmtxPA/wmz7aTSA9Ifs7HSRcAiwxBwoCZmDOx7hgn/NlvucF33NqNZp0tABWv3HUHlZxYJSh7NH.";
        group = username;
        extraGroups = with config;
          filterGroups {
            wheel = true; # for sudo
            input = true; # for /dev/input/* access
            nfsadmin = true; # homelab direct nfs access
            scanner = hardware.sane.enable;
            lp = services.printing.enable;
            docker = virtualisation.docker.enable;
            podman = virtualisation.podman.enable;
            wireshark = programs.wireshark.enable;
          };
        openssh.authorizedKeys.keys =
          (let
            inherit (pkgs.lib.strings) splitString removeSuffix;
          in
            splitString "\n" (removeSuffix "\n" (builtins.readFile (pkgs.fetchurl {
              url = "https://github.com/attilaolah.keys";
              hash = "sha256-U1t5aTwRMlnjmiUcZcKZ1Hu6/QpZO2OWLG+4UaiRnHE=";
            }))))
          ++ [
            # Pixel 7, temporary key:
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBzKOTbqz9f7/ZNvt1RsmvCGccBJ96Sk3SGwOHDNldfG"
          ];
      };
    };

    groups = {
      ${username} = {};
      nfsadmin.gid = 2049;
    };
  };
}
