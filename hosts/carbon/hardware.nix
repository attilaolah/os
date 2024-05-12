{
  config,
  lib,
  ...
}: {
  hardware = {
    # CPU: ???
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = true;
    opengl.enable = true;
    bluetooth.enable = true;
  };
}
