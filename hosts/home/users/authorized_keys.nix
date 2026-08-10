{user, ...}: {
  users.users."${user.username}".openssh.authorizedKeys.keys = let
    ssh-ed25519 = prefix "ssh-ed25519";
    ecdsa-sha2-nistp256 = prefix "ecdsa-sha2-nistp256";
    prefix = alg: keys: map (key: "${alg} ${key}") keys;
  in
    (ecdsa-sha2-nistp256 [
      # Secretive
      "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJjvtnPSFVm3JL2oRLk9njHRiWBiFmsdbLmJNhcG4wu9UN+OFGJTM4pJhNys4rr0i+6xC/+9GTwNRw5McYmpW8c="
      # SSH ID: https://sshid.io/attilaolah
      "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCEJJ7NHOvH4qQZlJFxffjG9dkLSsm2RCR6raI5/QraYTRyObxGWXwuRw/QCBLuEPc4gUidlNJq8h5Zr/R24wTA="
      "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBE8it5ifexXShE7exhhceX7Kpg0NrU/I2NHwUCOccu97NV/PQwpYcL4cw0Kg78L16SBIQROFGLykpgvOoHFvpEk="
      "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIjNkM3sk93A/GBP9mv3g1IjNyNe/KykHn/MAwp43kBeNnh0MkUUXUU9PuKndRUJTx6WAgY3S+DBZs5Xi6tnnQs="
      "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL7Q3kIBg9/2h4x1uYB3Az9tSWB2NZ7sGnI2EaCPaQGTphRhjeek9ZfDAs3gx4tD/iycSqTccecAkObHHut8d2I="
      "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBMjI/Lp8ALvsfObaKI5cYPtL5U1ig/YzPUcmxzjy/AVck1+DzPGjK1NzTxO2Ts3+2dNg/BOMsvgCuYuPxTFPJ+Q="
      "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPZecANWHBovFEHm5hX0PfflzrJsc83bv9Rm5PNHOsX0hCJAQpoN0n4n5Yd6Q5ywM11hRXn/JGOdTGrWDaQtMEg="
    ])
    ++ (ssh-ed25519 [
      # Portable failsafe key
      "AAAAC3NzaC1lZDI1NTE5AAAAIIiR17IcWh8l3OxxKSt+ODrUMLU98ZoJ+XvcR17iX9/P"
    ]);
}
