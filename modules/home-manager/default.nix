{ lib, config, ... }:
{
  _class = "homeManager";
  imports = [
    (lib.modules.importApply ../default.nix {
      everforestModules =
        if config._module.args.stdenv.hostPlatform.isDarwin then import ./darwin-modules.nix else import ./all-modules.nix;
    })
  ];
}
