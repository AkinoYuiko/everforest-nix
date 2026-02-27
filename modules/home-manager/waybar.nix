{ everforestLib, everforestPalette }:
{ config, lib, ... }:
let
  cfg = config.everforest.waybar;
  waybarStyle = lib.concatStringsSep "\n" (
    lib.attrValues (
      lib.mapAttrs (name: value: "@define-color ${name} ${value};")
      everforestPalette
    ));
in
{
  options.everforest.waybar = everforestLib.mkEverforestOption { name = "waybar"; };
  config = lib.mkIf (cfg.enable && config.programs.waybar.enable) {
    programs.waybar.style = lib.mkBefore waybarStyle;
  };
}
