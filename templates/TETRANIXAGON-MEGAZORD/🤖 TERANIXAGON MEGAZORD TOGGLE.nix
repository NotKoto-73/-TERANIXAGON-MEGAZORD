# 🤖 TERANIXAGON MEGAZORD ASSEMBLER
# The ultimate modular disk orchestration system
# "It's morphin' time!" - Commander Fox

{ config, lib, pkgs, ... }:

let
  # 🧩 Available multiboot parts (toggle these on/off)
  multibootParts = {
    parrotOs = ./multiboot-parts/parrot-os.nix;
    blackarchSlim = ./multiboot-parts/blackarch-slim.nix;  
    blackarchFull = ./multiboot-parts/blackarch-full.nix;
    freebsd = ./multiboot-parts/freebsd.nix;
    windows = ./multiboot-parts/windows-ltsc.nix;
    arch = ./multiboot-parts/arch.nix;
    garuda = ./multiboot-parts/garuda.nix;
    guix = ./multiboot-parts/guix.nix;
    templeos = ./multiboot-parts/templeos.nix;
    haiku = ./multiboot-parts/haiku.nix;
  };

  # 🕸️ FoxOS Core Quadrant Parts
  quadrantParts = {
    core = ./quadrants/frostcore.nix;
    north = ./quadrants/north-frostlands.nix;
    east = ./quadrants/east-kitsune.nix; 
    south = ./quadrants/south-soleflare.nix;
    west = ./quadrants/west-reddfox.nix;
    vault = ./quadrants/vault.nix;
  };

  # 🔧 System Parts  
  systemParts = {
    ephemeral = ./system-parts/impermanence.nix;
    encryption = ./system-parts/luks-blanket.nix;
    bootloaders = ./system-parts/bootloaders.nix;
    refind = ./system-parts/refind.nix;
  };

  # 🎮 Toggle Configuration - YOUR CONTROL PANEL
  enabledParts = {
    # Core FoxOS (always enabled)
    core = true;
    north = true;
    east = true;
    vault = true;
    
    # Optional Quadrants
    south = false;  # Performance/Gaming - toggle me!
    west = false;   # Enterprise/VMs - toggle me!
    
    # System Features
    ephemeral = true;   # Impermanence + tmpfs
    encryption = true;  # LUKS everything
    refind = false;     # Set true for rEFInd, false for GRUB
    
    # Multiboot OS Selection (pick your fighters!)
    parrotOs = false;
    blackarchSlim = false;
    blackarchFull = false; 
    freebsd = false;
    windows = true;     # Your LTSC setup
    arch = false;
    garuda = false;
    guix = true;        # Weirdos cube
    templeos = true;    # Blessed OS
    haiku = false;
  };
  
  # 🔄 Dynamic part loader function
  loadEnabledParts = partSet: enabledSet: 
    lib.attrValues (lib.filterAttrs (name: path: enabledSet.${name} or false) partSet);

in {
  imports = 
    # 🕸️ Core quadrant parts (always load core essentials)
    [ quadrantParts.core quadrantParts.north quadrantParts.east quadrantParts.vault ]
    
    # 🔧 System parts (based on toggles)
    ++ (loadEnabledParts systemParts enabledParts)
    
    # 🎯 Optional quadrants (based on toggles)  
    ++ (lib.optional enabledParts.south quadrantParts.south)
    ++ (lib.optional enabledParts.west quadrantParts.west)
    
    # 🌍 Multiboot OS parts (based on toggles)
    ++ (loadEnabledParts multibootParts enabledParts);

  # 🤖 Teranixagon Configuration
  foxos.teranixagon = {
    enable = true;
    
    # 🧬 Megazord Assembly Status
    assemblyStatus = {
      core = "ONLINE";
      quadrants = {
        north = if enabledParts.north then "ACTIVE" else "STANDBY";
        east = if enabledParts.east then "ACTIVE" else "STANDBY"; 
        south = if enabledParts.south then "ACTIVE" else "OFFLINE";
        west = if enabledParts.west then "ACTIVE" else "OFFLINE";
      };
      
      multiboot = lib.filterAttrs (name: enabled: enabled) {
        inherit (enabledParts) parrotOs blackarchSlim blackarchFull freebsd windows arch garuda guix templeos haiku;
      };
      
      systems = {
        ephemeral = enabledParts.ephemeral;
        encryption = enabledParts.encryption;
        bootloader = if enabledParts.refind then "rEFInd" else "GRUB";
      };
    };
    
    # 🎛️ Quick toggles for runtime
    quickToggles = {
      performanceMode = enabledParts.south;
      enterpriseMode = enabledParts.west;
      stealthMode = enabledParts.east;
      ephemeralMode = enabledParts.ephemeral;
    };
  };

  # 🚀 Boot configuration dispatcher
  boot.loader = lib.mkMerge [
    (lib.mkIf enabledParts.refind {
      # rEFInd configuration will be handled by system-parts/refind.nix
      systemd-boot.enable = false;
      grub.enable = false;
    })
    
    (lib.mkIf (!enabledParts.refind) {
      # GRUB configuration will be handled by system-parts/bootloaders.nix  
      systemd-boot.enable = false;
    })
  ];
}

# 🤖 END TERANIXAGON MEGAZORD ASSEMBLER
#
# USAGE IN YOUR FLAKE:
# 1. Create the directory structure:
#    ├── teranixagon.nix (this file)
#    ├── quadrants/
#    │   ├── frostcore.nix
#    │   ├── north-frostlands.nix
#    │   └── ...
#    ├── multiboot-parts/
#    │   ├── parrot-os.nix
#    │   ├── blackarch-slim.nix  
#    │   └── ...
#    └── system-parts/
#        ├── impermanence.nix
#        ├── refind.nix
#        └── ...
#
# 2. Import in your nixos configuration:
#    imports = [ ./teranixagon.nix ];
#
# 3. Toggle parts on/off by editing enabledParts above
#
# 🦊 "Disk Rangers, ASSEMBLE!"