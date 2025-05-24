# .foxfiles/README.md
# .foxfiles - FoxOS Configuration

This directory contains the Nix flake configuration for FoxOS, a text-based adventure RPG operating system built on Nix/UNIX foundations.

## Structure

```
.foxfiles/
├── flake.nix           # Main flake configuration
├── flake.lock          # Locked dependencies (auto-generated)
├── shell.nix           # Compatibility shell for non-flake Nix
├── modules/            # FoxOS modules
│   ├── home-manager/   # Home Manager module
│   └── nixos/          # NixOS module
└── packages/           # FoxOS packages
    └── foxos/          # Main FoxOS package
```

## Quick Start

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <repository-name>
   ```

2. Enter the development shell:
   ```bash
   cd .foxfiles
   nix develop
   ```

3. Build FoxOS:
   ```bash
   nix build
   ```

## Using with Home Manager

Add to your Home Manager configuration:

```nix
{
  imports = [
    # Path to your local checkout
    /path/to/.foxfiles/modules/home-manager
    # Or from the flake
    inputs.foxos.homeManagerModules.default
  ];
  
  programs.foxos.enable = true;
  # Additional configuration...
}
```

## Using with NixOS

Add to your NixOS configuration:

```nix
{
  imports = [
    # Path to your local checkout
    /path/to/.foxfiles/modules/nixos
    # Or from the flake
    inputs.foxos.nixosModules.default
  ];
  
  services.foxos.enable = true;
  # Additional configuration...
}
```

## Development

To start development:

```bash
cd .foxfiles
nix develop
# Your development environment is ready!
```
