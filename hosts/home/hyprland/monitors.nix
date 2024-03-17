{lib, ...}: let
  # Monitor layout:
  # ╔═══╗         ╔═══╗
  # ║ D ║╔═══════╗║ L ║
  # ║ E ║║ S A M ║║ E ║
  # ║ L ║╚═══════╝║ N ║
  # ╚═══╝         ╚═══╝
  M1 = "Dell Inc. DELL P2720DC 81WTK01K1SFS";
  M2 = "Samsung Electric Company U32J59x HNMW200264";
  M3 = "Lenovo Group Limited P27h-20 V906V9HY";
in rec {
  "$M1" = "desc:${M1}";
  "$M2" = "desc:${M2}";
  "$M3" = "desc:${M3}";

  monitor = [
    "$M1, 2560x1440@60, 0x0,      1, transform, 3"
    "$M2, 3840x2160@60, 1440x200, 1"
    "$M3, 2560x1440@60, 5280x0,   1, transform, 1"
  ];

  workspace = [
    "1, monitor:$M1, default:true"
    "2, monitor:$M2, default:true"
    "3, monitor:$M3, default:true"
  ];

  exec-once = "hyprctl dispatch focusmonitor $M2";

  # RAW Hyprland config, for hyprland.greet.conf.
  hyprconf = lib.concatStringsSep "\n" (
    [
      "$M1 = desc:${M1}"
      "$M2 = desc:${M2}"
      "$M3 = desc:${M3}"
    ]
    ++ (map (x: "monitor = ${x}") monitor)
    ++ (map (x: "workspace = ${x}") workspace)
    ++ ["exec-once = ${exec-once}"]
  );
}
