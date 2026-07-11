{ everforestLib, everforestPalette }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.everforest.hyprlock;
  hyprThemeFile = pkgs.writeText "everforest.conf" (
    everforestLib.renderHyprPalette everforestPalette
  );
in
{
  options.everforest.hyprlock = everforestLib.mkEverforestOption { name = "hyprlock"; };
  config = lib.mkIf (cfg.enable && config.programs.hyprlock.enable) {
    programs.hyprlock.settings = {
      source = [ "${hyprThemeFile}" ];
    };
  };
}
