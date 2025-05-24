{
  description = "FoxOS - Built in Frostfall with Cunning Foxfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    snowfall-lib.url = "github:snowfallorg/lib";
    home-manager.url = "github:nix-community/home-manager";
    ...
  };

  outputs = inputs @ { self, nixpkgs, flake-parts, snowfall-lib, ... }:
    let
      foxfiles = ./.foxfiles;  # fox den 🦊
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];  # Or dynamically from systemSettings

      specialArgs = {
        inherit inputs;
        foxfiles = foxfiles;

        # Core Settings
        systemSettings = import ./frostfall/systems/x86_64-linux/hosts/frostnix/frostnix-systemSettings.nix;
        userSettings   = import ./frostfall/homes/x86_64-linux/users/notkoto73@frostnix/notkoto73-userSettings.nix;

        # Optional Enhancements
        systemProfiles = import ./frostfall/profiles/system;
        homeProfiles   = import ./frostfall/profiles/home;

        # FoxMagic 🦊
        foxlib = import "${foxfiles}/foxlib/lib/vulpes.nix" { inherit (nixpkgs) lib; };
      };

      imports = [
        snowfall-lib.flakeModules
        # Optional extras:
        # ./frostfall/modules/foxOs/frostcore-internals/circuit-box.nix
        # ./frostfall/modules/foxOs/frostcore-internals/control-center/themeland/theme-resolver.nix
      ];

      snowfall = {
        namespace = "frostfall";
        root = foxfiles;
        meta = {
          name  = "FoxOS";
          title = "FoxOS - Built in Frostfall";
        };
        modules = import "${foxfiles}/modules";
        hosts = {
          frostnix = import ./frostfall/hosts/frostnix;
          virtual  = import ./frostfall/hosts/virtualfox;
        };
        home.sharedModules = [
          "${foxfiles}/modules/home/shared/default.nix"
        ];
        channels-config = {
          allowUnfree = true;
          config = { };
        };
      };
    };
}

