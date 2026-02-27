{ everforestLib, everforestPalette }:
{ config, lib, ... }:
let
  cfg = config.everforest.fzf;
in
{
  options.everforest.fzf = everforestLib.mkEverforestOption { name = "fzf"; };
  config = lib.mkIf (cfg.enable && config.programs.fzf.enable) {
    programs.fzf.colors = lib.mkDefault {
      bg = everforestPalette.bg0;
      "bg+" = everforestPalette.bg4;
      fg = everforestPalette.fg;
      "fg+" = everforestPalette.green;
      hl = everforestPalette.red;
      "hl+" = everforestPalette.red;
      gutter = everforestPalette.bg4;
      separator = everforestPalette.bg4;
      border = everforestPalette.bg4;
      spinner = everforestPalette.yellow;
      disabled = everforestPalette.grey1;
      info = everforestPalette.blue;
      header = everforestPalette.grey1;
      marker = everforestPalette.green;
      prompt = everforestPalette.green;
      pointer = everforestPalette.green;
    };
  };
}
