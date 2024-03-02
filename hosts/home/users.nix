{ pkgs, ... }:

{
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.fish;

    # Generate a password using:
    # nix-shell --run "mkpasswd -m SHA-512 -s" -p mkpasswd
    users = {
      root.initialHashedPassword = "$6$chB8XnZbQno6p5Zp$IE6xp/WGQYYwZGgAkQE9juhofD./R2ITPryZftBellWbeRKUtGBjBGOER6g9Qym.oDiMpkPc7OFOE4fxAV.fd/";

      ao = {
        isNormalUser = true;
        initialHashedPassword = "$6$vIhSgctj5NiIagWv$OJQuVZnf8diIJQQHG83WxCaEr3gczTNyiQJGDCU1gqpgrA7.gnjaIJ19KjLJbyAIBWxhqd51E/6hgmHeziJIe0";
        group = "ao";
        extraGroups = [ "wheel" ];  # for sudo
        openssh.authorizedKeys.keys = [
          # https://github.com/attilaolah.keys
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIiR17IcWh8l3OxxKSt+ODrUMLU98ZoJ+XvcR17iX9/P"
        ];
      };
    };

    groups.ao = {};
  };
}
