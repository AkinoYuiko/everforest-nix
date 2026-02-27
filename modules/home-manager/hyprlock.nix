{ everforestLib, everforestPalette }:
{ config, lib, pkgs, ... }:
let
  cfg = config.everforest.hyprlock;
  hyprThemeFile = pkgs.writeText "everforest.conf" (lib.concatStringsSep "\n" (
    lib.attrValues (
      lib.mapAttrs (name: color: "\$${name} = rgb(${color})")
      (lib.mapAttrs (name: _: (lib.substring 1 6 everforestPalette.${name})) everforestPalette)
    )));
in
{
  options.everforest.hyprlock = everforestLib.mkEverforestOption { name = "hyprlock"; };
  config = lib.mkIf (cfg.enable && config.programs.hyprlock.enable) {
    programs.hyprlock.settings = {
      source = [ "${hyprThemeFile}" ];
    };
  };
}
