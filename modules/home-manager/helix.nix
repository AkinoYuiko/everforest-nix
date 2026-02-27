{ everforestLib, ... }:
{ config, lib, ... }:
let
  cfg = config.everforest.helix;
in
{
  options.everforest.helix = everforestLib.mkEverforestOption { name = "helix"; };
  config = lib.mkIf (cfg.enable && config.programs.helix.enable) {
    programs.helix.settings.theme = lib.mkDefault "everforest_dark";
  };
}
