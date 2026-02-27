{ everforestLib, ... }:
{ config, lib, ... }:
let
  cfg = config.everforest;
  identifier = "dlcadbmcfambdjhecipbnolmjchgnode";
  supportedBrowsers = [
    "brave"
    "chromium"
    "vivaldi"
  ];
  generateConfig =
    browser:
    lib.mkIf (cfg.${browser}.enable && config.programs.${browser}.enable) {
      programs.${browser}.extensions = [ { id = identifier; } ];
    };
  in
  {
    options.everforest = lib.genAttrs supportedBrowsers (
      name: everforestLib.mkEverforestOption { inherit name; }
    );
    config = lib.mkMerge (map generateConfig supportedBrowsers);
  }
