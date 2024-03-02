{
  description = "NixOS flakes.";

  inputs = {
    # renovate: datasource=github-releases depName=nixpkgs/nixos
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixos-generators = {
      # renovate: datasource=github-releases depName=nix-community/nixos-generators
      url = "github:nix-community/nixos-generators/1.8.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators, ... }: {
    packages.x86_64-linux = {
      workstation = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "raw-efi";
        modules = [
          ({ pkgs, lib, ... }: {
            system.stateVersion = "23.11";
            time.timeZone = "Europe/Zurich";
            i18n.defaultLocale = "en_US.UTF-8";

            boot = {
              # Enable TTY0 logging.
              # https://github.com/nix-community/nixos-generators?tab=readme-ov-file#format-specific-notes
              kernelParams = [ "console=tty0" ];
              loader = {
                efi = {
                  efiSysMountPoint = "/boot/efi";
                };
                grub = {
                  enable = true;
                  device = "nodev";
                  efiSupport = true;
                  enableCryptodisk = true;
                };
              };
              initrd = {
                kernelModules = [ "amdgpu" "kvm-intel" ];
                luks.devices = {
                  crypta = {
                    # 2T NVMe SSD.
                    device = "/dev/disk/by-uuid/8efccfcb-8c61-4844-89c9-3dbc1a900de4";
                    allowDiscard = true;
                    preLVM = true;
                  };
                  cryptb = {
                    # 2T NVMe SSD.
                    device = "/dev/disk/by-uuid/a4d6ae21-1535-42d0-b5a9-c249d1db71d4";
                    allowDiscard = true;
                    preLVM = true;
                  };
                };
                services.lvm.enable = true;
                # Start SSH during boot, to allow remote unlocking of LUKS volumes.
                network.ssh.enable = true;
              };
            };

            fileSystems."/" = {
              # LVM volume over crypta + cryptb.
              device = "/dev/nixvg/root";
              fsType = "ext4";
            };
            fileSystems."/boot" = {
              # 2Gi USB ESP partition.
              device = "/dev/disk/by-uuid/1FAC-B5E8";
              fsType = "vfat";
            };

            console = {
              earlySetup = true;
              # TODO: Remove, no need.
              # keyMap = "dvorak-programmer";
              useXkbConfig = true; # use xkb.options
            };

            hardware = {
              # CPU: Intel Xeon E5-2666 v3
              cpu.intel.updateMicrocode = true;
              opengl.extraPackages = with pkgs; [
                rocmPackages.clr.icd
              ];
              pulseaudio.enable = true;
            };

            systemd.tmpfiles.rules = [
              "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
            ];

            security = {
              polkit.enable = true;
              sudo.execWheelOnly = true;
            };

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

            networking = {
              # TODO: useDHCP = lib.mkForce true;
              hostName = "home";
              search = [ "dorn.haus" ];
              firewall.allowedTCPPorts = [ 22 8080 ];

              networkmanager.enable = true;
              nftables.enable = true;
            };

            services = {
              dbus.enable = true;

              openssh = {
                enable = true;
                startWhenNeeded = true;  # make it socket-activated
              };

              # Only used on the virtual console.
              xserver.xkb = {
                layout = "us";
                variant = "dvp";
                options = "caps:escape,compose:ralt,keypad:atm,kpdl:semi,numpad:shift3";
              };
            };

            xdg.portal = {
              enable = true;
              wlr.enable = true;
              extraPortals = with pkgs; [
                xdg-desktop-portal-hyprland
                xdg-desktop-portal-gtk
              ];
            };

            programs = {
              fish.enable = true;
              hyprland.enable = true;
              neovim = {
                enable = true;
                defaultEditor = true;
                viAlias = true;
                vimAlias = true;
              };
            };

            sound.enable = true;
          })
        ];
      };
    };
  };
}
