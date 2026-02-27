{ lib, pkgs, ... }:
{
  _class = "homeManager";
  imports = [
    (lib.modules.importApply ../default.nix {
      everforestModules =
        if pkgs.stdenv.hostPlatform.isDarwin then import ./darwin-modules.nix else import ./all-modules.nix;
    })
  ];
}
