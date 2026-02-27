{ everforestLib, everforestPalette }:
{ config, lib, ... }:
let
	cfg = config.everforest.rofi;
in
{
	options.everforest.rofi = everforestLib.mkEverforestOption { name = "rofi"; };
	config = lib.mkIf (cfg.enable && config.programs.rofi.enable){
		programs.rofi.theme = lib.mkBefore {
			"*" = everforestPalette;
		};
	};
}
