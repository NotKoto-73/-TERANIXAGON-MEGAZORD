{ lib, ... }{

  foxlib = rec {
    meta = import ./meta.nix;
    lib = import ./lib;       # snowfall
    frost = import ./logic;   # native frostfall
  };
  
}
