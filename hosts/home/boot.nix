{ config, ... }:

{
  boot = {
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "ip=192.168.0.2::192.168.0.1:255.255.255.0:home::none" ];
    blacklistedKernelModules = [ "radeon" ];
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        enableCryptodisk = true;
        efiSupport = true;

        # Save EFI binary as EFI/BOOT/BOOTX64.EFI. This is not really
        # necessary, but this way the system can boot even if NVRAM entries get
        # wiped for whatever reason: just boot from removable device as usual.
        efiInstallAsRemovable = true;

        useOSProber = false;
        extraEntries = ''
          menuentry 'UEFI Firmware Settings' { fwsetup }
          menuentry 'Power off' { halt }
          menuentry 'Reboot' { reboot }
        '';
      };
    };
    initrd = {
      kernelModules = [ "amdgpu" "r8169" ];
      availableKernelModules = [
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];
      luks.devices = {
        crypta = {
          device = "/dev/nvme0n1";  # 2T
          allowDiscards = true;
          preLVM = true;
        };
        cryptb = {
          # 2T NVMe SSD.
          device = "/dev/nvme1n1";  # 2T
          allowDiscards = true;
          preLVM = true;
        };
      };
      services.lvm.enable = true;
      # Start SSH during boot, to allow remote unlocking of LUKS volumes.
      network.ssh = {
        enable = true;
        authorizedKeys = config.users.users.ao.openssh.authorizedKeys.keys;
      };
    };
  };
}
