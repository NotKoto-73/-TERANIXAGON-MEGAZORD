# Предполагаемое расположение: .foxfiles/snowflakes/flake.nix
{
  description = "FoxOS✔️ - Built in Frostfall❄️ with Cunning Foxfiles🦊";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    snowfall-lib.url = "github:snowfallorg/lib"; # Core library for structuring the flake
    home-manager.url = "github:nix-community/home-manager";

    # --- Flake Extensions & Customizations ---
    # fox-flake-extensions.url = "path:./flake-extensions"; # Example if extensions were a separate flake input

    # --- Optional integrations and system tooling ---
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    disko.url = "github:nix-community/disko"; # For declarative disk partitioning

    # --- Desktop/UX overlays & Packages ---
    hyprland.url = "github:hyprwm/Hyprland";
    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    # lix.url = "github:lhylee/lix";
  };

  outputs = { self, nixpkgs, flake-parts, snowfall-lib, home-manager, ... }@inputs:
    let
      # Define the root of your entire project/configuration.
      # Since flake.nix is in '.foxfiles/snowflakes/', '../.' points to '.foxfiles/'.
      projectRoot = ../.; # This is your '.foxfiles/' directory.

      # --- Flake Meta Extension ---
      # Your custom 'flakemeta.nix' provides global constants and configurations.
      # Located at: .foxfiles/snowflakes/flake-extensions/flakemeta.nix
      # Imported relative to this flake.nix file.
      flakeMeta = import ./flake-extensions/flakemeta.nix {
        # You could pass inputs to flakeMeta if needed, e.g.:
        # inherit inputs nixpkgs projectRoot;
      };

    in
    flake-parts.lib.mkFlake { inherit self inputs; } {
      # --- Global Settings for Flake Parts ---
      # Define the system(s) this flake supports.
      # Sourced from your flakeMeta extension for centralized definition.
      systems = flakeMeta.systems or [ "x86_64-linux" ]; # Default if not specified in flakeMeta

      # --- Special Arguments (specialArgs) ---
      # These arguments are passed down to all modules (NixOS, Home Manager, etc.).
      specialArgs = {
        inherit flakeMeta; # Makes `flakeMeta.timezone`, `flakeMeta.user` etc. available in modules.
        inherit projectRoot; # Pass the projectRoot if modules need to construct absolute paths.
        # You could add other global utilities or configurations here.
      };

      # --- Per-System Configuration ---
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # You can define packages, apps, devshells, etc., here if needed directly with flake-parts.
      };

      # --- Snowfall Lib Configuration ---
      flake = {
        imports = [
          snowfall-lib.flakeModules.nixos
        ];

        snowfall = {
          namespace = flakeMeta.namespace or "foxos";

          # The root directory of your NixOS and Home Manager configurations.
          # This should point to '.foxfiles/' where 'hosts', 'modules', etc. are expected.
          root = projectRoot; # This correctly points to '.foxfiles/'

          meta = {
            name = flakeMeta.name or "FoxOS";
            title = flakeMeta.title or "FoxOS - Built with Snowfall";
            # projectRoot can also be set here if snowfall-lib needs it explicitly,
            # though 'root' usually suffices.
            # projectRoot = projectRoot;
          };

          # --- NixOS Modules ---
          # Path to your NixOS modules directory, relative to `snowfall.root` (i.e., projectRoot).
          # Example: .foxfiles/frostfall/modules
          modules = import (projectRoot + "/frostfall/modules");

          # --- NixOS Hosts (System Configurations) ---
          # Path to your host configurations, relative to `snowfall.root`.
          # Example: .foxfiles/frostflake/frosthosts.nix
          hosts = import (projectRoot + "/frostflake/frosthosts.nix");

          # --- Home Manager Configurations ---
          home = {
            # Global Home Manager modules shared across all users/hosts.
            # Paths are relative to `snowfall.root`.
            # Example: .foxfiles/frostfall/homes/foxos/x86_64-linux/shared/default.nix
            sharedModules = [
              (projectRoot + "/frostfall/homes/foxos/x86_64-linux/shared/default.nix")
            ];

            # users = {
            #   "username" = { pkgs, ... }: {
            #     imports = [ (projectRoot + "/frostfall/homes/user/specific.nix") ];
            #   };
            # };
          };
        };
      };
    };
}

