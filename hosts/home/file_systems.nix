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
      # TMP; TODO: Move to 2Gi USB ESP partition.
      device = "/dev/disk/by-uuid/EC50-CA49";
      fsType = "vfat";
    };
  };
}
