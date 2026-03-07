{
  pkgs,
  user,
  ...
}: let
  shareUser = "smbuser";
  shareGroup = "smbusers";
  home = "/home/${user.username}";
in {
  services.samba = {
    enable = true;
    package = pkgs.samba;

    settings = {
      global = {
        security = "user";
        interfaces = "192.168.0.0/24";
        "bind interfaces only" = "yes";
        "log level" = 1;
        "server min protocol" = "SMB2";
        "server max protocol" = "SMB3";
        "ntlm auth" = "yes";
        "lanman auth" = "no";
        "load printers" = "no";
        printing = "bsd";
        "printcap name" = "/dev/null";
      };

      # Read-only photos share with writable sidecars via overlayfs
      photos = {
        path = "${home}/share/photos";
        comment = "Raw photos (read-only) + sidecars (writable)";
        browseable = "yes";
        "read only" = "no";
        "valid users" = shareUser;
        "guest ok" = "no";
        "force user" = user.username;
        "force group" = user.username;
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  users.groups.${shareGroup} = {};

  users.users.${shareUser} = {
    isNormalUser = false;
    isSystemUser = true;
    group = shareGroup;
    description = "Samba share user";
    shell = "/bin/false";
    createHome = false;
  };

  # Directory structure:
  # ${home}/photos/raw/           - source raw files (your master copy)
  # ${home}/photos/overlay/layer/ - writable layer (sidecars, edits)
  # ${home}/photos/overlay/work/  - overlayfs work directory
  # ${home}/share/photos/         - merged view (exported via SMB)
  systemd.tmpfiles.rules = [
    "d ${home}/share/photos 0755 ${user.username} ${user.username} -"
    "d ${home}/photos/raw 0755 ${user.username} ${user.username} -"
    "d ${home}/photos/overlay/layer 0755 ${user.username} ${user.username} -"
    "d ${home}/photos/overlay/work 0755 ${user.username} ${user.username} -"
  ];

  # Overlayfs: merge raw + layer into share/photos
  fileSystems."${home}/share/photos" = {
    device = "overlay";
    fsType = "overlay";
    options = [
      "lowerdir=${home}/photos/raw"
      "upperdir=${home}/photos/overlay/layer"
      "workdir=${home}/photos/overlay/work"
    ];
    depends = [
      "${home}/photos/raw"
      "${home}/photos/overlay/layer"
      "${home}/photos/overlay/work"
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [139 445];
    allowedUDPPorts = [137 138];
  };
}
