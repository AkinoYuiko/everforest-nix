{ everforestLib, everforestPalette }:
{ config, lib, ... }:
let
  cfg = config.everforest.starship;
in
{
  options.everforest.starship = everforestLib.mkEverforestOption { name = "starship"; };
  config = {
    programs.starship.settings = lib.mkIf (cfg.enable && config.programs.starship.enable) {
      palettes = {
        everforest = everforestPalette;
      };
      palette = lib.mkDefault "everforest";
    };
  };
}
