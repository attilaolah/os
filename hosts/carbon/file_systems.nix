{config, ...}: {
  fileSystems = {
    "/" = {
      # Encrypted root.
      device = "/dev/crypt";
      fsType = "ext4";
      options = ["lazytime"];
    };
    "${config.boot.loader.efi.efiSysMountPoint}" = {
      # ESP @ USB 3.2 drive, boot partition.
      device = "/dev/disk/by-uuid/0000-0000";
      fsType = "vfat";
    };
  };
}
