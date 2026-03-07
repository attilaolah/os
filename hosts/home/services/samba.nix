{user, ...}: let
  shareUser = "smbuser";
  shareGroup = "smbusers";
  home = "/home/${user.username}";
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
  #     - layer  # writeable layer for sidecars
  #     - work   # overlayfs work directory
  # - share:     # SMB share
  #   - photos   # merged view: raw photos + sidecars
  systemd.tmpfiles.rules = map (subdir: "d ${home}/${subdir} 0755 ${user.username} ${user.username} -") [
    "photos/raw"
    "photos/overlay/layer"
    "photos/overlay/work"
    "share/photos"
  ];

  # OverlayFS: merge raw + layer into share/photos
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
