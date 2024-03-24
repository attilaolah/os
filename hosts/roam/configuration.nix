{pkgs, ...}: {
  imports = [
    # Inherit home config:
    ../home/services/openssh.nix
    ../home/users.nix
    ../home/virtualisation/docker.nix
    ../home/virtualisation/podman.nix
    # VM customisations:
    ./networking.nix
    ./programs.nix
  ];
  system.stateVersion = "23.11";
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  security = {
    polkit.enable = true;
    sudo.execWheelOnly = true;
  };

  nix = {
    package = pkgs.nixUnstable;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
    slurp
  ];
}
