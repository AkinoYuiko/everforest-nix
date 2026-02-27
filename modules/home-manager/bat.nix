{ everforestLib, everforestPalette }:
{ pkgs, config, lib, ... }:
let
  cfg = config.everforest.bat;
  fileName = "everforest.tmTheme";
in
{
  options.everforest.bat = everforestLib.mkEverforestOption { name = "bat"; };
  config = lib.mkIf (cfg.enable && config.programs.bat.enable) {
    xdg.configFile."bat/themes/${fileName}".text = lib.readFile ../../pkgs/bat/everforest.tmTheme;
    programs.bat = {
      config.theme = lib.mkDefault "everforest"; 
    };
  };
}
