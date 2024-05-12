{
  boot = {
    plymouth.enable = true;
    kernelModules = ["kvm-intel"];
    kernelParams = ["quiet"];
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
      availableKernelModules = [
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];
      luks.devices.crypt = {
        device = "/dev/nvme0n1"; # 2T
        allowDiscards = true;
      };
    };
  };
}
