# 🌍 FOXOS MULTIBOOT PARTS TEMPLATES
# Plug-and-play OS modules for the Teranixagon Megazord

# ═══════════════════════════════════════════════════════════════════
# 📁 multiboot-parts/parrot-os.nix
# ═══════════════════════════════════════════════════════════════════
{ config, lib, pkgs, ... }: {
  disko.devices.disk.parrot-os = {
    type = "disk";
    device = "/dev/sdd1"; # Adjust device path
    content = {
      type = "gpt";
      partitions = {
        parrot-boot = {
          size = "512M";
          type = "efi";
          content = {
            type = "filesystem";
            format = "fat32";
            mountpoint = "/mnt/parrot/boot";
          };
        };
        parrot-root = {
          size = "30G";
          content = {
            type = "luks";
            name = "parrot-secure";
            passwordFile = "/tmp/parrot.key";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/mnt/parrot/root";
            };
          };
        };
        parrot-home = {
          size = "50G";
          content = {
            type = "luks"; 
            name = "parrot-home";
            passwordFile = "/tmp/parrot.key";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/mnt/parrot/home";
            };
          };
        };
      };
    };
  };
  
  # GRUB entry
  boot.loader.grub.extraEntries = ''
    menuentry "Parrot Security OS 🦜" {
      insmod part_gpt
      insmod ext2
      insmod luks
      cryptomount -u [PARROT-LUKS-UUID]
      set root='cryptouuid/[PARROT-LUKS-UUID]'
      linux /boot/vmlinuz root=/dev/mapper/parrot-secure ro quiet splash
      initrd /boot/initrd.img
    }
  '';
}

# ═══════════════════════════════════════════════════════════════════
# 📁 multiboot-parts/blackarch-slim.nix  
# ═══════════════════════════════════════════════════════════════════
{ config, lib, pkgs, ... }: {
  disko.devices.disk.blackarch-slim = {
    type = "disk";
    device = "/dev/sde1";
    content = {
      type = "gpt";
      partitions = {
        blackarch-boot = {
          size = "512M";
          type = "efi";
          content = {
            type = "filesystem";
            format = "fat32";
            mountpoint = "/mnt/blackarch/boot";
          };
        };
        blackarch-root = {
          size = "25G"; # Slim version
          content = {
            type = "luks";
            name = "blackarch-venom";
            passwordFile = "/tmp/blackarch.key";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/mnt/blackarch/root";
              mountOptions = [ "discard" "noatime" ];
            };
          };
        };
      };
    };
  };
  
  boot.loader.grub.extraEntries = ''
    menuentry "BlackArch Linux (Slim) 🕷️" {
      insmod part_gpt
      insmod ext2
      insmod luks
      cryptomount -u [BLACKARCH-LUKS-UUID]
      set root='cryptouuid/[BLACKARCH-LUKS-UUID]'  
      linux /boot/vmlinuz-linux root=/dev/mapper/blackarch-venom rw
      initrd /boot/initramfs-linux.img
    }
  '';
}

# ═══════════════════════════════════════════════════════════════════
# 📁 multiboot-parts/blackarch-full.nix
# ═══════════════════════════════════════════════════════════════════  
{ config, lib, pkgs, ... }: {
  disko.devices.disk.blackarch-full = {
    type = "disk";
    device = "/dev/sde1";
    content = {
      type = "gpt";
      partitions = {
        blackarch-boot = {
          size = "1G";
          type = "efi";
          content = {
            type = "filesystem";
            format = "fat32";
            mountpoint = "/mnt/blackarch/boot";
          };
        };
        blackarch-root = {
          size = "40G"; # Full toolset needs more space
          content = {
            type = "luks";
            name = "blackarch-arsenal";
            passwordFile = "/tmp/blackarch.key";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/mnt/blackarch/root";
            };
          };
        };
        blackarch-tools = {
          size = "80G"; # Dedicated tools partition
          content = {
            type = "luks";
            name = "blackarch-tools";
            passwordFile = "/tmp/blackarch.key";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/mnt/blackarch/tools";
            };
          };
        };
      };
    };
  };
  
  boot.loader.grub.extraEntries = ''
    menuentry "BlackArch Linux (Full Arsenal) 🕸️" {
      insmod part_gpt
      insmod ext2
      insmod luks
      cryptomount -u [BLACKARCH-LUKS-UUID]
      set root='cryptouuid/[BLACKARCH-LUKS-UUID]'
      linux /boot/vmlinuz-linux root=/dev/mapper/blackarch-arsenal rw
      initrd /boot/initramfs-linux.img
    }
  '';
}

