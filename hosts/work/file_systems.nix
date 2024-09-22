{config, ...}: {
  fileSystems = {
    "/" = {
      # LVM volume over cryptusb.
      device = "/dev/nixvg/root";
      fsType = "ext4";
      options = ["noatime" "nodiratime"];
    };
    "${config.boot.loader.efi.efiSysMountPoint}" = {
      # ESP @ USB 3.2 drive, boot partition.
      device = "/dev/disk/by-uuid/12CE-A600";
      fsType = "vfat";
    };
  };
}
