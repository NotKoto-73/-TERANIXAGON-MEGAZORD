{
  description = "🦊 FoxOS - Frostfall Core";

  inputs = {
  # Core system base
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  # Core Flake Infrastructure
  flake-parts.url = "github:hercules-ci/flake-parts";
  snowfall-lib = {
    url = "github:snowfallorg/lib";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake-root.url = "github:srid/flake-root";

  # System-Wide Modules (need nixpkgs)
  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  lanzaboote = {
    url = "github:nix-community/lanzaboote";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Desktop/Gaming Software (need nixpkgs)
  hyprland = {
    url = "github:hyprwm/Hyprland";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  chaotic = {
    url = "github:chaotic-cx/nyx";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  lix = {
    url = "github:lhylee/lix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  snowfall-editor = {
    url = "github:snowfallorg/editor";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  dedsec = {
    url = "github:VandalByte/dedsec-grub2-theme";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  
  # Optional Utilities (don't need nixpkgs follows)
  treefmt-nix.url = "github:numtide/treefmt-nix";
  mission-control.url = "github:Platonic-Systems/mission-control";

  # Hardware Specific (optional, no follow needed)
  nixos-hardware.url = "github:NixOS/nixos-hardware";
  impermanence.url = "github:nix-community/impermanence";
};

  outputs = inputs @ {
    self
    nixpkgs
    snowfall-lib
    home-manager
    sops-nix
    hyprland
    chaotic
    lix
    snowfall-editor
  };

let
  lib = import ./lib { inherit (nixpkgs) lib; };
  foxfiles = ./.foxfiles;
  fox = foxlib;
in
flake-parts.lib.mkFlake { inherit inputs; } {

  systems = [ systemSettings.system ];

  specialArgs = {
    inherit lib inputs;
    foxlib = import "${foxfiles}/foxlib/lib/vulpes.nix" { inherit lib; };
    systemSettings = import ./frostfall/systems/x86_64-linux/hosts/frostnix/frostnix-systemSettings.nix { inherit lib; };
    userSettings = import ./frostfall/homes/x86_64-linux/users/notkoto73@frostnix/notkoto73-userSettings.nix { inherit lib; };
    systemProfiles = import ./frostfall/profiles/system;
    homeProfiles = import ./frostfall/profiles/home;
    
    # Optional Wiring
    frostCircuits = import ./frostfall/modules/foxOs/frostcore-internals/control-center/circuit-box.nix;
    frostThemeMap = import ./frostfall/modules/foxOs/frostcore-internals/control-center/themeland/themeland-map.nix;
    frostThemeResolver = import ./frostfall/modules/foxOs/western-fox/nixos/southern-soleflare/personalization/themes/loaders/theme-resolver.nix;
  };

  imports = [
    snowfall-lib.flakeModules
    ./modules/foxOs/frostcore-internals/control-center/themeland/theme-resolver.nix
    # Optional: ./modules/foxOs/frostcore-internals/circuit-box.nix
  ];

  snowfall = {
    namespace = "frostfall";
    root = foxfiles;

    meta = {
      name = "frostfall/foxlib - inspired by snowfall";
      title = "FoxOS - Built in Frostnix with Cunning Foxfiles";
    };

    modules = import "${foxfiles}/modules";

    lib = {
      inherit lib;
      foxlib = lib;
    };

    hosts = {
      desktop = import ./systems/x86_64-linux/hosts/desktop;
      server = import ./systems/x86_64-linux/hosts/frostserver;
      vm = import ./systems/x86_64-linux/hosts/virtualfox;
      frostnix = import ./systems/x86_64-linux/hosts/frostnix;
    };

    home.sharedModules = [
      "${foxfiles}/modules/home/shared/default.nix"
    ];

    channels-config = {
      allowUnfree = true;
      permittedInsecurePackages = [ ];
      config = { };
    };

    outputs-builder = channels: {
      formatter = channels.nixpkgs.alejandra;
      alias = { };
    };
  };

  perSystem = import ./dev/iso/persys.nix;

  legacyPackages.homeConfigurations = {
    "${userSettings.username}@${systemSettings.hostname}" =
      let
        pkgs = import nixpkgs {
          system = systemSettings.system;
          config.allowUnfree = true;
        };
      in home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          inputs.hyprland.homeManagerModules.default
          inputs.snowfall-editor.homeManagerModules.default
        ];
      };
  };
}
