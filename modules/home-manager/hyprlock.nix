{
  applicationThemeNames,
  everforestLib,
  everforestPalette,
}:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  applicationThemeName =
    if builtins.length applicationThemeNames == 1 then
      builtins.head applicationThemeNames
    else
      throw "Home Manager single-theme module expected exactly one Application Theme name";
  cfg = config.everforest.${applicationThemeName};
  hyprThemeFile = pkgs.writeText "everforest.conf" (
    everforestLib.renderHyprPalette everforestPalette
  );
in
{
  options.everforest.${applicationThemeName} = everforestLib.mkEverforestOption {
    name = applicationThemeName;
  };
  config = lib.mkIf (cfg.enable && config.programs.hyprlock.enable) {
    programs.hyprlock.settings = {
      source = [ "${hyprThemeFile}" ];
    };
  };
}
