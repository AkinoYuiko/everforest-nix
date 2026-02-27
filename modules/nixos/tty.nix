{ everforestLib, everforestPalette }:
{ config, lib, ... }:
let
  cfg = config.everforest.tty;
in
{
  options.everforest.tty = everforestLib.mkEverforestOption { name = "tty"; };
  config = lib.mkIf cfg.enable {
    console.colors = lib.mkDefault (map (color: (lib.substring 1 6 everforestPalette.${color})) [
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
    ]);
  };
}
