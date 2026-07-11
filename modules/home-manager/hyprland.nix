{ everforestLib, everforestPalette }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.everforest.hyprland;
  hyprThemeFile = pkgs.writeText "everforest.conf" (
    everforestLib.renderHyprPalette everforestPalette
  );
in
{
  options.everforest.hyprland = everforestLib.mkEverforestOption { name = "hyprland"; };
  config = lib.mkIf (cfg.enable && config.wayland.windowManager.hyprland.enable) {
    wayland.windowManager.hyprland.settings = {
      source = [ "${hyprThemeFile}" ];
    };
    home.sessionVariables = lib.mkIf config.everforest.cursor.enable {
      HYPRCURSOR_SIZE = config.home.pointerCursor.size;
      HYPRCURSOR_THEME = config.home.pointerCursor.name;
    };
  };
}
