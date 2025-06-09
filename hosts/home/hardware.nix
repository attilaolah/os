{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware = {
    # CPU: Intel Xeon E5-2666 v3
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      open = false;
      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    nvidia-container-toolkit.enable = true;

    bluetooth.enable = true;

    sane = {
      enable = true;
      extraBackends = with pkgs; [
        hplipWithPlugin
      ];
      disabledDefaultBackends = ["escl"];
    };
  };
}
