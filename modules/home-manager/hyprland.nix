{ everforestLib, everforestPalette }:
{ config, lib, pkgs, ... }:
let
  cfg = config.everforest.hyprland;
  hyprThemeFile = pkgs.writeText "everforest.conf" (lib.concatStringsSep "\n" (
    lib.attrValues (
      lib.mapAttrs (name: color: "\$${name} = rgb(${color})")
      (lib.mapAttrs (name: _: (lib.substring 1 6 everforestPalette.${name})) everforestPalette)
    )));
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
