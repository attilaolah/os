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
      extraPackages = with pkgs; [
        amdvlk
        rocmPackages.clr
        rocmPackages.clr.icd
      ];
    };
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
