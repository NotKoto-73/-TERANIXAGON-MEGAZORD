# lib/foxlib.nix — Smart, minimal, and intentionally readable
{ lib, ... }:

rec {
  # Smart device resolver: if it exists in /dev/disk/by-id, use it. Else fallback.
  smartDevice = by: fallback:
    let
      path = "/dev/disk/by-id/${by}";
    in
      if builtins.pathExists path then path else fallback;

  # Simple option with default & doc — minimal interface
  mkFoxOption = description: def: {
    type = lib.types.str;
    default = def;
    description = description;
  };

  # Conditional enabler — reads clearer than mkIf
  enableIf = cond: value: if cond then value else {};

  # Debug helper — opt-in echo for introspection
  debugLog = msg: lib.warn "🐾 [foxlib] ${msg}" null;

  # Quick merge with enableIf
  when = cond: block: lib.mkIf cond block;

  # Plural option patterns
  stringList = {
    type = lib.types.listOf lib.types.str;
    default = [];
  };
}
