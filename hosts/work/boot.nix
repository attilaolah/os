{
  boot = {
    plymouth.enable = true;
    kernelModules = ["kvm-intel"];
    kernelParams = ["copytoram" "quiet"];
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

        useOSProber = true;
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
      luks.devices.usbroot = {
        device = "/dev/disk/by-uuid/ff9bd816-1bdc-4585-8277-d6cf057cfc0a";
        preLVM = true;
      };
      services.lvm.enable = true;
    };
  };
}
