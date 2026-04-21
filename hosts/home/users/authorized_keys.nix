{user, ...}: {
  users.users."${user.username}".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIiR17IcWh8l3OxxKSt+ODrUMLU98ZoJ+XvcR17iX9/P" # Workstation
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP0Y/37XG4iBs4hHLI88dQQJhtVVal69GRF7HpHT+60J" # Work laptop
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCK3wit0j7rkD4q7DTAij1Swsk6zzCiJZyH6hthB+7Hou49XkEPbt3Obs6541x7LLD4v5XDo0CSm5QGSr2GgqJI=" # MacOS (Secretive)
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBC+mtV6yrvijOAmvsstRCYsUSbc8ZI3Np7qY2rWuACNaAnLSRhu5qbL/1EzZgcRFbMKaqRYLy8Tq56PDjck2MTo=" # Android (Terminus)
  ];
}
