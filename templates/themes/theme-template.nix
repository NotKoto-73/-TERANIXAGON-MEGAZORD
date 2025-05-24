# ./nixos/desktop/theming/bootloader/template/theme_template.nix
#
# FoxOS rEFInd Theme Module Template
# ------------------------------------
# INSTRUCTIONS:
# 1. Copy this file to a new directory, e.g., .../bootloader/mytheme/mytheme.nix
# 2. Replace all instances of `<ThemeName>` with your theme's PascalCase name (e.g., `CyberFox`).
# 3. Replace all instances of `<themename>` with your theme's kebab-case or snake_case name (e.g., `cyber-fox`). This will be used for file paths and option names.
# 4. Update the `options.foxos...` path to match the final location of your theme module.
# 5. Define your theme's `colors` in the let block.
# 6. Implement the `pkgs.runCommand` blocks to generate your theme assets (banner, icons, selection). Replace the placeholder derivations. Use ImageMagick or other tools as needed.
# 7. Customize the `themeConfContent` with your theme's specific rEFInd settings, referencing your generated assets via their *rEFInd paths* (e.g., `EFI/refind/themes/<themename>/banner.png`).
# 8. Ensure the `themePackage` derivation correctly copies all generated assets into the `$out/EFI/refind/themes/<themename>/` structure.
# 9. Add necessary `buildInputs` (like `pkgs.imagemagick`) to the `themePackage` derivation.
# 10. Update the `meta` information.
# 11. Register your theme in the main bootloader theme aggregator module (e.g., .../bootloader/default.nix or .../bootloader-final.nix)

{ config, pkgs, lib, ... }:

