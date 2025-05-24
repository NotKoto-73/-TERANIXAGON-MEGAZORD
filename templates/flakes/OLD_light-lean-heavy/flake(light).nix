# flake.nix (Top-Level Map)

inputs = {
  nixpkgs = ...;
  home-manager = ...;
  snowfall-lib = ...;
  ...
};

outputs = inputs @ {
  self,
  nixpkgs,
  snowfall-lib,
  ...
}:
let
  foxlib = import ./path/to/.foxfiles/foxlib/lib/vulpes.nix { inherit (nixpkgs) lib; };
  systemSettings = import ./systems/x86_64-linux/hosts/frostnix/frostnix-systemSettings.nix;
  userSettings = import ./homes/x86_64-linux/users/notkoto73@frostnix/notkoto73-userSettings.nix;

  # ❄️ ONLY bring in what’s reused globally
  circuitBox = import ./modules/foxOs/frostcore-internals/circuit-box.nix;
  themeResolver = import ./modules/foxOs/frostcore-internals/control-center/themeland/theme-resolver.nix;

in flake-parts.lib.mkFlake { inherit inputs; } {
  systems = [ systemSettings.system ];

  specialArgs = {
    inherit foxlib inputs systemSettings userSettings;
    inherit circuitBox themeResolver;  # ✅ Optional, only if shared globally
  };

  imports = [
    snowfall-lib.flakeModules
    ./dev/iso/perSystem.nix
  ];

  snowfall = {
    namespace = "foxos";
    root = ./path/to/.foxfiles;
    modules = import ./path/to/.foxfiles/modules;
    hosts = {
      frostnix = import ./hosts/frostnix;
      ...
    };
    home.sharedModules = [
      ./path/to/.foxfiles/modules/home/shared/default.nix
    ];
  };
};

