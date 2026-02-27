{ everforestLib, ... }:
{ config, lib, pkgs, ... }:
let
	cfg = config.everforest.yazi;
	everforest-medium-yazi =  pkgs.fetchFromGitHub {
		owner = "Chromium-3-Oxide";
		repo = "everforest-medium.yazi";
		rev = "3d5f8471fa6d5c2130d8a980b4ef48d8c5c8521d";
		hash = "sha256-FXg++wVSGrJZnYodzkS4eVIeQE1xm8o0urnoInqfP5g=";
	};
in
{
	options.everforest.yazi = everforestLib.mkEverforestOption { name = "yazi"; };
	config = lib.mkIf (cfg.enable && config.programs.yazi.enable) {
		programs.yazi = {
			flavors = { everforest-medium = "${everforest-medium-yazi}"; };
			theme.flavor = {
				dark = "everforest-medium";
				light = "everforest-medium";
				use = "everforest-medium";
			};
		};
	};
}
