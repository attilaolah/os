{user, ...}: {
  users.users."${user.username}".openssh.authorizedKeys.keys = [
    # Workstation
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIiR17IcWh8l3OxxKSt+ODrUMLU98ZoJ+XvcR17iX9/P"
    # Secretive (MacBook)
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJjvtnPSFVm3JL2oRLk9njHRiWBiFmsdbLmJNhcG4wu9UN+OFGJTM4pJhNys4rr0i+6xC/+9GTwNRw5McYmpW8c="
    # Terminus (Android)
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBC+mtV6yrvijOAmvsstRCYsUSbc8ZI3Np7qY2rWuACNaAnLSRhu5qbL/1EzZgcRFbMKaqRYLy8Tq56PDjck2MTo="
  ];
}
