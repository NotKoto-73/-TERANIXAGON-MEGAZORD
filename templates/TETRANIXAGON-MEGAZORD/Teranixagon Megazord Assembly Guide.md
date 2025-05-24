# 🤖 Teranixagon Megazord Assembly Guide
*"It's morphin' time for your storage!"*

## 🏗️ Directory Structure Setup

Create this modular structure in your FoxOS configuration:

```
foxos/
├── teranixagon.nix              # Main assembler (the brain)
├── quadrants/                   # Core FoxOS parts
│   ├── frostcore.nix           # Central core system
│   ├── north-frostlands.nix    # System configuration
│   ├── east-kitsune.nix        # Secrets & networking
│   ├── south-soleflare.nix     # Performance & gaming
│   ├── west-reddfox.nix        # Enterprise & VMs
│   └── vault.nix               # Shared storage
├── multiboot-parts/             # OS collection (plug & play!)
│   ├── parrot-os.nix
│   ├── blackarch-slim.nix
│   ├── blackarch-full.nix
│   ├── freebsd.nix
│   ├── windows-ltsc.nix
│   ├── arch.nix
│   ├── garuda.nix
│   ├── guix.nix
│   ├── templeos.nix
│   └── haiku.nix
├── system-parts/                # System features
│   ├── impermanence.nix        # Ephemeral root + tmpfs
│   ├── luks-blanket.nix        # Encryption layer
│   ├── bootloaders.nix         # GRUB configuration
│   └── refind.nix              # rEFInd configuration
└── themes/                      # Boot themes
    ├── grub/foxos-octaquad/
    └── refind/foxos-octaquad/
```

## 🎛️ Quick Start Guide

### 1. Import the Teranixagon in your `configuration.nix`:

```nix
{ config, pkgs, ... }: {
  imports = [
    ./foxos/teranixagon.nix
  ];
}
```

### 2. Customize Your Build in `teranixagon.nix`:

```nix
# 🎮 YOUR CONTROL PANEL - Edit these toggles!
enabledParts = {
  # Core (always on)
  core = true;
  north = true;
  east = true;
  vault = true;
  
  # Optional quadrants
  south = true;   # 🔥 Enable for gaming/performance
  west = false;   # 🦊 Enable for VMs/enterprise
  
  # System features  
  ephemeral = true;   # 💨 Ephemeral root
  encryption = true;  # 🔐 LUKS everything
  refind = false;     # 🎯 true=rEFInd, false=GRUB
  
  # Pick your OS fighters! 🥊
  parrotOs = true;      # 🦜 Security testing
  blackarchSlim = false; # 🕷️ Penetration testing
  blackarchFull = false; # 🕸️ Full hacker arsenal
  freebsd = false;      # 🦬 BSD experience
  windows = true;       # 💼 Your LTSC setup
  arch = false;         # 🐧 Arch Linux
  garuda = false;       # 🦅 Gaming distro
  guix = true;          # 🧪 Weirdos cube
  templeos = true;      # ✨ Blessed OS
  haiku = false;        # 🌺 BeOS revival
};
```

### 3. Create a New OS Part (Example):

```nix
# 📁 multiboot-parts/kali-linux.nix
{ config, lib, pkgs, ... }: {
  disko.devices.disk.kali = {
    type = "disk";
    device = "/dev/sdX";  # Your device
    content = {
      type = "gpt";
      partitions = {
        kali-boot = {
          size = "512M";
          type = "efi";
          content = {
            type = "filesystem";
            format = "fat32";
            mountpoint = "/mnt/kali/boot";
          };
        };
        kali-root = {
          size = "30G";
          content = {
            type = "luks";
            name = "kali-secure";
            passwordFile = "/tmp/kali.key";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/mnt/kali/root";
            };
          };
        };
      };
    };
  };
}
```

### 4. Add to Teranixagon:

```nix
# In teranixagon.nix, add to multibootParts:
multibootParts = {
  # ... existing parts ...
  kali = ./multiboot-parts/kali-linux.nix;
};

# And to enabledParts:
enabledParts = {
  # ... existing toggles ...
  kali = true;  # Toggle your new OS!
};
```

## 🔧 Advanced Configuration

### Impermanence + Ephemeral Root

Your `system-parts/impermanence.nix` should handle:
- Tmpfs root filesystem
- Persistent directories in `/persist`
- Home directory persistence
- System state preservation

### rEFInd vs GRUB

**rEFInd Benefits:**
- Prettier interface
- Automatic OS detection
- Better theme support
- Touch-friendly on tablets

**GRUB Benefits:**
- More robust
- Better Linux integration
- Easier scripting
- Traditional feel

### Encryption Strategy

Each OS gets its own LUKS container:
- FoxOS: Full disk encryption
- Security OSes: Encrypted by default
- Windows: BitLocker (handled separately)
- Experimental: Optional encryption

## 🚀 Deployment Workflow

1. **Plan your storage** - Map out which SSDs/HDDs for what
2. **Configure teranixagon.nix** - Set your toggles
3. **Create OS parts** - Use templates for new OSes
4. **Test with minimal setup** - Start with just core + one OS
5. **Build incrementally** - Add one OS at a time
6. **Theme and polish** - Add boot themes last

## 🎯 Pro Tips

### Quick OS Swapping
```bash
# Disable Parrot, enable Kali
sudo sed -i 's/parrotOs = true;/parrotOs = false;/' teranixagon.nix
sudo sed -i 's/kali = false;/kali = true;/' teranixagon.nix
sudo nixos-rebuild switch
```

### Storage Optimization
- Put gaming OSes on fastest SSD
- Archive OSes can go on slower storage  
- Frequently used OSes get more space

### Backup Strategy
- Each OS partition is independent
- Backup teranixagon.nix configuration
- Keep partition UUIDs documented

## 🤖 Megazord Status Commands

Check your assembled system:
```bash
# View active quadrants
nixos-option foxos.teranixagon.assemblyStatus

# List mounted OS partitions
findmnt | grep -E "(parrot|blackarch|freebsd)"

# Check encryption status
cryptsetup status /dev/mapper/parrot-secure
```

## 🦊 The Fox Philosophy

> "A true fox adapts to any terrain. Your Teranixagon gives you every terrain on demand."

- **Modular**: Each OS is a removable part
- **Secure**: Everything encrypted by default
- **Flexible**: Toggle features on/off instantly
- **Powerful**: Full OS collection at your fingertips

**Happy Megazord Assembly, Commander Fox!** 🤖🦊

---

*Remember: With great power comes great responsibility. Use your multi-OS arsenal wisely!*