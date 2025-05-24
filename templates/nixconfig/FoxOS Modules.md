# Template: module-template.nix
# Purpose: [Brief description]
# Author: [Your handle]
# Date: [Creation date]
# Dependencies: [List key deps]

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.foxos.modules.[module-name];
  
  # Local definitions
in {
  ###### Interface
  options.foxos.modules.[module-name] = {
    enable = mkEnableOption "FoxOS [Module Name]";
    
    # Additional options
  };

  ###### Implementation
  config = mkIf cfg.enable {
    # Module logic
  };
  
  ###### Metadata
  meta = {
    maintainers = [ "foxleon" ];
    doc = ./README.md;
    category = "system|user|service|theme";
  };
}