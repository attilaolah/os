{
  config,
  lib,
  pkgs,
  user,
  ...
}: let
  shareUser = "smbuser";
  shareGroup = "smbusers";
in {
  services.samba = {
    enable = true;
    package = pkgs.samba;

    # Global settings using the modern settings format
    settings = {
      global = {
        # Security
        security = "user";

        # Network settings - only listen on local network
        interfaces = "192.168.0.0/24";
        "bind interfaces only" = "yes";

        # Logging
        "log level" = 1;

        # Modern SMB protocol
        "server min protocol" = "SMB2";
        "server max protocol" = "SMB3";

        # Security hardening
        "ntlm auth" = "yes";
        "lanman auth" = "no";
        "client lanman auth" = "no";
        "client plaintext auth" = "no";

        # Disable printer sharing
        "load printers" = "no";
        printing = "bsd";
        "printcap name" = "/dev/null";

        # Performance
        "socket options" = "TCP_NODELAY IPTOS_LOWDELAY";
        "read raw" = "yes";
        "write raw" = "yes";
        "use sendfile" = "yes";
      };

      # Define the share
      "${user.username}" = {
        path = "/home/${user.username}/share";
        comment = "${user.username}'s shared folder";
        browseable = "yes";
        "read only" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "valid users" = shareUser;
        "writable" = "yes";
        "guest ok" = "no";
        "force user" = user.username;
        "force group" = user.username;
      };
    };
  };

  # WSD for network discovery (Windows "Network" tab)
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # Create the Samba user group
  users.groups.${shareGroup} = {};

  # Create a dedicated Samba user for remote access
  users.users.${shareUser} = {
    isNormalUser = false;
    isSystemUser = true;
    group = shareGroup;
    description = "Samba share user";
    shell = "/bin/false";
    createHome = false;
  };

  # Create the share directory
  systemd.tmpfiles.rules = [
    "d /home/${user.username}/share 0755 ${user.username} ${user.username} -"
  ];

  # Firewall: allow Samba ports
  networking.firewall.allowedTCPPorts = [139 445];
  networking.firewall.allowedUDPPorts = [137 138];

  # Set Samba password for the share user (run after rebuild):
  # sudo smbpasswd -a smbuser
}
