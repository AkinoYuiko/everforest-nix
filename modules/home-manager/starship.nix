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
  config = {
    programs.starship.settings = lib.mkIf (cfg.enable && config.programs.starship.enable) {
      palettes = {
        everforest = everforestPalette;
      };
      palette = lib.mkDefault "everforest";
    };
  };
}
