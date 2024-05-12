# NixOS: ❄️ Flakes & 🏠 Home Manager configs

NixOS configuration for personal hosts, along with dotfiles and other home
configuration in [home-manarer][3]. K8s cluster configs live
[in the ops repo][4].

[3]: https://github.com/attilaolah/os/tree/main/home-manager
[4]: https://gitlab.com/dornhaus/ops

## 💡 Inspiration

Much of this was inspired by a number of similar repos, online discussions and
of course Vimjoyer's excellent videos, e.g. [this one][5].

[5]: https://youtu.be/a67Sv4Mbxmc

Other notable repos:

- [3rfaan/arch-everforest]
- [iynaix/dotfiles]
- [khaneliman/khanelinix]
- [n3oney/nixus]
- [nixinator/nothing]
- [sjcobb2022/nixos-config]
- [stephenreynolds/nix-config]

[3rfaan/arch-everforest]: https://github.com/3rfaan/arch-everforest
[iynaix/dotfiles]: https://github.com/iynaix/dotfiles
[khaneliman/khanelinix]: https://github.com/khaneliman/khanelinix
[n3oney/nixus]: https://github.com/n3oney/nixus
[nixinator/nothing]: https://github.com/nixinator/nothing
[sjcobb2022/nixos-config]: https://github.com/sjcobb2022/nixos-config
[stephenreynolds/nix-config]: https://github.com/stephenreynolds/nix-config

See also [this comment][2], on how to use the config, or how to build it, even
for remote targets. Mind. Blown. 🤯 Also check out [Xe's blog][7].

[2]: https://discourse.nixos.org/t/proper-way-to-build-a-remote-system-with-flakes/17661/12
[7]: https://xeiaso.net/blog

## 🛠️ Installing

Boot from a NixOS install USB, unlock the LUKS devices, mount the LVM volume to
`/mnt`, the ESP partition to `/mnt/boot`, then run:

```sh
sudo nixos-install --root /mnt --flake github:attilaolah/os#home --no-root-password
```

This will install the workstation (`#home` config).

## 🚧 TODO

Add remote builds for other machines:

- Crostini
- VirtualBox

Set up [impermanence][6].

[6]: https://nixos.wiki/wiki/Impermanence
