{user, ...}: let
  home = "/home/${user.username}";
  # On a fresh machine, a new passdb entry must be created with `smbpasswd -a smbuser`.
  shareUser = "smbuser";
  shareGroup = "smbusers";
in {
  services = {
    samba = {
      enable = true;

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
          "vfs objects" = "acl_xattr";

          printing = "bsd";
          "load printers" = "no";
          "printcap name" = "/dev/null";
        };

        # Photos share with overlayfs backend.
        # Changes are captured by OverlayFS and stored in $HOME/photos/overlay.
        photos =
          {
            path = "${home}/share/photos";
            comment = "Raw photos (read-only) + sidecars (writable)";
            browseable = "yes";
            "read only" = "yes";
            "guest ok" = "no";
            "valid users" = shareUser;
            "write list" = shareUser;

            "vfs objects" = "acl_xattr";
            "inherit permissions" = "yes";
            "store dos attributes" = "yes";
            "acl allow execute always" = "no";
          }
          // (with user; {
            "force user" = username;
            "force group" = username;
          });
      };
    };

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };

  users = {
    users.${shareUser} = {
      isNormalUser = false;
      isSystemUser = true;
      group = shareGroup;
      description = "Samba share user";
      shell = "/bin/false";
      createHome = false;
    };
    groups.${shareGroup} = {};
  };

  # $HOME:
  # - photos:
  #   - raw      # source raw files
  #   - overlay:
  #     - layer  # writeable layer
  #     - work   # overlayfs work directory
  # - share:     # SMB share
  #   - photos   # merged view: raw photos + edits & sidecars
  systemd.tmpfiles.rules = map (subdir: "d ${home}/${subdir} 0755 ${user.username} ${user.username} -") [
    "photos/raw"
    "photos/overlay/layer"
    "photos/overlay/work"
    "share/photos"
  ];

  # OverlayFS: merge raw + layer into share/photos.
  fileSystems."${home}/share/photos" = let
    src = "${home}/photos";
    overlay = "${src}/overlay";
  in {
    device = "overlay";
    fsType = "overlay";
    options = [
      "lowerdir=${src}/raw"
      "upperdir=${overlay}/layer"
      "workdir=${overlay}/work"
    ];
    depends = [
      "${src}/raw"
      "${overlay}/layer"
      "${overlay}/work"
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [139 445];
    allowedUDPPorts = [137 138];
  };
}
