{ applicationThemeNames, everforestLib, ... }:
{ config, lib, ... }:
let
  cfg = config.everforest;
  identifier = "dlcadbmcfambdjhecipbnolmjchgnode";
  browserNames =
    if applicationThemeNames != [ ] then
      applicationThemeNames
    else
      throw "Home Manager multi-theme module expected at least one Application Theme name";
  generateConfig =
    browser:
    lib.mkIf (cfg.${browser}.enable && config.programs.${browser}.enable) {
      programs.${browser}.extensions = [ { id = identifier; } ];
    };
in
{
  options.everforest = lib.genAttrs browserNames (
    name: everforestLib.mkEverforestOption { inherit name; }
  );
  config = lib.mkMerge (map generateConfig browserNames);
}
