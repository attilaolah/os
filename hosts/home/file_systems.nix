{ config, ... }:

{
  fileSystems = {
    "/" = {
      # LVM volume over crypta + cryptb.
      device = "/dev/nixvg/root";
      fsType = "ext4";
      options = [ "lazytime" ];
    };
    "${config.boot.loader.efi.efiSysMountPoint}" = {
      # ESP @ USB 3.2 drive, boot partition.
      device = "/dev/disk/by-uuid/12CE-A600";
      fsType = "vfat";
    };
    "/home/ao/backup" = {
      device = "/dev/mapper/cryptusb";
      fsType = "ext4";
      options = [ "noatime" "nodiratime" ];
    };
  };
}
