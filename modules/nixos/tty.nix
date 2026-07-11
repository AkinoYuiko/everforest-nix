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
      throw "NixOS single-theme module expected exactly one Application Theme name";
  cfg = config.everforest.${applicationThemeName};
in
{
  options.everforest.${applicationThemeName} = everforestLib.mkEverforestOption {
    name = applicationThemeName;
  };
  config = lib.mkIf cfg.enable {
    console.colors = lib.mkDefault (
      map (color: (lib.substring 1 6 everforestPalette.${color})) [
        "bg0"
        "red"
        "green"
        "yellow"
        "blue"
        "purple"
        "aqua"
        "fg"
        "bg3"
        "red"
        "green"
        "yellow"
        "blue"
        "purple"
        "aqua"
        "fg"
      ]
    );
  };
}