let
  # Define the path for this theme's options based on its location
  # !! IMPORTANT: UPDATE this path prefix if you place the theme elsewhere !!
  optionPath = config.foxos.desktop.theming.bootloader.custom."<themename>"; # Example path
  cfg = optionPath;

  # ----- 🎨 Theme Color Palette ----- #
  # TODO: Define your theme's color palette here
  colors = {
    background = "#2d2d2d";
    primary = "#ff5733";
    secondary = "#33ff57";
    accent = "#3357ff";
    text = "#f0f0f0";
    highlightBg = "rgba(255, 87, 51, 0.4)"; # Example semi-transparent
  };

  # ----- 🖼️ Asset Generation ----- #

  # TODO: Implement helpers for procedural generation if needed (e.g., makeIcon)
  # Example Helper (borrowed from Gemini theme, adapt as needed):
  # makeIcon = { name, symbol ? "", bgColor ? colors.primary, fgColor ? colors.text, size ? 128 }:
  #   pkgs.runCommand "<themename>-icon-${name}" { buildInputs = [ pkgs.imagemagick pkgs.coreutils ]; } ''
  #     convert -size ${toString size}x${toString size} xc:none \
  #       -fill "${bgColor}" -draw "roundrectangle 0,0 ${toString size},${toString size} 20,20" \
  #       # ... (rest of imagemagick commands) ...
  #       $out/icon.png
  #   '';

  # --- Placeholder Asset Derivations ---
  # !! IMPORTANT: Replace these placeholders with actual asset generation logic !!
  banner = pkgs.runCommand "<themename>-banner-placeholder" {} ''mkdir -p $out; echo "Replace me" > $out/banner.png'';
  selection_big = pkgs.runCommand "<themename>-sel-big-placeholder" {} ''mkdir -p $out; echo "Replace me" > $out/selection_big.png'';
  selection_small = pkgs.runCommand "<themename>-sel-small-placeholder" {} ''mkdir -p $out; echo "Replace me" > $out/selection_small.png'';
  # icon helpers might create these:
  icon_foxos = pkgs.runCommand "<themename>-icon-foxos-placeholder" {} ''mkdir -p $out; echo "Replace me" > $out/os_foxos.png'';
  icon_nixos_gen = pkgs.runCommand "<themename>-icon-nixos-gen-placeholder" {} ''mkdir -p $out; echo "Replace me" > $out/os_nixos_gen.png'';
  icon_arch = pkgs.runCommand "<themename>-icon-arch-placeholder" {} ''mkdir -p $out; echo "Replace me" > $out/os_arch.png'';
  icon_garuda = pkgs.runCommand "<themename>-icon-garuda-placeholder" {} ''mkdir -p $out; echo "Replace me" > $out/os_garuda.png'';
  logo = pkgs.runCommand "<themename>-logo-placeholder" {} ''mkdir -p $out; echo "Replace me" > $out/logo.png'';


  # ----- 📜 Theme Configuration File Content ----- #
  themeConfContent = let
    # Fetch global settings (ensure these options exist in your main config)
    timeoutValue = toString (config.foxos.desktop.theming.bootloader.timeout or 5);
    resolutionValue = config.foxos.desktop.theming.bootloader.resolution or "1920x1080";
    # You can also reference theme-specific options from `cfg` here if needed
    # exampleVariant = cfg.variant or "default";
  in pkgs.writeText "theme.conf" ''
    # rEFInd Theme: <ThemeName> - Generated for FoxOS
    # --------------------------------------------------

    # Basic Settings
    resolution ${resolutionValue}
    timeout ${timeoutValue}
    use_graphics_for linux,grub
    hideui hints,label,singleuser,arrows,badges

    # Banner/Background
    banner EFI/refind/themes/<themename>/banner.png
    banner_scale fillscreen

    # Icons & Font
    icons_dir EFI/refind/themes/<themename>/icons
    icon_size 128 # TODO: Adjust if needed
    small_icon_size 48 # TODO: Adjust if needed
    font ${pkgs.ubuntu_font_family}/share/fonts/truetype/Ubuntu-Regular.ttf # TODO: Change font if desired

    # Colors
    text_color ${colors.text} # TODO: Adjust
    # TODO: Add other color settings (menu_color, etc.) if needed

    # Selection Highlight
    selection_big EFI/refind/themes/<themename>/selection_big.png
    selection_small EFI/refind/themes/<themename>/selection_small.png
    selection_background none # Use graphic alpha usually

    # Optional Logo
    # banner_logo EFI/refind/themes/<themename>/logo.png
    # banner_logo_pos 50% 10%

    # ---- Placeholder Menu Entries ----
    # It's often better to define main menu entries in the central
    # refind module configuration for consistency across themes.
    # Only include entries here if they are *highly specific* to this theme.
    menuentry "🦊 FoxOS (<ThemeName>)" {
        icon os_foxos.png
        loader /EFI/nixos/grubx64.efi # Adjust loader path as needed
    }
    menuentry "❄️ NixOS Generations (<ThemeName>)" {
        icon os_nixos_gen.png
        loader /EFI/boot/bootx64.efi # Adjust as needed
    }
    # TODO: Add theme-specific settings below, if any

  '';


  # ----- 📦 Theme Package Derivation ----- #
  themePackage = pkgs.stdenv.mkDerivation {
    name = "refind-theme-<themename>";
    src = ./.; # Not really used when generating assets

    # TODO: Add necessary build inputs (imagemagick, fonts if generating glyphs, etc.)
    buildInputs = [ pkgs.makeWrapper ];

    # Pass paths of generated assets to the builder script
    inherit banner selection_big selection_small themeConfContent logo;
    # Pass icon paths
    inherit icon_foxos icon_nixos_gen icon_arch icon_garuda;

    installPhase = ''
      THEME_DIR=$out/EFI/refind/themes/<themename>
      ICON_DIR=$THEME_DIR/icons
      mkdir -p $ICON_DIR

      echo "Installing <ThemeName> theme assets..."

      # Copy main assets
      cp ${banner}/*.png $THEME_DIR/banner.png
      cp ${selection_big}/*.png $THEME_DIR/selection_big.png
      cp ${selection_small}/*.png $THEME_DIR/selection_small.png
      cp ${logo}/*.png $THEME_DIR/logo.png # If using a logo

      # Copy generated OS icons
      cp ${icon_foxos}/*.png $ICON_DIR/os_foxos.png
      cp ${icon_nixos_gen}/*.png $ICON_DIR/os_nixos_gen.png
      cp ${icon_arch}/*.png $ICON_DIR/os_arch.png # Add more as needed
      cp ${icon_garuda}/*.png $ICON_DIR/os_garuda.png # Add more as needed
      # TODO: Add commands to copy any other custom icons (tools, etc.)

      # Write the configuration file
      cp ${themeConfContent} $THEME_DIR/theme.conf

      echo "<ThemeName> Theme installed to $out"
    '';

    # Prevent checks from failing on placeholder sources
    dontStrip = true;
    dontPatchELF = true;
    dontFixup = true;

    meta = {
      description = "rEFInd Theme: <ThemeName> for FoxOS";
      # TODO: Update license if necessary
      license = lib.licenses.mit;
      # TODO: Update platforms if needed
      platforms = lib.platforms.all;
      # TODO: Add maintainer info
      # maintainers = [ lib.maintainers.yourGithubHandle ];
    };
  };

in
{
  # ----- Options Definition ----- #
  options = {
    # Adjust the path here based on the final directory structure
    # e.g., foxos.desktop.theming.bootloader.custom."<themename>"
    ${lib.strings.removeSuffix "." (lib.concatMapStringsSep "." (x: x) (lib.splitString "." "foxos.desktop.theming.bootloader.custom.<themename>"))} = {
      enable = lib.mkEnableOption "Enable the <ThemeName> rEFInd theme.";

      # TODO: Add theme-specific options here if needed
      # variant = lib.mkOption {
      #   type = lib.types.enum [ "light" "dark" ];
      #   default = "dark";
      #   description = "<ThemeName> color variant.";
      # };
    };
  };

  # ----- Configuration Activation ----- #
  config = lib.mkIf cfg.enable {
    # Register this theme so it can be selected
    foxos.desktop.theming.bootloader.availableThemes."<themename>" = {
      name = "<themename>"; # Used by refind `include themes/<themename>/theme.conf`
      package = themePackage;
      description = "<ThemeName>: A custom theme for FoxOS."; # TODO: Add better description
    };

    # == IMPORTANT ==
    # The logic below SHOULD IDEALLY LIVE IN THE MAIN BOOTLOADER/THEMING MODULE (`.../bootloader-final.nix`),
    # not within each individual theme module. This avoids conflicts and duplication.
    # Keep these commented out here for reference, but implement the activation in the aggregator.
    #
    # // Example logic for the main theme module:
    # environment.systemPackages = lib.mkIf (config.foxos.desktop.theming.bootloader.selectedTheme == "<themename>") [
    #   themePackage # Ensure assets are in the Nix store
    #   # Add runtime deps like fonts if needed: pkgs.ubuntu_font_family
    # ];
    #
    # boot.loader.refind.extraConfig = lib.mkIf (config.foxos.desktop.theming.bootloader.selectedTheme == "<themename>") ''
    #   include themes/<themename>/theme.conf
    # '';
    #
    # // Linking the theme package to the ESP is also handled by the main module, e.g.:
    # boot.loader.refind.extraFilesToCopy = lib.mkIf (isSelected "<themename>") [
    #  {
    #    source = "${themePackage}/EFI/refind/themes/<themename>";
    #    target = "EFI/refind/themes/<themename>";
    #  }
    # ];

  };
}
