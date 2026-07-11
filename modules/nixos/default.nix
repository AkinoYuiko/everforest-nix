{ lib, ... }:
{
  _class = "nixos";
  imports = [
    (lib.modules.importApply ../default.nix {
      everforestModuleDescriptors = [
        {
          file = ./tty.nix;
          applicationThemeNames = [ "tty" ];
        }
      ];
    })
  ];
}
