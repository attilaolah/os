{
  boot = {
    plymouth.enable = true;
    kernelModules = ["kvm-intel"];
    kernelParams = ["copytoram" "quiet"];
    blacklistedKernelModules = ["radeon"];
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
      kernelModules = ["amdgpu"];
      availableKernelModules = [
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];
      luks.devices = let
        luksDev = ctrl: {
          device = "/dev/nvme${toString ctrl}n1"; # 2T
          allowDiscards = true;
          preLVM = true;
        };
      in {
        crypta = luksDev 0; # 2T
        cryptb = luksDev 1; # 2T
      };
      services.lvm.enable = true;
    };
  };
}
