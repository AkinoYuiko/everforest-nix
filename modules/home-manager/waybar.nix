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
  waybarStyle = lib.concatStringsSep "\n" (
    lib.attrValues (lib.mapAttrs (name: value: "@define-color ${name} ${value};") everforestPalette)
  );
in
{
  options.everforest.${applicationThemeName} = everforestLib.mkEverforestOption {
    name = applicationThemeName;
  };
  config = lib.mkIf (cfg.enable && config.programs.waybar.enable) {
    programs.waybar.style = lib.mkBefore waybarStyle;
  };
}
