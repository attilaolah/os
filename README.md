# ❄️ NixOS flakes

Inspired by nixinator/nothing.

[nixinator/nothing]: ahttps://github.com/nixinator/nothing.

More details [in this comment][1], on how to use the config, or how to build it, even for remote targets. Mind blown. 🤯

[1]: https://discourse.nixos.org/t/proper-way-to-build-a-remote-system-with-flakes/17661/12

## 🛠️ Installing

Boot from a NixOS install USB, unlock the LUKS devices, mount the LVM volume to `/mnt`, the ESP partition to `/mnt/boot`, then run:

```sh
sudo nixos-install --root /mnt --flake github:attilaolah/os#home --no-root-password
```

This will install the workstation (`#home` config).

## 🚧 TODO

Add remote builds for other machines, incl. Crostini and k8s hosts.
