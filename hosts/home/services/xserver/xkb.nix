{ lib, ... }:

let
  kvJoin = attrs: (lib.concatStringsSep "," (lib.mapAttrsToList (k: v: "${k}:${v}") attrs));

in {
  services.xserver.xkb = {
    layout = "us";
    variant = "dvp";
    options = (kvJoin {
      caps = "escape";
      compose = "ralt";
      keypad = "atm";
      kpdl = "semi";
      numpad = "shift3";
    });
  };
}
