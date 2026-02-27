{ lib, ... }:
{
  _class = "homeManager";
  imports = [
    (lib.modules.importApply ../default.nix { everforestModules = import ./all-modules.nix; } )
  ];
}
