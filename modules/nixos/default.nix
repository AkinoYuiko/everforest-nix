{ lib, ... }:
{
  _class = "nixos";
  imports = [
    (lib.modules.importApply ../default.nix { everforestModules = import ./all-modules.nix; } )
  ];
}
