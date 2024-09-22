# ThinkPad T14, Gen 3 (work laptop)

This is a laptop that, for reasons, must have Windows installed on its main
drive. NixOS is thus installed on an encrypted removable device.

The USB drive has an EFI partition and a "root" partition. The root partition
is actually an LVM PV to allow extending it e.g. with a second USB stick, or
with some spare disk space from the main drive.