# ═══════════════════════════════════════════════════════════════════
# 📁 multiboot-parts/freebsd.nix
# ═══════════════════════════════════════════════════════════════════
{ config, lib, pkgs, ... }: {
  disko.devices.disk.freebsd = {
    type = "disk";  
    device = "/dev/sdf1";
    content = {
      type = "gpt";
      partitions = {
        freebsd-boot = {
          size = "512K";
          type = "freebsd-boot";
        };
        freebsd-ufs = {
          size = "20G";
          content = {
            type = "filesystem";
            format = "ufs";
            mountpoint = "/mnt/freebsd/root";
          };
        };
        freebsd-swap = {
          size = "4G";
          content = {
            type = "swap";
          };
        };
        freebsd-home = {
          size = "30G";
          content = {
            type = "filesystem";
            format = "ufs"; 
            mountpoint = "/mnt/freebsd/home";
          };
        };
      };
    };
  };
  
  boot.loader.grub.extraEntries = ''
    menuentry "FreeBSD 🦬" {
      insmod part_gpt
      insmod ufs2
      search --no-floppy --fs-uuid --set=root [FREEBSD-UUID]
      kfreebsd /boot/kernel/kernel
      kfreebsd_loadenv /boot/device.hints
      set kFreeBSD.vfs.root.mountfrom=ufs:/dev/ada0s1a
    }
  '';
}

# ═══════════════════════════════════════════════════════════════════
# 📁 system-parts/refind.nix - rEFInd Support
# ═══════════════════════════════════════════════════════════════════
{ config, lib, pkgs, ... }: {
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    
    # Custom rEFInd installation
    refind = {
      enable = true;
      configPath = pkgs.writeText "refind.conf" ''
        # FoxOS rEFInd Configuration
        timeout 20
        use_graphics_for linux,grub
        scanfor manual,external,optical,cd,hdbios
        
        # Default boot entry
        default_selection "FoxOS NixOS"
        
        # Hide EFI shell and other tools initially  
        showtools shell,memtest,gdisk,apple_recovery,windows_recovery,about,hidden_tags
        
        # Custom theme
        include themes/foxos-octaquad/theme.conf
        
        # Manual boot entries
        menuentry "FoxOS NixOS" {
            icon /EFI/nixos/icons/os_nixos.png
            volume "FoxOS-Boot"
            loader /EFI/nixos/bzImage
            initrd /EFI/nixos/initrd
            options "init=/nix/store/[NIXOS-INIT-PATH]/init root=/dev/mapper/fox-frostcore"
        }
        
        menuentry "Windows LTSC" {
            icon /EFI/refind/icons/os_win.png
            volume "Windows-Boot"
            loader /EFI/Microsoft/Boot/bootmgfw.efi
        }
        
        menuentry "Parrot Security" {
            icon /EFI/refind/icons/os_linux.png
            volume "Parrot-Boot"
            loader /vmlinuz
            initrd /initrd.img
            options "root=/dev/mapper/parrot-secure ro quiet splash"
        }
        
        menuentry "BlackArch" {
            icon /EFI/refind/icons/os_arch.png
            volume "BlackArch-Boot" 
            loader /vmlinuz-linux
            initrd /initramfs-linux.img
            options "root=/dev/mapper/blackarch-venom rw"
        }
      '';
    };
  };
  
  # rEFInd theme installation
  environment.systemPackages = with pkgs; [
    refind
    (stdenv.mkDerivation {
      name = "foxos-refind-theme";
      src = ./themes/refind/foxos-octaquad;
      installPhase = ''
        mkdir -p $out/share/refind/themes/foxos-octaquad
        cp -r * $out/share/refind/themes/foxos-octaquad/
      '';
    })
  ];
}

# ═══════════════════════════════════════════════════════════════════
# 📁 TEMPLATE GENERATOR SCRIPT
# ═══════════════════════════════════════════════════════════════════

# Usage: Copy any template above, save as .nix file in multiboot-parts/
# Customize device paths, sizes, and UUIDs
# Toggle in teranixagon.nix enabledParts section
# Rebuild and enjoy your new OS!

# 🦊 Standard template structure:
# 1. Disk partitioning (boot + root + optional home/swap)
# 2. LUKS encryption (optional but recommended)
# 3. Filesystem formatting
# 4. Mount points under /mnt/[os-name]/
# 5. Boot loader entry (GRUB or rEFInd)

# 🔧 Quick customization checklist:
# - Change device paths (/dev/sdX)
# - Adjust partition sizes
# - Set encryption passwords
# - Update filesystem types if needed
# - Customize mount points
# - Add boot loader icons/themes