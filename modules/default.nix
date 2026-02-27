{ everforestModules }:
{ pkgs, config, lib, ... }:
let
  everforestLib = import ./lib { inherit pkgs config lib; };
  everforestPalette = import ../palette;  
in
{
  options.everforest = {
    enable = lib.mkEnableOption "everforest globally";
    palette = lib.mkOption {
      default = everforestPalette;
      readOnly = true;
      type = lib.types.attrsOf lib.types.str;
      description = "The Everforest theme's palette.";
    };
  };
  imports = map (module: lib.modules.importApply module {
    everforestLib = everforestLib;
    everforestPalette = everforestPalette;
  } ) everforestModules;
}
