# lib/vulpes.nix
# foxOS smart module import + toggle utils

{ lib }:

rec {
  # Toggle import based on a single condition (true → import path)
  toggle = condition: path:
    if condition then [ path ] else [ ];

  # Toggle multiple modules by matching lists of conditions and paths
  toggles = conditions: paths:
    lib.flatten (lib.zipListsWith toggle conditions paths);

  # Import if the file exists (optional)
  optionalImport = path:
    if builtins.pathExists path then [ path ] else [ ];

  # Import many files if they exist
  optionalImports = paths:
    lib.flatten (builtins.map optionalImport paths);

  # Smart toggle or optional fallback if the condition is not a boolean
  auto = value: path:
    if lib.isBool value then toggle value path else optionalImport path;

  # Smart list of auto toggle/optionals
  autos = values: paths:
    lib.flatten (lib.zipListsWith auto values paths);

  # Unified wrapper to feed into `imports = lib.concatLists [ ... ];`
  imports = chunks:
    lib.concatLists (builtins.map (
      x:
        if lib.isList x then x
        else if lib.isBool x then toggle x
        else optionalImport x
    ) chunks);
}


