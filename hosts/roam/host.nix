let
  home = import ../home/host.nix;
in rec {
  name = "roam";
  inherit (home) domain;
  fqdn = "${name}.${domain}";
}
