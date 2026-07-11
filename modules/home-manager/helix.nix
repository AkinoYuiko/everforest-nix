{ applicationThemeNames, everforestLib, ... }:
{ config, lib, ... }:
let
  applicationThemeName =
    if builtins.length applicationThemeNames == 1 then
      builtins.head applicationThemeNames
    else
      throw "Home Manager single-theme module expected exactly one Application Theme name";
  cfg = config.everforest.${applicationThemeName};
in
{
  options.everforest.${applicationThemeName} = everforestLib.mkEverforestOption {
    name = applicationThemeName;
  };
  config = lib.mkIf (cfg.enable && config.programs.helix.enable) {
    programs.helix.settings.theme = lib.mkDefault "everforest_dark";
  };
}
