{
  applicationThemeNames,
  everforestLib,
  everforestPalette,
}:
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
  config = lib.mkIf (cfg.enable && config.programs.rofi.enable) {
    programs.rofi.theme = lib.mkBefore {
      "*" = everforestPalette;
    };
  };
}
