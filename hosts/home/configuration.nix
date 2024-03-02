{ config, lib, pkgs, ... }:

{
  system.stateVersion = "23.11";
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";

  boot = {
    kernelModules = [ "kvm-intel" ];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
      };
    };
    initrd = {
      kernelModules = [ "amdgpu" ];
      availableKernelModules = [
        "ahci"
        "nvme"
        "usbhid"
        "xhci_pci"
      ];
      luks.devices = {
        crypta = {
          # 2T NVMe SSD.
          device = "/dev/disk/by-uuid/8efccfcb-8c61-4844-89c9-3dbc1a900de4";
          allowDiscards = true;
          preLVM = true;
        };
        cryptb = {
          # 2T NVMe SSD.
          device = "/dev/disk/by-uuid/a4d6ae21-1535-42d0-b5a9-c249d1db71d4";
          allowDiscards = true;
          preLVM = true;
        };
      };
      services.lvm.enable = true;
      # Start SSH during boot, to allow remote unlocking of LUKS volumes.
      network.ssh.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      # LVM volume over crypta + cryptb.
      device = "/dev/nixvg/root";
      fsType = "ext4";
      options = [ "lazytime" ];
    };
    "${config.boot.loader.efi.efiSysMountPoint}" = {
      # TMP; TODO: Move to 2Gi USB ESP partition.
      device = "/dev/disk/by-uuid/EC50-CA49";
      fsType = "vfat";
    };
  };

  console = {
    earlySetup = true;
    # TODO: Remove, no need.
    # keyMap = "dvorak-programmer";
    useXkbConfig = true; # use xkb.options
  };

  hardware = {
    # CPU: Intel Xeon E5-2666 v3
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        amdvlk
        rocm-opencl-icd
        rocm-opencl-runtime
        rocmPackages.clr.icd
      ];
    };
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
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
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

  sound.enable = true;

  nix = {
    package = pkgs.nixUnstable;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
  ];

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
}
