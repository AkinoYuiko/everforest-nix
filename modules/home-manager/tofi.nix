{ everforestLib, everforestPalette }:
{ config, lib, ... }:
let
	cfg = config.everforest.tofi;
in
{
	options.everforest.tofi = everforestLib.mkEverforestOption { name = "tofi"; };
	config = lib.mkIf (cfg.enable && config.programs.tofi.enable) {
		programs.tofi.settings = {
			background-color = everforestPalette.bg0;
			text-color = everforestPalette.fg;
			prompt-background = everforestPalette.green;
			prompt-color = everforestPalette.bg0;
			input-background = everforestPalette.bg0;
			input-color = everforestPalette.fg;
			selection-background = everforestPalette.bg4;
			selection-color = everforestPalette.green;
			selection-match-color = everforestPalette.red;
			placeholder-background = everforestPalette.bg0;
			placeholder-color = everforestPalette.grey0;
			default-result-background = everforestPalette.bg0;
			default-result-color = everforestPalette.fg;
			alternate-result-background = everforestPalette.bg0;
			alternate-result-color = everforestPalette.fg;
			text-cursor-background = everforestPalette.bg0;
			text-cursor-color = everforestPalette.green;
			outline-color = everforestPalette.green;
			border-color = everforestPalette.green;
		};
	};
}

