
{ config, lib, pkgs, ... }:

{
  system.activationScripts.pruneSystemGenerations = {
    text = ''
      ${pkgs.nix}/bin/nix-env \
        --profile /nix/var/nix/profiles/system \
        --delete-generations +5
    '';
  };
}

