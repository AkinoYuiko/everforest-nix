{ lib, pkgs, ... }:
{
  _class = "homeManager";
  imports = [
    (lib.modules.importApply ../default.nix {
      everforestModules = (lib.optional (pkgs.stdenv.isLinux) ./all-modules.nix) (
        lib.optional (pkgs.stdenv.isDarwin) ./darwin-modules.nix
      );
    })
  ];
}
