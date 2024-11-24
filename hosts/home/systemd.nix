{pkgs, ...}: {
  systemd.services = {
    # Fix nixos-rebuild hanging, until this issue is resolved:
    # https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1658731959
    NetworkManager-wait-online.serviceConfig = {
      ExecStart = ["" "${pkgs.networkmanager}/bin/nm-online -q"];
    };
  };
}
