{ everforestLib, everforestPalette }:
{ config, lib, ... }:
let
  cfg = config.everforest.ghostty;
  palette = lib.mapAttrs (name: _: (lib.substring 1 6 everforestPalette.${name})) everforestPalette;
in
{
  options.everforest.ghostty = everforestLib.mkEverforestOption { name = "ghostty"; };
  config = lib.mkIf (cfg.enable && config.programs.ghostty.enable) {
    programs.ghostty.themes = {
      everforest = {
        background = palette.bg0;
        cursor-color = palette.green;
        foreground = palette.fg;
        palette = lib.imap (i: color:
          let index = i - 1; in
            "${toString index}" + "=#" + palette.${color}
        )[
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
