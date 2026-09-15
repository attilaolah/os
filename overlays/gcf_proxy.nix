final: prev: let
  inherit (builtins) elemAt;
  fetchFromGitHubTuple = import ./lib/fetch_from_github_tuple.nix prev;

  github-tags = ["blackwell-systems/gcf-proxy" "0.11.5"];
  hash-src = "sha256-BLBl4GtQVBcM7JOy0MKMn2ukFHWBORgpCAgrxD/Igxo=";
  hash-vendor = "sha256-qfhhmjcsNuSeDCXyHBgz4bWc0aJvlgkPATm1+T7nHJg=";

  version = elemAt github-tags 1;
  src = fetchFromGitHubTuple {
    inherit github-tags hash-src;
    rev = "v${version}";
  };
in {
  gcf-proxy = prev.buildGoModule {
    pname = "gcf-proxy";
    inherit version src;
    vendorHash = hash-vendor;
    meta.mainProgram = "gcf-proxy";
  };
}
