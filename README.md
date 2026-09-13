# YoRHa GRUB theme for NixOS

A Nix flake that packages [OliveThePuffin's YoRHa GRUB theme](https://github.com/OliveThePuffin/yorha-grub-theme) and provides a NixOS module to enable it. Includes **1080p** and **1440p** variants with backgrounds, fonts, and menu assets.

## Requirements

- A flake-based NixOS configuration.
- GRUB already configured as your bootloader.

This module sets `boot.loader.grub.theme`; it does not enable GRUB or configure boot devices or EFI. It does not theme systemd-boot. Keep your existing bootloader configuration when following the steps below.

## Installation

### 1. Add the flake input

Add `yorha` to the inputs in your system's `flake.nix`:

```nix
inputs.yorha.url = "github:berker-z/yorha-flake";
```

### 2. Import the NixOS module

Include `yorha` in your `outputs` arguments and add its module to the relevant host's `modules` list. For example:

```nix
outputs = { self, nixpkgs, yorha, ... }: {
  nixosConfigurations.my-host = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux"; # Use your host's architecture.
    modules = [
      ./configuration.nix
      yorha.nixosModules.yorha-grub-theme
    ];
  };
};
```

Merge these additions into your existing flake, preserving its other inputs and modules. Import the theme as a **NixOS module**, not a Home Manager module.

### 3. Enable the theme

In `configuration.nix` or another NixOS module imported by your host:

```nix
boot.loader.grub.yorhaTheme = {
  enable = true;
  resolution = "1080p"; # Or "1440p".
};
```

The resolution option selects the theme's assets and layout; it does not set GRUB's display mode. Choose the variant that matches the resolution used by your boot menu.

### 4. Apply and reboot

Run this from your system configuration directory, replacing `my-host` with your `nixosConfigurations` host name:

```sh
sudo nixos-rebuild switch --flake .#my-host
```

Reboot to see the theme in the GRUB menu.

## Options

| Option | Default | Values |
| --- | --- | --- |
| `boot.loader.grub.yorhaTheme.enable` | `false` | `true` or `false` |
| `boot.loader.grub.yorhaTheme.resolution` | `"1080p"` | `"1080p"` or `"1440p"` |

When enabled, the module installs the selected theme package into `environment.systemPackages` and points `boot.loader.grub.theme` at its `share/grub/themes/yorha` directory in the Nix store. No manual asset copying is needed.

## Troubleshooting

- **The `yorhaTheme` option does not exist:** ensure `yorha.nixosModules.yorha-grub-theme` is imported into the host you are rebuilding.
- **Conflicting `boot.loader.grub.theme` definitions:** remove another explicit theme assignment or disable the other theme module before enabling this one.
- **The theme does not appear:** confirm the machine boots through GRUB and that you rebuilt the intended host. The theme appears at boot, not in the running desktop session.
- **Text or layout looks incorrectly sized:** check GRUB's display resolution and select the matching theme variant. Changing `resolution` alone does not change the display mode.

To disable the theme, set `boot.loader.grub.yorhaTheme.enable = false;` and rebuild. This stops the module from setting the GRUB theme or installing its package.

## Credits

Original theme and artwork: [OliveThePuffin/yorha-grub-theme](https://github.com/OliveThePuffin/yorha-grub-theme).

NixOS flake integration: [berker-z/yorha-flake](https://github.com/berker-z/yorha-flake). The module import and enablement pattern above is also used in [my dotfiles](https://github.com/berker-z/dotfiles).
