# Expected location: .foxfiles/snowflakes/flake.nix
{
  description = "FoxOS✔️ - Built in Frostfall❄️ with Cunning Foxfiles🦊";

  inputs = {
    # --- Nix Packages & Home-Manager ---
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05"; # Default stable channel
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # Default unstable channel
    # Add other specific nixpkgs versions if your channel policy might point to them,
    # e.g., nixpkgs-2311.url = "github:nixos/nixpkgs/release-23.11";
    home-manager.url = "github:nix-community/home-manager";
    # home-manager's nixpkgs is now determined dynamically in specialArgs

    # --- Core Flake Libraries ---
    flake-parts.url = "github:hercules-ci/flake-parts";
    snowfall-lib.url = "github:snowfallorg/lib"; # Base for system configurations

    # --- System Tooling & Hardware ---
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    disko.url = "github:nix-community/disko"; # Declarative disk partitioning
    nixos-generators.url = "github:nix-community/nixos-generators"; # For ISO and image generation
    treefmt-nix.url = "github:numtide/treefmt-nix"; # Code formatting

    # --- Bleeding Edge Repos & Overlays (Examples) ---
    lix.url = "github:lhylee/lix";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # --- Themes & Boot ---
    dedsec-grub-theme.url = "gitlab:VandalByte/dedsec-grub-theme";
    minegrub-theme.url = "github:Lxtharia/minegrub-theme";
    nixos-boot.url = "github:Melkor333/nixos-boot";

    # --- Desktop/UX Overlays & Packages ---
    Hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, flake-parts, snowfall-lib, treefmt-nix, ... }@inputs:
    let
      # Define the root of your entire project/configuration.
      # Since flake.nix is in '.foxfiles/snowflakes/', '../.' points to '.foxfiles/'.
      FoxRoot = ../.; # This is your '.foxfiles/' directory.

      # --- Flake Meta Extension ---
      # Your custom 'flakemeta.nix' provides global constants and configurations.
      # Located at: .foxfiles/snowflakes/flake-extensions/flakemeta.nix
      # It's assumed flakeMeta can be evaluated with just inputs and projectRoot for channel policy decisions.
      # If it needs a 'lib' for this, it should use a fixed one like 'inputs.nixpkgs.lib'.
      flakeMeta = import ./flake-extensions/flakemeta.nix {
        inherit inputs projectRoot;
        # Pass a default lib if absolutely necessary for pre-channel-selection logic in flakeMeta:
        # lib = inputs.nixpkgs.lib;
      };

      # --- Channel Policy Extension ---
      # Located at: .foxfiles/snowflakes/flake-extensions/channel-policy.nix (example path)
      # This file should return an attrset defining which nixpkgs input to use,
      # e.g., { systemChannelInput = "nixpkgs-unstable"; homeManagerChannelInput = "nixpkgs"; }
      # It would use 'flakeMeta' internally to make its decisions.
      channelPolicyConfig = import ./flake-extensions/channel-policy.nix {
        inherit flakeMeta inputs; # Pass flakeMeta and inputs to the policy
      };

      # Determine which nixpkgs input to use based on the policy
      # Ensure the string names match keys in 'inputs'
      selectedSystemPkgsInput = inputs."${channelPolicyConfig.systemChannelInputName or "nixpkgs"}";
      selectedHomeManagerPkgsInput = inputs."${channelPolicyConfig.homeManagerChannelInputName or "nixpkgs"}";

    in
    flake-parts.lib.mkFlake { inherit self inputs; } {
      systems = flakeMeta.systems or [ "x86_64-linux" ];

      specialArgs = system:
        let
          # Instantiate pkgs sets based on dynamic channel selection
          systemPkgs = import selectedSystemPkgsInput {
            inherit system;
            # config.allowUnfree = true; # Example global pkgs config
            # overlays = [ ... ]; # Global overlays for systemPkgs
          };
          homeManagerPkgs = import selectedHomeManagerPkgsInput {
            inherit system;
            # config.allowUnfree = true;
            # overlays = [ ... ]; # Global overlays for homeManagerPkgs
          };
        in
        {
          inherit flakeMeta projectRoot channelPolicyConfig;
          pkgs = systemPkgs; # Primary pkgs for the system
          pkgsUnstable = import inputs.nixpkgs-unstable { inherit system; }; # Always available for explicit use
          pkgsStable = import inputs.nixpkgs { inherit system; };     # Always available for explicit use

          # Specific pkgs set for Home Manager, potentially different from systemPkgs
          hmPkgs = homeManagerPkgs;

          # Make other relevant inputs available
          inherit (inputs) home-manager snowfall-lib nixos-hardware impermanence disko nixos-generators treefmt-nix lix chaotic Hyprland dedsec-grub-theme minegrub-theme nixos-boot;
        };

      perSystem = { config, pkgs, system, self', inputs', specialArgs, ... }: {
        # `pkgs` here is `specialArgs.pkgs` (dynamically selected system pkgs).
        # `specialArgs.pkgsUnstable`, `specialArgs.pkgsStable`, `specialArgs.hmPkgs` are also available.

        formatter = specialArgs.treefmt-nix.lib.mkFormatter {
          name = "alejandra";
          projectRootFile = "snowflakes/flake.nix"; # Path relative to actual project root (.foxfiles)
          programs.alejandra.enable = true;
        };

        # Example ISO package definition:
        # packages.foxos-iso = specialArgs.nixos-generators.nixosGenerate {
        #   inherit system;
        #   modules = [ (specialArgs.projectRoot + "/path/to/your/iso-nixos-config.nix") ];
        #   format = "iso";
        #   # Ensure this ISO configuration uses specialArgs.pkgs or the desired pkgs set
        # };
      };

      flake = {
        imports = [
          inputs.snowfall-lib.flakeModules.nixos
          # To ensure Home Manager configurations get the correct `hmPkgs` via snowfall-lib,
          # snowfall-lib itself might need to be adapted or configured to pick up `specialArgs.hmPkgs`.
          # Alternatively, pass `pkgs = specialArgs.hmPkgs;` directly in Home Manager module definitions
          # if snowfall-lib doesn't propagate it automatically from a differently named specialArg.
          # For now, snowfall will use `specialArgs.pkgs` for HM unless host/user configs override `pkgs`.
        ];

        snowfall = {
          namespace = flakeMeta.namespace or "foxos";
          root = projectRoot;

          meta = flakeMeta.snowfallMeta or {
            name = "FoxOS";
            title = "FoxOS - Built in Frostfall";
          };

          modules = projectRoot + "/frostfall/modules";

          # Assuming your flake-hosts.nix has a top-level 'hosts' attribute
          # containing the actual NixOS configurations for snowfall-lib.
          # E.g., .foxfiles/frostflake/flakehosts.nix returns { metadataForHostA = {...}; hosts = { hostA = {...}; }; }
          hosts = (import (projectRoot + "/frostflake/flakehosts.nix") {
            # Pass necessary arguments if flakehosts.nix is a function
            # inherit inputs specialArgs; # If it needs access to pkgs, lib, etc.
            # For the structure you provided, it seems to be a simple attrset import.
          }).hosts; # Access the nested 'hosts' attribute for snowfall-lib

          home = {
            sharedModules = [
              (projectRoot + "/frostfall/homes/shared/default.nix")
            ];
            # Home Manager configurations defined in snowfall.hosts (e.g., hostFile.users.someUser = { ... })
            # will by default receive `specialArgs.pkgs` as their `pkgs` argument.
            # If you need them to use `specialArgs.hmPkgs`, you might need to structure your
            # host configurations to explicitly pass `pkgs = specialArgs.hmPkgs;` to the HM part.
            # Example within a host definition in what `flakehosts.nix` provides:
            # myHost = { ... pkgs, lib, config, specialArgs, ...}: {
            #   users.myUser = { ... }: {
            #     # This HM config will use specialArgs.hmPkgs
            #     _module.args.pkgs = specialArgs.hmPkgs;
            #     imports = [ ... ];
            #     # ... rest of HM config
            #   };
            # };
          };
        };
      };
    };
}
```

**Key assumptions and notes for this version:**

* **`flake-meta.nix` Location:** Assumed to be at `.foxfiles/snowflakes/flake-extensions/flakemeta.nix`.
    * Its internal paths (like `import ../systems/...`) would need to be relative to this location (e.g., `import ../../systems/...` if `systems` is a child of `.foxfiles/`).
* **`channel-policy.nix` Location:** I've assumed a path like `.foxfiles/snowflakes/flake-extensions/channel-policy.nix`.
    * It should return an attribute set, for example: `{ systemChannelInputName = "nixpkgs-unstable"; homeManagerChannelInputName = "nixpkgs"; }`. These string values must match keys in your `inputs` block.
* **`flakehosts.nix` Structure:** Assumed that your `.foxfiles/frostflake/flakehosts.nix` file returns an attribute set that has a top-level key `hosts`, and the value of `hosts` is the actual attribute set of NixOS host configurations that `snowfall-lib` expects.
* **Home Manager `pkgs`**: I've added `hmPkgs` to `specialArgs`. You'll need to ensure your Home Manager configurations (whether defined in `snowfall.home.users` or within each host's definition) are set up to receive and use `specialArgs.hmPkgs` as their `pkgs` argument if it differs from the system's `specialArgs.pkgs`. Snowfall-lib typically passes `specialArgs.pkgs` to Home Manager modules. You might need to use `_module.args.pkgs = specialArgs.hmPkgs;` within your Home Manager configurations.

This refined `flake.nix` should provide a more robust framework for your dynamic FoxOS setup. You're building a very sophisticated syst
