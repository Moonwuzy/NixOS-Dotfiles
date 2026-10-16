# NixOS configuration

This flake defines two systems:

- `desktop` — hostname `mafuyu`
- `laptop` — hostname `yaoilover`

## Layout

- `hosts/` contains per-machine configuration and generated hardware configuration (`hardware.nix`).
- `modules/core/` contains shared settings.
- `modules/desktop/` contains desktop-only zram, swap, and graphics settings.
- `modules/laptop/` contains ASUS-specific, laptop graphics, and power/backlight settings.
- `home/moonwuzy/` contains the files managed by Home Manager.
- `archive/legacy/` preserves old root-level configs and backups; these are not imported by the flake.

`modules/core/vr.nix` is kept as a separate opt-in module because the previous host configurations did not import `modules/vr.nix`. The existing Monado settings remain active through `modules/core/gaming.nix`.

## Validate before switching

From this directory, run the matching command on the relevant machine:

```sh
sudo nixos-rebuild build --flake .#desktop
sudo nixos-rebuild build --flake .#laptop
```

Only build the configuration matching the machine you are currently booted into. After a successful build, test it with `sudo nixos-rebuild test --flake .#desktop` or `sudo nixos-rebuild test --flake .#laptop`. Do not run `switch` until the build succeeds.
