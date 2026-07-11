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
  palette = lib.mapAttrs (name: _: (lib.substring 1 6 everforestPalette.${name})) everforestPalette;
in
{
  options.everforest.${applicationThemeName} = everforestLib.mkEverforestOption {
    name = applicationThemeName;
  };
  config = lib.mkIf (cfg.enable && config.programs.ghostty.enable) {
    programs.ghostty.themes = {
      everforest = {
        background = palette.bg0;
        cursor-color = palette.green;
        foreground = palette.fg;
        palette =
          lib.imap
            (
              i: color:
              let
                index = i - 1;
              in
              "${toString index}" + "=#" + palette.${color}
            )
            [
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
            ];
        selection-background = palette.bg3;
        selection-foreground = palette.fg;
      };
    };
    programs.ghostty.settings = {
      theme = lib.mkDefault "everforest";
    };
  };
}
