# FoxOS Project Organization & Documentation Template

## 🦊 Project Overview
**FoxOS**: An RPG-style, text-adventure themed operating system with dynamic personas, themed quadrants, and deep lore integration.

### Core Concept
- **Text Adventure OS**: CLI-driven with gaming aesthetics and interactive elements
- **Quadrant System**: N/E/S/W villages/towns per use case (gaming, enterprise, themes, etc.)
- **Dynamic Personas**: Character/class selection for different host profiles
- **Multi-boot**: Dynamic character/quadrant/OS selection at boot
- **Worldbuilding**: Rich lore with easter eggs and "UndertaleOS" vibes

---

## 🧊 Technical Architecture

### Current Stack
- **Base**: Nix Flakes + flake-parts
- **Structure**: Snowfall-lib → Frostfall (custom fork)
- **Location**: `.foxfiles/` (project root) with `flake.nix` in `snowflakes/`
- **Extensions**: Custom flake-extensions system

### Directory Structure
```
.foxfiles/                    # Project root (foxfiles/foxDen)
├── snowflakes/              # Flake machinery
│   ├── flake.nix           # Main flake configuration
│   └── flake-extensions/    # Custom extensions
│       ├── flakemeta.nix   # Global metadata/settings
│       └── channel-policy.nix # Stable/unstable channel logic
├── frostfall/              # System configurations
│   ├── systems/            # NixOS configurations
│   ├── modules/            # NixOS modules
│   └── homes/              # Home Manager configs
├── frostflake/             # Host definitions
│   └── frosthosts.nix     # Host metadata and imports
└── lib/
    └── foxlib.nix         # Custom library functions
```

---

## 📋 Key Decisions & Patterns

### Path Management
```nix
# Current pattern (flake.nix in snowflakes/)
let
  flakePath = self;  # .foxfiles/snowflakes/
  projectRoot = flakePath + "/..";  # .foxfiles/
```

### Flake Extensions Concept
1. **flakeMeta**: Global settings/constants (timezone, system, etc.)
2. **Channel Policy**: Dynamic stable/unstable nixpkgs selection
3. **Host Meta**: Dynamic persona/character switching
4. **Future**: ISO generation, system templates

### Host Personas (from flakehosts.nix)
- `frostnix`: Admin tier (foxcorp branch)
- `generalpt`: Dev tier 
- `guest`: Desktop tier (default branch)
- `virtualfox`: Lab environment
- `foxserver`: Server profile
- `ghost`: Security profile

---

## 🎯 Immediate Action Items

### Phase 1: Foundation Cleanup
- [ ] Finalize flake.nix structure with refined flake-extensions
- [ ] Complete flakeMeta.nix implementation
- [ ] Test channel-policy.nix switching logic
- [ ] Document foxlib.nix utility functions

### Phase 2: Host System
- [ ] Implement dynamic host switching via CLI
- [ ] Create host-meta extension
- [ ] Design boot-time character selection
- [ ] Test multi-persona configurations

### Phase 3: Quadrant Implementation
- [ ] Design N/E/S/W directory structure
- [ ] Create quadrant-specific modules
- [ ] Implement quadrant switching logic
- [ ] Design themed CLI interfaces

### Phase 4: Advanced Features
- [ ] ISO generation with nixos-generators
- [ ] Disko integration for partitioning
- [ ] Impermanence setup
- [ ] Lore/easter egg system

---

## 🔧 Technical Patterns & Best Practices

### Flake Structure (Current)
```nix
# Lean flake with snowfall-lib + flake-parts integration
outputs = { self, snowfall-lib, ... }@inputs:
  snowfall-lib.mkFlake {
    inherit self inputs;
    snowfall = {
      namespace = "frostfall";
      root = projectRoot;
      # ... configuration
    };
  };
```

### Extension Pattern
```nix
# flakeMeta extension
flakeMeta = import ./flake-extensions/flakemeta.nix;
specialArgs = { inherit flakeMeta; };
```

### Path Construction
```nix
# Preferred: path type + string
modules = projectRoot + "/frostfall/modules";

# Alternative: string interpolation
modules = "${projectRoot}/frostfall/modules";
```

---

## 🚀 Future Vision: "Flake2" Concept

### Core Idea
Evolution beyond current flakes with:
- **Structured base** for extended logic
- **Built-in extensions** (meta, policies, hosts)
- **Modular expansion** ("DLC areas")
- **Maintained compatibility** with flake philosophy

### Integration Points
- flake-parts as core framework
- snowfall-lib (or frostfall) as opinionated layer
- Custom extensions as first-class citizens
- Standardized patterns for complex use cases

---

## 📚 Learning & Documentation

### Key Concepts Covered
- Nix flake structure and flake-parts integration
- Path management (`self`, `../`, projectRoot patterns)
- String interpolation vs path concatenation
- Snowfall-lib directory expectations
- Dynamic configuration management

### Questions for Further Exploration
- [ ] Optimal flake.nix location (root vs subdirectory)
- [ ] Extension architecture design
- [ ] Host switching implementation details
- [ ] Quadrant theming system design
- [ ] Performance implications of dynamic configs

---

## 🎮 FoxOS Unique Features

### RPG Elements
- Character/persona selection
- Themed environments (quadrants as villages/towns)
- CLI-driven interactions
- Rich lore integration
- Easter eggs and worldbuilding

### Technical Innovation
- Dynamic host configuration switching
- Quadrant-based system organization
- Advanced flake extension system
- Multi-channel package management
- Immersive theming throughout system

---

## 📝 Notes & Considerations

### Naming Conventions
- `foxfiles` = dotfiles root (play on dotfiles)
- `frostfall` = custom snowfall fork
- `snowflakes` = flake machinery directory
- Persona-based host naming (frostnix, generalpt, etc.)

### Development Environment
- devShell with Nix tooling (alejandra, statix, etc.)
- Git + GitHub CLI integration
- Development tools for building/testing
- Custom FoxOS development utilities

### Storage & Organization
- Consider dedicated partition for .foxfiles
- Integration with other dotfiles (pijul + stow)
- Separation of concerns between Nix and traditional dotfiles
- Backup and versioning strategies

---

*This template serves as a roadmap for organizing the FoxOS development process, extracting key insights from extensive technical discussions into actionable documentation.*