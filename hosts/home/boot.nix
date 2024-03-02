{
  boot = {
    kernelModules = [ "kvm-intel" ];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
      };
    };
    initrd = {
      kernelModules = [ "amdgpu" ];
      availableKernelModules = [
        "ahci"
        "nvme"
        "usbhid"
        "xhci_pci"
      ];
      luks.devices = {
        crypta = {
          # 2T NVMe SSD.
          device = "/dev/disk/by-uuid/8efccfcb-8c61-4844-89c9-3dbc1a900de4";
          allowDiscards = true;
          preLVM = true;
        };
        cryptb = {
          # 2T NVMe SSD.
          device = "/dev/disk/by-uuid/a4d6ae21-1535-42d0-b5a9-c249d1db71d4";
          allowDiscards = true;
          preLVM = true;
        };
      };
      services.lvm.enable = true;
      # Start SSH during boot, to allow remote unlocking of LUKS volumes.
      network.ssh.enable = true;
    };
  };
}
