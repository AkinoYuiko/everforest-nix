{ lib, ... }:
let
  catalog = import ./application-theme-catalog.nix { inherit lib; };
in
{
  _class = "homeManager";
  imports = [
    (lib.modules.importApply ../default.nix {
      everforestModules = catalog.moduleFiles;
    })
    (
      { pkgs, ... }:
      let
        platformCatalog = catalog.forHostPlatform pkgs.stdenv.hostPlatform;
      in
      {
        config.everforest = lib.genAttrs (map (entry: entry.name) platformCatalog.ineligible) (_: {
          enable = lib.mkForce false;
        });
      }
    )
  ];
}
