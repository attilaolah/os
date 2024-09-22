{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware = {
    # CPU: 12th Gen Intel Core i7-1260P
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
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
