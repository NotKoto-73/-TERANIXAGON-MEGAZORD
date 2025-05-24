# lib/default.nix
{ lib }:
{
  vulpes = import ./vulpes.nix { inherit lib; };
  # future fox tools go here
}   
    
